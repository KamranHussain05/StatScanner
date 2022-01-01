//
//  DataSetViewController.swift
//  StatsScanner
//
//  Created by Kamran on 12/31/21.
//

import UIKit

class DataSetViewController: UIViewController {

    @IBOutlet var datasetName: UILabel!
    @IBOutlet var creationDate: UILabel!
    @IBOutlet var numitems: UILabel!
    
    var sproduct:tileList!
    let h = HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside DataViewController")
        sproduct = h.getData()
        loadContent()
    }
    
    func loadContent() {
        datasetName.text = sproduct.dataSetName
        creationDate.text = sproduct.creationDate
        numitems.text = sproduct.numItems
    }

}
