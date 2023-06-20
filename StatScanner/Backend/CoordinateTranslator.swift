//
//  CoordinateTranslator.swift
//  StatScanner
//
//  Created by Caden Pun on 4/6/23.
//

import Foundation
import Vision
import VisionKit

class CoordinateTransformer {
    
    private var coor : [[[Float]]]!
    private var data : [[String]]!
    private var img : CGImage!
    private var currentString : String!
    private var textRecRequest = VNRecognizeTextRequest()
    private var requestHandler : VNImageRequestHandler!
    
    // Executes a procedure with internal helper functions to run OCR on every data point.
    init(coor: [[[Float]]], img: UIImage!) {
        self.coor = coor
        self.img = img.cgImage
        
        self.textRecRequest = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        self.textRecRequest.recognitionLevel = .accurate
        self.textRecRequest.usesLanguageCorrection = true
        
        self.requestHandler = VNImageRequestHandler(cgImage: self.img)
        shapeData()
        processingCoordinates()
    }
    
    func scanShit(i: Int, j: Int) {
        let box = coor[i][j]
        let x1 = box[0]
        let y1 = box[1]
        let x2 = box[2]
        let y2 = box[3]
        
        let region = CGRect(x: Double(x1), y: Double(y1), width: Double(x2-x1), height: Double(y2-y1))
        print(region.debugDescription.stringArray)
        self.textRecRequest.regionOfInterest = region
        
        do {
            // Perform the text-recognition request.
            currentString = ""
            try self.requestHandler.perform([self.textRecRequest])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
        
    }

    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        // Process the recognized strings.
        processResults(recognizedStrings)
    }
    
    func processResults(_ text: [String]) {
        print(text)
        for item in text{
            currentString += item
        }
    }
    
    func processingCoordinates() {
        for i in 0..<coor.count {
            for j in 0..<coor[i].count {
                scanShit(i: i, j: j)
                data[i][j] = currentString
                currentString = ""
            }
        }
    }
    
    func shapeData() {
        print(coor.count, coor[0].count, coor[0][0].count)
        self.data = Array(repeating: Array(repeating: "empty", count: coor[0].count), count: coor.count)
        print(data.count, data[0].count)
              
    }
    
    func result()-> [[String]] {
        return self.data
    }
}
