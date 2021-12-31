//
//  CustomCollectionViewCell.swift
//  StatsScanner
//
//  Created by Kamran on 12/28/21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "tile"
    
    var stackView: UIStackView = UIStackView()
    var dataSetName: UILabel = UILabel()
    var dateCreated: UILabel = UILabel()
    var numItems: UILabel = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func autoLayoutCell() {
        //DataSetName setup
        dataSetName.text = "Example"
        dataSetName.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        dataSetName.textAlignment = .left
        addSubview(dataSetName)
    }

}
