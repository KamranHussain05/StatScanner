//
//  HomeViewController.swift
//  StatScanner
//
//  Created by Kaleb Kim and Kamran Hussain on 12/31/21.
//  Caden Pun

import UIKit
import UniformTypeIdentifiers
import Vision
import VisionKit

// MARK: Home View Controller

@available(iOS 16.0, *)
class HomeViewController: UIViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DataScannerViewControllerDelegate {

    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var newDatasetButton: UIButton!
	
	private var scan: DataScannerViewController!
    private var selectedDataset: Dataset!
	private var sc: CGFloat = 0.05
    private var models = [DataSetProject]()
	private let db : DataBridge! = DataBridge()
	private var dbuilder = DatasetBuilder()

	private let icons = ["DataSetIcon1", "DataSetIcon2", "DataSetIcon3", "DataSetIcon4", "DataSetIcon5", "DataSetIcon6", "DataSetIcon7", "DataSetIcon8", "DataSetIcon9", "DataSetIcon10", "DataSetIcon11", "DataSetIcon12", "DataSetIcon13", "DataSetIcon14", "DataSetIcon15", "DataSetIcon16"]
	
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newDatasetMenu = UIAlertController(title: "New Dataset",
        message: "Select how you would like to import your data",
        preferredStyle: .actionSheet
    )

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let layout = UICollectionViewFlowLayout()
		let width = CGFloat(UIScreen.main.bounds.width)

		if (width < 414) {
			layoutConstraints(layout: layout, width: width)
		} else {
			layoutConstraints(layout: layout, width: 414)
		}
		myCollectionView.collectionViewLayout = layout
        getAllItems()
        
		if(isPhone()) {
            // don't allow user to take a photo if it's a mac (impractical)
            newDatasetMenu.addAction(
                UIAlertAction(title: "Take Image", style: .default) { (action) in
                    self.createWithName(method: 0)
                }
            )
        }
        
        newDatasetMenu.addAction(
            UIAlertAction(title: "Import Image", style: .default) { (action) in
                self.createWithName(method: 1)
            }
        )
        
        newDatasetMenu.addAction(
            UIAlertAction(title: "Import CSV", style: .default) { (action) in
                self.createWithName(method: 2)
            }
        )
		
		newDatasetMenu.addAction(
			UIAlertAction(title: "Empty Dataset", style: .default) { (action) in
				self.createWithName(method: 3)
			}
		)
        
