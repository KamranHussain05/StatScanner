//
//  OCRScanner.swift
//  StatsScanner
//
//  Created by Kaleb K on 8/22/22.
//

import UIKit
import Vision

class OCRScanner {
    private var image: UIImage!
    private var processedDataset: [[String]]!
    private var finishedProcessing = false
    
    init(img: UIImage) {
        self.image = img // already has been checked if object passed is UIImage
        processOCR()
    }
    
    private func processOCR() {
        guard let cgImage = image?.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }
        
        let boundingRects: [CGRect] = observations.compactMap { observation in
            // Find the top observation.
            guard let candidate = observation.topCandidates(1).first else { return .zero }
            
            // Find the bounding-box observation for the string range.
            let stringRange = candidate.string.startIndex..<candidate.string.endIndex
            let boxObservation = try? candidate.boundingBox(for: stringRange)
            
            // Get the normalized CGRect value.
            let boundingBox = boxObservation?.boundingBox ?? .zero
            
            // Convert the rectangle from normalized coordinates to image coordinates.
            return VNImageRectForNormalizedRect(boundingBox,
                                                Int(image.size.width),
                                                Int(image.size.height))
        }
        print(boundingRects) // will have to figure out how to display them later
        processResults(strArray: recognizedStrings)
    }
    
    // MARK: NEEDS TO CONVERT 1D STRING ARRAY TO 2D STRING ARRAY
    private func processResults(strArray: [String]) {
        print(strArray)
        var output: [[String]] = [[]]
        var headerCount = 0 // also the amount of columns that exist
        if(strArray.count == 0) {
            print("OCR failed, string array empty. Aborting...")
            return
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
        
        processedDataset = output
    }
    
    public func getResults() -> [[String]] {
        if let outputStrArray = processedDataset {
            return outputStrArray
        }
        return [[""]] // returns empty string array if results have not been processed yet
    }
}
