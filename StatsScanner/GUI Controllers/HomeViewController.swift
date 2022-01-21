//
//  HomeViewController.swift
//  StatsScanner
//
//  Created by Kalb on 12/31/21.
//

import UIKit
import UniformTypeIdentifiers

class HomeViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var newDatasetButton: UIButton!
    
    var itemList = [tileList]()
    let d: Dataset = Dataset()
    var indexpath1: IndexPath!
    var cellSpacing: CGFloat = 10
    
    var sproduct:tileList! = nil
    
    let newDatasetMenu = UIAlertController(title: "New Dataset",
        message: "Select how you would like to import your data",
        preferredStyle: .actionSheet
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // for dataset tiles
//        let elem1 : tileList = tileList(dataSetImage: UIImage(systemName: "questionmark.folder")!, dataSetName: d.getName(), creationDate: d.creationDate, numItems: String(d.getTotalNumItems()) + " Items in DataSet")
//        itemList.append(elem1)
        
        let elem1 : tileList = tileList(dataSetImage: UIImage(systemName: "questionmark.folder")!, dataSetName: "name", creationDate: "Created: 12/30/21", numItems: "30" + " Items in DataSet")
        itemList.append(elem1)
        
        let elem2 : tileList = tileList(dataSetImage: UIImage(systemName: "questionmark.folder")!, dataSetName: "name", creationDate: "Created: 12/30/21", numItems: "30" + " Items in DataSet")
        itemList.append(elem2)
        
        let elem3 : tileList = tileList(dataSetImage: UIImage(systemName: "questionmark.folder")!, dataSetName: "name", creationDate: "Created: 12/30/21", numItems: "30" + " Items in DataSet")
        itemList.append(elem3)
        
        // for pop up menu
        newDatasetMenu.addAction(
            UIAlertAction(title: "Take Image", style: .default) { (action) in
                print("Scanning image")
                self.scanningImage()
            }
        )

        newDatasetMenu.addAction(
            UIAlertAction(title: "Import Image", style: .default) { (action) in
                print("beans")
            }
        )
        
        newDatasetMenu.addAction(
            UIAlertAction(title: "Import CSV", style: .default) { (action) in
                self.importCSV()
            }
        )
        
        newDatasetMenu.addAction(
            UIAlertAction(title:"Cancel", style: .destructive) { (action) in
                print("cancelled addition")
            })
        
    }
    
    // when plus button is pressed
    @IBAction func didTapNewDatasetButton() {
        newDatasetMenu.popoverPresentationController?.sourceView = self.myCollectionView
        self.present(newDatasetMenu, animated: true, completion: nil)
    }
    
    func scanningImage() {
        let scanview = storyboard?.instantiateViewController(withIdentifier: "scanview") as! CameraOCRThing
        scanview.modalPresentationStyle = .popover
        self.present(scanview, animated: true, completion: nil)
    }
    
    let db = DataBridge()
    func importCSV() {
        let supportedFiles: [UTType] = [UTType.data]
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
        
        controller.delegate = self
        controller.allowsMultipleSelection = false
        
        present(controller, animated: true, completion: nil)
    }
    
    //code crashes here, "Failed to set FileProtection Attributes on staging URL"
    private func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt url: URL) {
        print("inside document picker function")
        let arr = db.readCSV(inputFile: url)
        print("copying csv to app docs")
        let filename = "newdoc_" + getDate() + ".csv"
        db.writeCSV(fileName: filename, data: arr)
    }
    
    private func getDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: currentDateTime)
    }
}

// ===========================================
// ||   UICollectionView Cells and Config   ||
// ===========================================

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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "expandedview") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        
        //send the dataset object to the detailed view controllers
        self.d.name = "Test Dataset"
        NotificationCenter.default.post(name:Notification.Name("datasetobj"), object: self.d)
        NotificationCenter.default.post(name:Notification.Name("datasetobjpoints"), object: self.d)
        NotificationCenter.default.post(name:Notification.Name("data"), object: self.d)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 3 * cellSpacing) / 2
        let height = width*1.5

        return CGSize(width: width, height:height)
    }
}
