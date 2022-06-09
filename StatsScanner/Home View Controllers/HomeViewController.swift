//
//  HomeViewController.swift
//  StatsScanner
//
//  Created by Kalb on 12/31/21.
//

import UIKit
import UniformTypeIdentifiers

// MARK: Home View Controller

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
        if(UIDevice.current.userInterfaceIdiom != .mac) {
            // don't allow user to take a photo if it's a mac (impractical)
            newDatasetMenu.addAction(
                UIAlertAction(title: "Take Image", style: .default) { (action) in
                    print("Scanning image")
                    self.scanningImage()
                }
            )
        }
        
        newDatasetMenu.addAction(
            UIAlertAction(title: "Import Image", style: .default) { (action) in
                print("beans")
                self.createWithName(method: 1)
            }
        )
        
        newDatasetMenu.addAction(
            UIAlertAction(title: "Import CSV", style: .default) { (action) in
                self.createWithName(method: 2)
            }
        )
        
        newDatasetMenu.addAction(
            UIAlertAction(title:"Cancel", style: .destructive) { (action) in
                print("cancelled addition")
            })
    }
    
    // MARK: Data Import Handling
    
    // when plus button is pressed (creates new menu)
    @IBAction func didTapNewDatasetButton() {
        newDatasetMenu.popoverPresentationController?.sourceView = self.myCollectionView
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            newDatasetMenu.popoverPresentationController?.sourceRect = CGRect.init(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(newDatasetMenu, animated: true, completion: nil)
    }
    
    ///Creates a new dataset
    func createWithName(method: Int) {
        let new = Dataset()
        let alert = UIAlertController(title: "New DataSet Name",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            new.name = text
            
            switch(method) {
            case 0:
                self?.scanningImage()
                print("scanning image")
            break
            case 1:
                //import image method call
                print("importing image")
            break
            case 2:
                self?.importCSV()
                print("importing csv")
            break
            default:
                return
            }
            
            self?.createItem(item: new, name: new.name) //remove this after pipelines are implemented
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
        }))
        alert.popoverPresentationController?.sourceView = self.view
        
        present(alert, animated: true, completion: nil)
    }
    
    ///Presents the image scanning window and starts that pipeline
    func scanningImage() {
        let scanview = storyboard?.instantiateViewController(withIdentifier: "scanview") as! CameraOCRThing
        scanview.modalPresentationStyle = .popover
        scanview.popoverPresentationController?.sourceView = self.myCollectionView
        self.present(scanview, animated: true, completion: nil)
    }
    
	let db = DataBridge()
	
    ///Starts the CSV importing pipeline and reading into dataframe
    func importCSV() {
        let supportedFiles: [UTType] = [UTType.data]
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
        
        controller.delegate = self
        controller.allowsMultipleSelection = false
		controller.shouldShowFileExtensions = true
        
		present(controller, animated: true, completion: nil)
        print("got here")
    }
    
    ///code crashes here, "Failed to set FileProtection Attributes on staging URL"
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt url: URL) {
		print("====called the document picker method====")
        do {
            let arr = try String(contentsOf: url)
            print(arr)
        } catch {
            print("FAILED")
        }
        
        let arr = db.readCSV(inputFile: url)
        print(arr)
        print("copying csv to app docs")
        let filename = "newdoc_" + ".csv"
        db.writeCSV(fileName: filename, data: arr)
    }
    

// MARK: CORE DATA CONFIGURATION

    ///Fetches all the datasetprojects from Core Data
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
    
    ///Writes a datasetproject to Core Data
    func createItem(item: Dataset, name: String) {
        let newItem = DataSetProject(context: context)
        newItem.datasetobject = item
        newItem.name = name
        
        do {
            try context.save()
            getAllItems()
        } catch {
            fatalError("CORE DATA WRITE FAILED")
        }
    }
    
    ///Deletes a datasetproject from Core Data
    func deleteItem(item: DataSetProject) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            fatalError("CORE DATA DELETION FAILED")
        }
    }
    
    ///Updates the dataset project in Core Data
    func updateItem(item: DataSetProject, dataset: Dataset) {
        item.datasetobject = dataset
        
        do {
            try context.save()
        } catch {
            fatalError("CORE DATA UPDATE FAILED")
        }
    }
}


// MARK: VIEW CONFIG

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    ///Specifies the number of cells to add to the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    ///Creates the collection view on the home screen and loads all necessary formats and data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "hometile", for: indexPath) as! HomeTiles
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        
        cell.dataSetName.text = model.datasetobject?.name
        cell.numitems.text = "Contains " + String(model.datasetobject!.getTotalNumItems()) + " items"
        cell.creationDate.text = "Created: " + (model.datasetobject?.creationDate)!
        self.selectedDataset = model.datasetobject!
        print(model.datasetobject!.name)
        cell.openDataset.tag = indexPath.row
        cell.openDataset.addTarget(self, action: #selector(openDataSet(_:)), for: .touchUpInside)
        myCollectionView.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    ///Handles the collection view formatting
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 3 * cellSpacing) / 2
        let height = width*1.5

        return CGSize(width: width, height:height)
    }
    
// MARK: OPEN DATASET HANDLING
    
    ///Opens the dataset and loads it from coredata
    @objc func openDataSet(_ sender:UIButton) {
        print("Opening DataSet")
        self.selectedDataset = models[sender.tag].datasetobject!
        print(selectedDataset.name)
        let vc = storyboard?.instantiateViewController(withIdentifier: "expandedview") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        
        //send the dataset object to the detailed view controllers
        NotificationCenter.default.post(name:Notification.Name("datasetobj"), object: selectedDataset)
        NotificationCenter.default.post(name:Notification.Name("datasetobjpoints"), object: selectedDataset)
        NotificationCenter.default.post(name:Notification.Name("data"), object: selectedDataset)
        NotificationCenter.default.post(name:Notification.Name("datasetobjectgraph"), object: selectedDataset)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: LONG PRESS HANDLING
    
    ///Handles the long tap gesture and deletes the selected dataset
    @objc func longTap(_ gesture: UIGestureRecognizer) {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
		
		guard let deletionIndex = myCollectionView.indexPathForItem(at: gesture.location(in: myCollectionView)) else { return }
		
        if(gesture.state == .began) {
            let alert = UIAlertController(title: "Delete Dataset", message: "This is Irreversible!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
				print("deleting ", self!.models[deletionIndex.row].name!)
				self?.deleteItem(item: self!.models[deletionIndex.row])
                self!.getAllItems()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return } }))
			
            present(alert, animated: true, completion: nil)
        }
    }
}
