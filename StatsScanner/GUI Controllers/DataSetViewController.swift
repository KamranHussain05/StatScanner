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
    
    private var datasetobj = Dataset()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside DataViewController")
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
    }
    
    @objc func setDataSetObject(_ notification: Notification) {
        self.datasetobj = notification.object as! Dataset
    }
    
    override func viewDidLayoutSubviews() {
        datasetName.text = datasetobj.getName()
        creationDate.text = datasetobj.creationDate
        numitems.text = String(datasetobj.getTotalNumItems())
    }


}
