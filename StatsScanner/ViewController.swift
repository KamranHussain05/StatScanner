//
//  HomeViewController.swift
//  StatsScanner
//
//  Created by Kamran on 12/31/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var myCollectionView: UICollectionView!
    
    var itemList = [tileList]()
    let d: Dataset = Dataset()
    var indexpath1: IndexPath!
    var cellSpacing: CGFloat = 10
    
    var sproduct:tileList!=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let elem1 : tileList = tileList(dataSetImage: UIImage(systemName: "questionmark.folder")!, dataSetName: d.getName(), creationDate: d.creationDate, numItems: String(d.getTotalNumItems()) + " Items in DataSet")
        itemList.append(elem1)
        
        let elem2 : tileList = tileList(dataSetImage: UIImage(systemName: "questionmark.folder")!, dataSetName: "name", creationDate: "Created: 12/30/21", numItems: "30" + " Items in DataSet")
        itemList.append(elem2)
        
        let elem3 : tileList = tileList(dataSetImage: UIImage(systemName: "questionmark.folder")!, dataSetName: "name", creationDate: "Created: 12/30/21", numItems: "30" + " Items in DataSet")
        itemList.append(elem3)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "hometile", for: indexPath) as! HomeTiles
        cell.myImageView.image = itemList[indexPath.row].dataSetImage
        cell.dataSetName.text = itemList[indexPath.row].dataSetName
        cell.creationDate.text = itemList[indexPath.row].creationDate
        cell.numitems.text = itemList[indexPath.row].numItems
        cell.openDataset.tag = indexPath.row
        cell.openDataset.addTarget(self, action: #selector(openDataSet), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openDataSet(sender:UIButton) {
        print("Opening DataSet")
        indexpath1 = IndexPath(row: sender.tag, section: 0)
        self.tabBarController?.selectedIndex = 1
    }
    
    func getData() -> tileList {
        return itemList[indexpath1.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpacing: CGFloat = 10
        let width = (UIScreen.main.bounds.size.width - 3 * cellSpacing) / 2
        let height = width*1.5

        return CGSize(width: width, height:height)
    }
}
