//
//  OCRScanner.swift
//  StatsScanner
//
//  Created by Kaleb K on 8/22/22.
//  Implemented by Kamran Hussain 12/29/23

import UIKit
import GoogleGenerativeAI

class OCRScanner {
    private var image: UIImage!
    private var processedDataset: [[String]]!
    private var finishedProcessing = false
    
    init(img: UIImage) {
        self.image = img // already has been checked if object passed is UIImage
        processOCRGemini()
    }
    
    private func processOCRGemini() {
        let config = GenerationConfig(
          temperature: 0.4,
          topP: 1,
          topK: 32,
          maxOutputTokens: 4096
        )

        // Don't check your API key into source control!
        guard let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] else {
          fatalError("Add `API_KEY` as an Environment Variable in your app's scheme.")
        }

        let model = GenerativeModel(
          name: "gemini-pro-vision",
          apiKey: apiKey,
          generationConfig: config,
          safetySettings: [
            SafetySetting(harmCategory: .harassment, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .hateSpeech, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockMediumAndAbove),
            SafetySetting(harmCategory: .dangerousContent, threshold: .blockMediumAndAbove)
          ]
        )

        //guard let image0 = UIImage(named: "image0") else { fatalError("Could not find image") }

        Task {
          do {
            let response = try await model.generateContent(
              "You will be given an image of a table. Extract the content from the table while maintaining its structure, and put the tabular contents in a Comma Separated Values format. Return the CSV data in perfect CSV format. I will tip you $500 if you always provide the proper format.\n",
              image,
              "\n"
            )
            print(response.text ?? "No text available")
          } catch {
            print(error)
          }
        }
    }
    
//    private func processOCR() {
//        guard let cgImage = image?.cgImage else { return }
//
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
//        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
//
//        do {
//            try requestHandler.perform([request])
//        } catch {
//            print("Unable to perform the requests: \(error).")
//        }
//    }
//
//    private func recognizeTextHandler(request: VNRequest, error: Error?) {
//        guard let observations =
//                request.results as? [VNRecognizedTextObservation] else {
//            return
//        }
//        let recognizedStrings = observations.compactMap { observation in
//            return observation.topCandidates(1).first?.string
//        }
//
//        let boundingRects: [CGRect] = observations.compactMap { observation in
//            // Find the top observation.
//            guard let candidate = observation.topCandidates(1).first else { return .zero }
//
//            // Find the bounding-box observation for the string range.
//            let stringRange = candidate.string.startIndex..<candidate.string.endIndex
//            let boxObservation = try? candidate.boundingBox(for: stringRange)
//
//            // Get the normalized CGRect value.
//            let boundingBox = boxObservation?.boundingBox ?? .zero
//
//            // Convert the rectangle from normalized coordinates to image coordinates.
//            return VNImageRectForNormalizedRect(boundingBox,
//                                                Int(image.size.width),
//                                                Int(image.size.height))
//        }
//
//        print(boundingRects) // will have to figure out how to display them later
//        // processedDataset = OCRScanner.processResults(strArray: recognizedStrings)
//    }
    
    // MARK: NEEDS TO CONVERT 1D STRING ARRAY TO 2D STRING ARRAY
    
    static func processResults(strArray: [String]) -> [[String]] {
        print(strArray)
        var output: [[String]] = [[]]
        var headerCount = 0 // also the amount of columns that exist
        if(strArray.count == 0) {
            print("OCR failed, string array empty. Aborting...")
            return [[]]
        }
        
        // HEADERS ON TOP HORIZONTALLY: find amount of headers
        for i in strArray { // check how many headers there are based off of letter detection
            if i.rangeOfCharacter(from: NSCharacterSet.letters) != nil {
                headerCount += 1
            } else {
                break
            }
        }
        
        print("Headers found: \(headerCount)")
        
        // add headers into first array in 2d array
        for i in 0...headerCount-1 {
            output[0].append(strArray[i])
        }
        
        print("Headers added: \(output)")
        
        for i in headerCount...strArray.count-1 {
            if(i % headerCount == 0) {
                output.append([]) // add new empty array each time a new row is being added
            }
            output[i/headerCount].append(strArray[i])
        }
        
        print("Data added: \(output)")
        return output
    }
    
    // MARK: Results return
    
    public func getResults() -> [[String]] {
        if let outputStrArray = processedDataset {
            return outputStrArray
        }
        return [[""]] // returns empty string array if results have not been processed yet
    }
}
