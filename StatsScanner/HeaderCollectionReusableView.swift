//
//  HeaderCollectionReusableView.swift
//  StatsScanner
//
//  Created by Kamran on 12/28/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "homeheader"
    
    private let headerTitle: UILabel =  UILabel()
    private let addDataSet: UIButton = UIButton()
    private let view: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addDataSet.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        
        headerTitle.text = "StatsScanner"
        headerTitle.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        headerTitle.textAlignment = .left
        headerTitle.numberOfLines = 0
        
        view.addSubview(headerTitle)
        view.addSubview(addDataSet)
        
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        
        headerTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        headerTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        headerTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.frame = bounds
    }
}
