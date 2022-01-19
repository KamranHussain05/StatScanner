//
//  HomeTiles.swift
//  StatsScanner
//
//  Created by Kamran on 12/30/21.
//

import UIKit

class HomeTiles: UICollectionViewCell {
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet weak var dataSetName: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet var numitems: UILabel!
    @IBOutlet var openDataset: UIButton!
    
    private var dataset = Dataset()
    private let objmanager = DataSetObjectManager()
    
    override func layoutSubviews() {
        contentView.backgroundColor = .secondarySystemFill
        // cell rounded section
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    
    @IBAction func onOpenClick(_sender: UIButton) {
        print("opening dataset")
        dataset.name = "New DataSet"
        NotificationCenter.default.post(name: Notification.Name("datasetobj"), object: self.dataset)
    }
    
}
