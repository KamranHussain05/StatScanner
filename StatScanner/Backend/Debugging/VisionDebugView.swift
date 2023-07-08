//
//  VisionDebugView.swift
//  StatScanner
//
//  Created by Kamran Hussain and Kaleb Kim on 6/20/23.
//

import UIKit

class VisionDebugView: UIViewController {
    private var image = UIImage()
    private var bounding_boxes = [[Float]]()
    private var scores = [Float]()
    @IBOutlet private var imview : UIImageView! = UIImageView()
    private var labels = [Int]()
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imview.image = self.image
        self.view.addSubview(self.imview)
        self.drawBoundingBoxes(boxes: self.bounding_boxes, scores: self.scores)
        
        print(self.bounding_boxes)
    }
    
    // draws bounding boxes wow that's crazy
    func drawBoundingBoxes(boxes: [[Float]], scores: [Float]) {
        for a in boxes {
            let width = a[2] - a[0]
            let height = a[3] - a[1]
            let box = UIBezierPath(rect: CGRect(x: CGFloat(a[0]), y: CGFloat(a[1]), width: CGFloat(height), height: CGFloat(width)))
            let boxColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.000).cgColor
//            box.move(to: CGPoint.init(x: Double(a[0]), y: Double(a[1]))) // top left
//            box.addLine(to: CGPoint.init(x: Double(a[1]), y: Double(a[0]))) // top right
//            box.addLine(to: CGPoint.init(x: Double(a[2]), y: Double(a[3]))) // bottom right
//            box.addLine(to: CGPoint.init(x: Double(a[0]), y: Double(a[3]))) // bottom left
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
