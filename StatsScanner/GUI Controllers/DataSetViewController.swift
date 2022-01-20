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
    @IBOutlet var edit: UIButton!
    
    private var datasetobj = Dataset()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside DataViewController")
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
        loadData()
    }
    
    @objc func setDataSetObject(_ notification: Notification) {
        self.datasetobj = notification.object as! Dataset
        print("recieved dataset object")
        loadData()
    }
    
    func loadData() {
        datasetName.text = datasetobj.getName()
        creationDate.text = datasetobj.creationDate
        numitems.text = String(datasetobj.getTotalNumItems())
    }
    
    @IBAction func onEditClick(_sender:UIButton) {
        if (_sender == edit){
            print("editing data")
        }
        
    }


}
