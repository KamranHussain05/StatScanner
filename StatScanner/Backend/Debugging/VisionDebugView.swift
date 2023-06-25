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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.bounding_boxes)
    }
    
    func setValues(outputs: [String : Any], image: UIImage) {
        self.bounding_boxes = outputs["boxes"] as! [[Float]]
        self.scores = outputs["scores"] as! [Float]
        self.labels = outputs["labels"]
        self.image = image
    }

}
