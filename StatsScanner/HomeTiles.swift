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
    @IBOutlet weak var openDataSet: UILabel!
    @IBOutlet weak var numItems: UILabel!
    
    override func layoutSubviews() {
        // cell rounded section
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        
        // cell shadow section
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 3.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.6
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
}
