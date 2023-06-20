//
//  VisionDebugView.swift
//  StatScanner
//
//  Created by Kamran Hussain on 6/20/23.
//

import Foundation
import UIKit

class VisionDebugView: UIViewController {
    @IBOutlet private var imageView = UIImageView()
    private var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func back() {
        self.dismiss(animated: true)
    }
}
