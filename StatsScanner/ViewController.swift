//
//  ViewController.swift
//  StatsScanner
//
//  Created by Kamran on 11/20/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var txt: UILabel!
    @IBAction func field(_ sender: UITextField) {
    }
    
    @IBAction func swit(_ sender: UISwitch) {
        if(sender.isOn) {
            txt.text = "Among Us."
        } else {
            txt.text = "no"
        }
    }
    
}

