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
    
    var sproduct:tileList!=nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        datasetName.text = sproduct.dataSetName
        creationDate.text = sproduct.creationDate
        numitems.text = sproduct.numItems
    }
    
    init(list: tileList) {
        super.init(nibName: nil, bundle: nil)
        sproduct = list
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside DataViewController")
    }
    
    func loadContent() {
        datasetName.text = sproduct.dataSetName
        creationDate.text = sproduct.creationDate
        numitems.text = sproduct.numItems
    }

}
