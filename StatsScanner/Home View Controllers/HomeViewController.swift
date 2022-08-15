//
//  HomeViewController.swift
//  StatScanner
//
//  Created by Kaleb Kim and Kamran Hussain on 12/31/21.
//  Caden Pun

import UIKit
import UniformTypeIdentifiers
import Vision

// MARK: Home View Controller

class HomeViewController: UIViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var newDatasetButton: UIButton!
    
    private var selectedDataset: Dataset!
	private var sc: CGFloat = 0.05
    private var models = [DataSetProject]()
	private let db : DataBridge! = DataBridge()
	private var dbuilder = DatasetBuilder()

	private let icons = ["DataSetIcon1", "DataSetIcon2", "DataSetIcon3", "DataSetIcon4", "DataSetIcon5",
	"DataSetIcon6"]
	
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newDatasetMenu = UIAlertController(title: "New Dataset",
        message: "Select how you would like to import your data",
        preferredStyle: .actionSheet
    )

    override func viewDidLoad() {
        super.viewDidLoad()
		let layout = UICollectionViewFlowLayout()
		let width = (414*(1-3*sc))/2
		let height = (414*(1.25-sc))/2
		layout.itemSize = CGSize(width: width, height: height)
		layout.minimumLineSpacing = sc*414
		layout.minimumInteritemSpacing = sc*414
		layout.sectionInset = UIEdgeInsets(top: 0.01*view.frame.size.width, left: sc*414, bottom: 0, right: sc*414)
		myCollectionView.collectionViewLayout = layout
        getAllItems()
        
        // for pop up menu
		let macurl = DataBridge.getDocumentsDirectory().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
		if(UIApplication.shared.canOpenURL(URL(string: macurl)!)) {
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
                print("Importing Image")
                self.createWithName(method: 1)
            }
        )
        
        newDatasetMenu.addAction(
            UIAlertAction(title: "Import CSV", style: .default) { (action) in
                self.createWithName(method: 2)
            }
        )
		
		newDatasetMenu.addAction(
			UIAlertAction(title:"New Dataset", style:.default) { (action) in
				self.createWithName(method:3)
		})
        
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
        let alert = UIAlertController(title: "New DataSet Name", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
			
		let new = Dataset(name: text)
            
		switch(method) {
		case 0:
			self?.scanningImage()
			print("scanning image")
			break
		case 1:
			//import image method call
			print("importing image")
			self?.importImage()
			break
		case 2:
			self?.dbuilder.name = new.getName()
			self?.importCSV()
			print("importing csv")
			break
		case 3:
			print("creating blank dataset")
			self?.createItem(item: new, name: new.getName())
			break
		default:
			return
		}
            
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
        let scanview = storyboard?.instantiateViewController(withIdentifier: "scanview") as! OCRScanning
        scanview.modalPresentationStyle = .popover
        scanview.popoverPresentationController?.sourceView = self.myCollectionView
        self.present(scanview, animated: true, completion: nil)
    }
	
	///Allows the user to select and import an image of a dataset to the app
	func importImage() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }

		dismiss(animated: true)
		print(image)
	}
	
	///Launches the controller for CSV importing
	func importCSV() {
		let supportedFiles : [UTType] = [UTType.data]
		
		let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
		
		controller.delegate = self
		controller.allowsMultipleSelection = false
		
		present(controller, animated:true, completion:nil)
	}
	
	///Reads the CSV file and loads it into an array of stirngs
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		controller.dismiss(animated: true)
		do {
			let rawFile = try db.readCSV(inputFile: url)
			print(rawFile)
			self.dbuilder.dataset = Dataset(name: self.dbuilder.name, appendable: rawFile)
			self.createItem(item: self.dbuilder.dataset, name: self.dbuilder.name)
		} catch {
			let dialog = UIAlertController(title:"Error Importing CSV", message:"Your CSV file is corrupted or incompatible.", preferredStyle: .alert)
			let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
			dialog.addAction(okAction)
			present(dialog, animated:true)
		}
	}
	
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		controller.dismiss(animated: true)
	}
    

// MARK: CORE DATA CONFIGURATION

    ///Fetches all the datasetprojects from Core Data
    func getAllItems() {
        do {
            models = try context.fetch(DataSetProject.fetchRequest())
            
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
			print("Loaded from core data")
        } catch {
            fatalError("CORE DATA FETCH FAILED")
        }
    }
    
    ///Writes a datasetproject to Core Data
    public func createItem(item: Dataset, name: String) {
        let newItem = DataSetProject(context: context)
        newItem.datasetobject = item
        newItem.name = name
        
        do {
            try context.save()
            getAllItems()
			print("Created in Core Data")
        } catch {
            fatalError("CORE DATA WRITE FAILED")
        }
    }
    
    ///Deletes a datasetproject from Core Data
    public func deleteItem(item: DataSetProject) {
        context.delete(item)
        
        do {
            try context.save()
			getAllItems()
			print("Deleted from Core Data")
        } catch {
            fatalError("CORE DATA DELETION FAILED")
        }
    }
    
    ///Updates the dataset project in Core Data
    public func updateItem(item: DataSetProject, dataset: Dataset) {
        item.datasetobject = dataset
		item.name = dataset.getName()
        do {
			try context.save()
			getAllItems()
			print("Saved to Core Data")
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
		let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: HomeTiles.identifier, for: indexPath) as! HomeTiles
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        
        cell.dataSetName.text = model.name
		model.datasetobject?.setName(name: model.name!)
        cell.numitems.text = "Contains " + String(model.datasetobject!.getTotalNumItems()) + " items"
        cell.creationDate.text = "Created: " + (model.datasetobject?.getCreationDate())!
        self.selectedDataset = model.datasetobject!
        print(model.datasetobject!.getName())
		cell.myImageView.image = iconChoose()
        cell.openDataset.tag = indexPath.row
        cell.openDataset.addTarget(self, action: #selector(openDataSet(_:)), for: .touchUpInside)
        myCollectionView.addGestureRecognizer(longPressGesture)
        return cell
    }
	
	func iconChoose() -> UIImage {
		return UIImage(named: icons[Int.random(in: 0...5)])!
	}
    
// MARK: OPEN DATASET HANDLING
    
    ///Opens the dataset and loads it from coredata
    @objc func openDataSet(_ sender:UIButton) {
        print("Opening DataSet")
        self.selectedDataset = models[sender.tag].datasetobject!
        print(selectedDataset.getName())
        let vc = storyboard?.instantiateViewController(withIdentifier: "expandedview") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        
        //send the dataset object to the view controllers
		NotificationCenter.default.post(name:Notification.Name("datasetobj"), object: models[sender.tag])
		NotificationCenter.default.post(name:Notification.Name("context"), object: self.context)
        
        self.present(vc, animated: true, completion: nil)
		
		if(self.isEditing) {
			self.updateItem(item: models[sender.tag], dataset: selectedDataset)
			print("saving to core data")
		}
		
		print("got here, checkpoint")
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
