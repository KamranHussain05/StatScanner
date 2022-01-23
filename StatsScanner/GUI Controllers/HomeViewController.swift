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
    
    private var selectedDataset: Dataset!
    private var cellSpacing: CGFloat = 10
    private var models = [DataSetProject]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let newDatasetMenu = UIAlertController(title: "New Dataset",
        message: "Select how you would like to import your data",
        preferredStyle: .actionSheet
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
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
        //let arr = db.readCSV(inputFile: url)
        print("copying csv to app docs")
        let filename = "newdoc_" + getDate() + ".csv"
        //db.writeCSV(fileName: filename, data: arr)
    }
    
    private func getDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: currentDateTime)
    }
    
// ===========================================
// ||        CORE DATA CONFIGURATION        ||
// ===========================================
    //Fetches all the datasetprojects from Core Data
    func getAllItems() {
        do {
            models = try context.fetch(DataSetProject.fetchRequest())
            
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        } catch {
            fatalError("CORE DATA FETCH FAILED")
        }
    }
    
    //Writes a datasetproject to Core Data
    func createItem(item: Dataset) {
        let newItem = DataSetProject(context: context)
        newItem.datasetobject = item
        do {
            try context.save()
            getAllItems()
        } catch {
            fatalError("CORE DATA WRITE FAILED")
        }
    }
    
    //Deletes a datasetproject from Core Data
    func deleteItem(item: DataSetProject) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            fatalError("CORE DATA DELETION FAILED")
        }
    }
    
    //Updates the dataset project in Core Data
    func updateItem(item: DataSetProject, dataset: Dataset) {
        item.datasetobject = dataset
        
        do {
            try context.save()
        } catch {
            fatalError("CORE DATA UPDATE FAILED")
        }
    }
}

// ===========================================
// ||   UICollectionView Cells and Config   ||
// ===========================================

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "hometile", for: indexPath) as! HomeTiles
        
        cell.dataSetName.text = model.datasetobject?.name
        cell.numitems.text = "Contains " + String(model.datasetobject!.getTotalNumItems()) + " items"
        cell.creationDate.text = "Created: " + (model.datasetobject?.creationDate)!
        selectedDataset = model.datasetobject!
        
        cell.openDataset.tag = indexPath.row
        cell.openDataset.addTarget(self, action: #selector(openDataSet(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openDataSet(_ sender:UIButton) {
        print("Opening DataSet")
        let vc = storyboard?.instantiateViewController(withIdentifier: "expandedview") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        
        //send the dataset object to the detailed view controllers
        NotificationCenter.default.post(name:Notification.Name("datasetobj"), object: selectedDataset)
        NotificationCenter.default.post(name:Notification.Name("datasetobjpoints"), object: selectedDataset)
        NotificationCenter.default.post(name:Notification.Name("data"), object: selectedDataset)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 3 * cellSpacing) / 2
        let height = width*1.5

        return CGSize(width: width, height:height)
    }
}
