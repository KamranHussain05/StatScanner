//
//  DataSetViewController.swift
//  StatsScanner
//
//  Created by Kamran on 12/31/21.
//

import UIKit

class DataSetViewController: UIViewController {
    
    private var datasetobj: Dataset!

    @IBOutlet var datasetName: UILabel!
    @IBOutlet var creationDate: UILabel!
    @IBOutlet var numitems: UILabel!
    @IBOutlet var back: UIButton!
    
    @IBOutlet var average: UILabel!
    @IBOutlet var mode: UILabel!
    @IBOutlet var range: UILabel!
    @IBOutlet var max: UILabel!
    @IBOutlet var min: UILabel!
    @IBOutlet var standardDev: UILabel!
    @IBOutlet var standardError: UILabel!
    @IBOutlet var median: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        loadData()
    }
    
    @objc func setDataSetObject(_ notification: Notification) {
        print("dataset view recieved dataset")
        datasetobj = (notification.object as! Dataset)
    }
    
    func loadData() {
        datasetName.text = datasetobj.name
        creationDate.text = datasetobj.creationDate
        numitems.text = String(datasetobj.getTotalNumItems())
        
        average.text = String(datasetobj.calculations[7])
        mode.text = String(datasetobj.calculations[2])
        range.text = String(datasetobj.calculations[4])
        max.text = String(datasetobj.calculations[0])
        min.text = String(datasetobj.calculations[1])
        standardDev.text = String(datasetobj.calculations[5])
        standardError.text = String(datasetobj.calculations[6])
        median.text = String(datasetobj.calculations[3])
    }
    
    @IBAction func onBackClick(_sender:UIButton) {
        if (_sender == self.back){
            self.dismiss(animated:true)
        }
    }
}
