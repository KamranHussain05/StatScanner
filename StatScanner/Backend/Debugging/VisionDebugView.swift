//
//  VisionDebugView.swift
//  StatScanner
//
//  Created by Kamran Hussain on 6/20/23.
//

import UIKit

class VisionDebugView: UIViewController {
    private var image = UIImage()
    private var bounding_boxes = [[Float]]()
    private var scores = [Float]()
    private var labels = [Int]()
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBoundingBoxes(boxes: self.bounding_boxes, scores: self.scores)
        print(self.bounding_boxes)
    }
    
    // draws bounding boxes wow that's crazy
    func drawBoundingBoxes(boxes: [[Float]], scores: [Float]) {
        for a in boxes {
            let box = UIBezierPath.init()
            let boxColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.000).cgColor
            box.move(to: CGPoint.init(x: Double(a[0]), y: Double(a[1])))
            box.addLine(to: CGPoint.init(x: Double(a[2]), y: Double(a[3])))
            box.addLine(to: CGPoint.init(x: Double(a[4]), y: Double(a[5])))
            box.addLine(to: CGPoint.init(x: Double(a[6]), y: Double(a[7])))
            box.close()
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = box.cgPath
            shapeLayer.strokeColor = boxColor
            self.view.layer.addSublayer(shapeLayer)
        }
    }
    
    func setValues(outputs: [String : Any], image: UIImage) {
        self.bounding_boxes = outputs["boxes"] as! [[Float]]
        self.scores = outputs["scores"] as! [Float]
        self.labels = outputs["labels"] as! [Int]
        self.image = image
    }
}
