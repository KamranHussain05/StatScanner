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
    
    private var coor : [[Float]]!
    private var data : [[String]]!
    private var img : UIImage!
    private var currentString : String!
    
    init(coor: [[Float]], img: UIImage!) {
        self.coor = coor
        self.img = img
        shapeData()
        processingCoordinates()
    }
    
    func scanshit(i: Int, j: Int, count: Int) {
        let box = coor[count]
        let x1 = box[0]
        let y1 = box[1]
        let x2 = box[2]
        let y2 = box[3]
        let cropped = img.ciImage?.cropped(to: CGRect(x: Double(x1), y: Double(y1), width: Double(x2-x1), height: Double(y2-y1)))
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cropped as! CGImage)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
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
        currentString = recognizedStrings.first!
    }
    
    func processingCoordinates() {
        var count = 0
        for i in 0...data.count-1 {
            for j in 0...data[i].count-1{
                scanshit(i: i, j: j, count: count)
                data[i][j] = currentString
                count+=1
            }
        }
    }
    
    func shapeData() {
        var row = 0
        var maxcountrow = 0
        var col = 0
        var maxcountcol = 0
        for i in 1...coor.count-1 {
            if (coor[i][0] == coor[i-1][0]) {
                row+=1
            } else {
                row = 0
            }
            if(coor[i][1] == coor[i-1][1]) {
                col+=1
            } else {
                col = 0
            }
            if (maxcountrow < row) {
                maxcountrow = row
            }
            if (maxcountcol < col) {
                maxcountcol = col
            }
        }
        data = Array(repeating: Array(repeating: "empty", count: maxcountrow), count: maxcountcol)
    }
    
    func result()-> [[String]] {
        return data
    }
}
