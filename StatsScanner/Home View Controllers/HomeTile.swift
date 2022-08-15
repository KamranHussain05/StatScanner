//
//  HomeTiles.swift
//  StatsScanner
//
//  Created by Kamran on 12/30/21.
//

import UIKit

class HomeTiles: UICollectionViewCell {
    
    static let identifier = "hometile"
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet weak var dataSetName: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet var numitems: UILabel!
    @IBOutlet var openDataset: UIButton!
    
    override func layoutSubviews() {
        contentView.backgroundColor = .secondarySystemFill
        // cell rounded section
        //self.layer.cornerRadius = 10.0
        //self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        dataSetName.adjustsFontSizeToFitWidth = true
        dataSetName.baselineAdjustment = UIBaselineAdjustment.alignCenters
        creationDate.adjustsFontSizeToFitWidth = true
        creationDate.baselineAdjustment = UIBaselineAdjustment.alignCenters
        numitems.adjustsFontSizeToFitWidth = true
        numitems.baselineAdjustment = UIBaselineAdjustment.alignCenters
        openDataset.titleLabel?.textColor = .white
        openDataset.titleLabel?.adjustsFontForContentSizeCategory = true
        openDataset.titleLabel?.adjustsFontSizeToFitWidth = true
        openDataset.titleLabel?.minimumScaleFactor = 0.25
        openDataset.titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        openDataset.titleLabel?.numberOfLines = 1
        
        contentView.clipsToBounds = true
    }
    
}