        newDatasetMenu.addAction(
            UIAlertAction(title: "Cancel", style: .destructive) { (action) in
				// user cancels menu, nothing needs to be done
            }
		)
		
    }
	
	func layoutConstraints(layout: UICollectionViewFlowLayout, width: CGFloat) {
		layout.itemSize = CGSize(width: (width*(1-3*sc))/2, height: (width*(1.25-sc))/2)
		layout.minimumLineSpacing = sc*width
		layout.minimumInteritemSpacing = sc*width
		layout.sectionInset = UIEdgeInsets(top: 0.02*view.frame.size.width, left: sc*width, bottom: 0, right: sc*width)
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
			
			let new = Dataset(name: text, icon: self!.iconChoose())
            
		switch(method) {
		case 0:
			self?.dbuilder.name = new.getName()
			self?.dbuilder.icon = new.getIcon()
			self?.captureImage()
		case 1:
			self?.dbuilder.name = new.getName()
			self?.dbuilder.icon = new.getIcon()
			self?.importImage()
		case 2:
			self?.dbuilder.name = new.getName()
			self?.dbuilder.icon = new.getIcon()
			self?.importCSV()
		case 3:
			self?.createItem(item: new, name: new.getName())
			break
		default:
			print("What option did you choose?")
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
    
    ///Take a new picture
	func captureImage() {
//		let picker = UIImagePickerController()
//		picker.sourceType = .camera
//		picker.allowsEditing = true
//		picker.delegate = self
//		present(picker, animated: true)
		scan = DataScannerViewController(
			recognizedDataTypes: [.text()],
		   qualityLevel: .accurate, recognizesMultipleItems: true,
		   isHighFrameRateTrackingEnabled: true,
		   isPinchToZoomEnabled: true,
		   isHighlightingEnabled: true)
		let d = 80.0
		let photo = UIButton(frame: CGRect(x: (view.frame.size.width-d)/2, y: view.frame.size.height-2.75*d, width: d, height: d))
		photo.layer.cornerRadius = d/2
		photo.layer.borderWidth = 5
		photo.layer.borderColor = UIColor.white.cgColor
//		photo.setImage(UIImage(systemName: "circle"), for: .normal)
//		photo.tintColor = .white
		photo.addTarget(self, action: #selector(self.photo), for: .touchUpInside)
		scan.delegate = self
		scan.view.addSubview(photo)
		
		present(scan, animated: true) {
			try? self.scan.startScanning()
		}
    }
	
	@objc func photo() {
		print("pressed the button")
		Task {
			try await asyncStuff()
		}
		scan.stopScanning()
		scan.dismiss(animated: true)
	}
	
	@objc func asyncStuff() async throws {
//		for try await item in scan.recognizedItems {
//			for it in item {
//				switch it {
//				case .text(let text):
//					print("text: \(text.transcript)")
//				default:
//					print("not text")
//			}
//			}
//
//		}
		if let image = try? await scan.capturePhoto() {
			print("took a photo")
			UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
		}
	}
	
	func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
		switch item {
		case .text(let text):
			print("text: \(text.transcript)")
		default:
			print("not text")
		}
	}
	
	///Import an image from the user's library
	func importImage() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)
		guard let image = info[.editedImage] as? UIImage else {
			print("No image found")
			return
		}

		let scanner = OCRScanner(img: info[.editedImage] as! UIImage)
		//let scanner = ScanViewController()
		// this creates a new dataset with the array returned from the ocr pipeline
		self.dbuilder.dataset = Dataset(name: self.dbuilder.name, icon: self.dbuilder.icon, appendable: scanner.getResults())

		// creates a new dataset in coredata
		self.createItem(item: self.dbuilder.dataset, name: self.dbuilder.name)

		print(image) // for checking
	}
	
	///Launches the controller for CSV importing
	func importCSV() {
		let supportedFiles : [UTType] = [UTType.data]
		let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
		controller.delegate = self
		controller.allowsMultipleSelection = false
		present(controller, animated: true, completion: nil)
	}
	
	///Reads the CSV file and loads it into an array of stirngs
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		controller.dismiss(animated: true)
		do {
			let rawFile = try db.readCSV(inputFile: urls[0])
			self.dbuilder.dataset = Dataset(name: self.dbuilder.name, icon: self.dbuilder.icon, appendable: rawFile)
			self.createItem(item: self.dbuilder.dataset, name: self.dbuilder.name)
		} catch FileIOError.CorruptedFile {
			let dialog = UIAlertController(title:"Error Importing CSV", message:"Your CSV file could not be read.", preferredStyle: .alert)
			let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
			dialog.addAction(okAction)
			present(dialog, animated:true)
		} catch {
			print(error)
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
        } catch {
            fatalError("CORE DATA UPDATE FAILED")
        }
    }
}


// MARK: VIEW CONFIG

@available(iOS 16.0, *)
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
		cell.myImageView.image = model.datasetobject!.getIcon()
        cell.openDataset.tag = indexPath.row
        cell.openDataset.addTarget(self, action: #selector(openDataSet(_:)), for: .touchUpInside)
        myCollectionView.addGestureRecognizer(longPressGesture)
        return cell
    }
	
	func iconChoose() -> UIImage {
		return UIImage(named: icons[Int.random(in: 0...15)])!
	}
    
// MARK: OPEN DATASET HANDLING
    
    ///Opens the dataset and loads it from coredata
    @objc func openDataSet(_ sender:UIButton) {
        self.selectedDataset = models[sender.tag].datasetobject!
        let vc = storyboard?.instantiateViewController(withIdentifier: "expandedview") as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        
        //send the dataset object to the view controllers
		NotificationCenter.default.post(name:Notification.Name("datasetobj"), object: models[sender.tag])
		NotificationCenter.default.post(name:Notification.Name("context"), object: self.context)
        
        self.present(vc, animated: true, completion: nil)
		
		if(self.isEditing) {
			self.updateItem(item: models[sender.tag], dataset: selectedDataset)
		}
		
    }
    
    // MARK: LONG PRESS HANDLING
    
    ///Handles the long tap gesture and deletes the selected dataset
    @objc func longTap(_ gesture: UIGestureRecognizer) {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
		
		guard let deletionIndex = myCollectionView.indexPathForItem(at: gesture.location(in: myCollectionView)) else { return }
		
        if(gesture.state == .began) {
            let alert = UIAlertController(title: "Delete Dataset", message: "This is Irreversible", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
				self?.deleteItem(item: self!.models[deletionIndex.row])
                self!.getAllItems()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return } }))
			
            present(alert, animated: true, completion: nil)
        }
    }
}
