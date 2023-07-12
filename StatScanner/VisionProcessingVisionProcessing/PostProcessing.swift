//
//  PostProcessing.swift
//  StatScanner
//
//  Created by Kamran Hussain on 4/16/23.
//

import Foundation
import CoreML

class ModelPostProcess {
    
    private var filtered_results = [String: Any]()
    
    func postProcess(logits: MLMultiArray, pred_boxes: MLMultiArray, target_sizes: CGSize, threshold: Float = 0.8) -> [[[Float]]] {
        let out_boxes = convertMultiArrayToFloatArray(pred_boxes)
        let out_logits = convertMultiArrayToFloatArray(logits)
        
        let id2label = [
            0 : "table",
            1 : "table column",
            2 : "table row",
            3 : "table column header",
            4 : "table projected row header",
            5 : "table spanning cell"
          ]
        
        let prob = softmax(out_logits)
        let numClasses = id2label.count
        let scoresAndLabels: [(Float, Int)] = prob.map { row in
            let label = row[0..<numClasses-1].enumerated().max(by: { $0.1 < $1.1 })!.0
            let score = row[label]
            return (score, label)
        }
        
        let scores = scoresAndLabels.map { $0.0 }
        let labels = scoresAndLabels.map { $0.1 }
        let boxes = scaleBoxes(targetSize: target_sizes, boxes: centerToCornersFormat(bboxesCenter: out_boxes))
        
        let filtered = filterResults(scores: scores, labels: labels, boxes: boxes, threshold: threshold)
        self.filtered_results = filtered
        print(filtered)
        let sortedBoxes = sortBoxesByAxis(boxes: filtered["boxes"] as! [[Float]], labels: filtered["labels"] as! [Int]) // 0 - rows, 1 - colummns
        let final_boxes = findBoxes(sortedBoxes)
        
        return final_boxes
    }
    
    // Must always call the postprocess function before to avoid memory leakage or null return
    func getFilteredResults() -> [String : Any] {
        return self.filtered_results
    }
    
    func findBoxes(_ boxes : [String : Any]) -> [[[Float]]] {
        let rows = boxes["rows"] as! [[Float]]
        let columns = boxes["columns"] as! [[Float]]
        var output = [[[Float]]]()
        
        for i in 0..<rows.count {
            var out_row = [[Float]]()
            
            for column in columns {
                let box1 = rows[i]
                let box2 = column
                
                // Determine if the boxes intersect
                if box1[2] > box2[0] && box2[2] > box1[0] && box1[3] > box2[1] && box2[3] > box1[1] {
                    // Calculate the coordinates of the intersection
                    let x1 = max(box1[0], box2[0])
                    let y1 = max(box1[1], box2[1])
                    let x2 = min(box1[2], box2[2])
                    let y2 = min(box1[3], box2[3])
                    
                    // Add the intersection to the output array
                    if (y2-y1) > 3 && (x2-x1) > 3 {
                        out_row.append([x1, y1, x2, y2])
                    }
                }
            }
            output.append(out_row)
        }
                
        return output
    }
    
    func filterResults(scores: [Float], labels: [Int], boxes: [[Float]], threshold: Float) -> [String: Any] {
        var filteredScores = [Float]()
        var filteredLabels = [Int]()
        var filteredBoxes = [[Float]]()
        
        for i in 0..<scores.count {
            if scores[i] > threshold {
                filteredScores.append(scores[i])
                filteredLabels.append(labels[i])
                filteredBoxes.append(boxes[i])
            }
        }
        
        return ["scores": filteredScores, "labels": filteredLabels, "boxes": filteredBoxes]
    }
    
    func scaleBoxes(targetSize: CGSize, boxes: [[Float]]) -> [[Float]] {
        // Check if the target size is valid.
        guard targetSize.width > 0 && targetSize.height > 0 else {
            fatalError("target size is incorrect")
        }
        
        // Calculate the scale factors.
        let scaleX = Float(targetSize.width)
        let scaleY = Float(targetSize.height)
        
        var outboxes = boxes
        // Scale the bounding boxes.
        for i in 0 ..< outboxes.count {
            outboxes[i][0] *= scaleX
            outboxes[i][1] *= scaleY
            outboxes[i][2] *= scaleX
            outboxes[i][3] *= scaleY
        }
        
        return outboxes
    }

    
    func softmax(_ x: [[Float]]) -> [[Float]] {
        var result: [[Float]] = []
        for row in x {
            let maxVal = row.max()!
            let exps = row.map { exp($0 - maxVal) }
            let sumExps = exps.reduce(0, +)
            let softmax = exps.map { $0 / sumExps }
            result.append(softmax)
        }
        return result
    }
    
    func centerToCornersFormat(bboxesCenter: [[Float]]) -> [[Float]] {
        let centerX = bboxesCenter.map { $0[0] }
        let centerY = bboxesCenter.map { $0[1] }
        let width = bboxesCenter.map { $0[2] }
        let height = bboxesCenter.map { $0[3] }
        let bboxCorners = centerX.indices.map {
            [
                centerX[$0] - 0.5 * width[$0],
                centerY[$0] - 0.5 * height[$0],
                centerX[$0] + 0.5 * width[$0],
                centerY[$0] + 0.5 * height[$0]
            ]
        }
        return bboxCorners
    }
    
    func convertMultiArrayToFloatArray(_ multiArray: MLMultiArray) -> [[Float]] {
        // Get the dimensions of the multi-array
        let shape = multiArray.shape.map { $0.intValue }
        var floatArray = [[Float]](repeating: [Float](repeating: 0, count: shape.last!), count: shape.dropLast().reduce(1, *))
        
        // Copy the multi-array's data to the float array
        for i in 0..<floatArray.count {
            let indices = indicesForFlatIndex(i, shape: shape.dropLast())
            for j in 0..<shape.last! {
                let index = indices + [j]
                floatArray[i][j] = multiArray[index as [NSNumber]].floatValue
            }
        }
        
        return floatArray
    }
    
    func indicesForFlatIndex(_ index: Int, shape: [Int]) -> [Int] {
        var indices = [Int](repeating: 0, count: shape.count)
        var remainder = index
        for i in (0..<shape.count).reversed() {
            indices[i] = remainder % shape[i]
            remainder /= shape[i]
        }
        return indices
    }
    
    func sortBoxesByAxis(boxes : [[Float]], labels:[Int]) -> [String : Any]{
        if (boxes.count != labels.count) {
            fatalError("Unmatching number of labels and boxes")
        }
        
        var rows = [[Float]]()
        var columns = [[Float]]()
        var table = [Float]()
        
        for i in 0...labels.count-1 {
            if (labels[i] == 2 || labels[i] == 4) {   // Check for row labels
                rows.append(boxes[i])
            } else if (labels[i] == 1 || labels[i] == 3) {    // Check for column labels
                columns.append(boxes[i])
            } else if (labels[i] == 0 || labels[i] == 5) {    // Check for table labels
                table = boxes[i]
            }
        }

        rows = rows.sorted { $0[0] < $1[0] }
        columns = columns.sorted { $0[0] < $1[0] }
    
        return ["rows": rows, "columns": columns, "table": table]
    }
    
    
}
