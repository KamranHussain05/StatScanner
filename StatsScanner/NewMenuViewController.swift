//
//  NewMenuViewController.swift
//  StatsScanner
//
//  Created by Kamran on 1/1/22.
//

import UIKit
import UniformTypeIdentifiers

class NewMenuViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet var importCSV: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func importCSV(_sender: UIButton){
        let supportedFiles: [UTType] = [UTType.data]
        
        
    }

}
