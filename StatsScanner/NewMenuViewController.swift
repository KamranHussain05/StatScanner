//
//  NewMenuViewController.swift
//  StatsScanner
//
//  Created by Kamran on 1/1/22.
//

import UIKit
import UniformTypeIdentifiers

class NewMenuViewController: UIViewController, UIDocumentPickerDelegate {
    // this is going to change bruj
    @IBOutlet var importCSV: UIButton!
    let db = DataBridge()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func importCSV(_sender: UIButton){
        let supportedFiles: [UTType] = [UTType.data]
        
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
        
        controller.delegate = self
        controller.allowsMultipleSelection = false
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func create(_ sender: UIButton) {
        let d = Dataset(name: self.name.text!)
    }
    

}
