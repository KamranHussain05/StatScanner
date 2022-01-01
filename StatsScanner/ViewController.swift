//
//  ViewController.swift
//  StatsScanner
//
//  Created by Kalb on 9/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    var list = [itemList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item:itemList=itemList(productImage: UIImage(systemName: "questionmark.folder")!, datasetName: "Example", creationDate: "Created 12/30/21", numItems: "30 Items in DataSet")
        list.append(item)
        
        let item1:itemList=itemList(productImage: UIImage(systemName: "questionmark.folder")!, datasetName: "Example",  creationDate: "Created 12/30/21", numItems: "30 Items in DataSet")
        list.append(item1)
        
        let item2:itemList=itemList(productImage: UIImage(systemName: "questionmark.folder")!, datasetName: "Example",  creationDate: "Created 12/30/21", numItems: "30 Items in DataSet")
        list.append(item2)
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        cell.myImageView.image = list[indexPath.row].productImage
        cell.datasetName.text = list[indexPath.row].datasetName
        cell.creationDate.text = list[indexPath.row].creationDate
        cell.numItems.text = list[indexPath.row].numItems
        
        cell.myImageView.layer.cornerRadius = 20
        cell.backgroundColor = .secondarySystemFill
        
        cell.launchDataset.tag = indexPath.row
        cell.launchDataset.addTarget(self, action: #selector(launchDataset), for: .touchUpInside)
        
        return cell
    }
    
    @objc func launchDataset(sender:UIButton) {
        let indexpath1 = IndexPath(row:sender.tag, section: 0)
        let home = self.storyboard?.instantiateViewController(withIdentifier: "datasetview") as! DataSetViewController
        home.sproduct = list[indexpath1.row]
        self.tabBarController?.navigationController?.pushViewController(home, animated: true)
    }
    
}
