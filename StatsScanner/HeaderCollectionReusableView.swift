//
//  HeaderCollectionReusableView.swift
//  StatsScanner
//
//  Created by Kamran on 12/28/21.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "homeheader"
    
    private let headerTitle = UILabel()
    @IBOutlet var newDataSet: UIButton!
    
    @IBAction func newClicked(_ sender: Any) {
        //performSegue(withIdentifier: "toFeedActivity", sender: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        headerTitle.text = "StatsScanner"
        headerTitle.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        headerTitle.textAlignment = .left
        headerTitle.numberOfLines = 0
        
        newDataSet.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        newDataSet.frame = CGRect(x:0, y:0, width:40, height: 40)
        addSubview(newDataSet)
        
        addSubview(headerTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        
//        headerTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
//        headerTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        headerTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
//        headerTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        headerTitle.frame = bounds
    }
}
