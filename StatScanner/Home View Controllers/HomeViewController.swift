//
// StatScanner
// HomeViewController.swift
//
// - Summary: Classes, functions, and interfaces needed to power the main screen (Home) of the application. File contains Home view controller class, objects to manage and create home view tiles, and functions to handle CoreData fetches and saves.
//
//  - Created by: Kamran Hussain on 12/31/21.
//  - Authors: Kamran Hussain, Kaleb Kim, Caden Pun

import UIKit
import UniformTypeIdentifiers
import Vision
import VisionKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import MessageUI
import SafariServices

// MARK: Home View Controller

///  Object that manages the Home View including dataset tiles, new dataset creation, and CoreData fetch and handling.
///  - Authors: Kamran Hussain, Kaleb Kim, Caden Pun
///

var loggedin = false
@available(iOS 16.0, *) // Check if iOS version 16 or greater is being used before loading style resources
class HomeViewController: UIViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DataScannerViewControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet var myCollectionView: UICollectionView!		/// Collection view grid layout, variablized for referencing
    @IBOutlet var newDatasetButton: UIButton!				/// New Dataset button that should bring up the menu. Enacts the ActionSheet
	
	@IBOutlet var footer : UIView!
	@IBOutlet var infofooter : UIButton!
	
	private var scan: DataScannerViewController!			/// Variable for the scanning view controller
	private var infer = ModelPostProcess()					/// Reference for the model post-processing pipelin
    private var selectedDataset: Dataset!					/// Skeleton class and variable for referencing the selected dataset from the collection view
	private var sc: CGFloat = 0.05							/// Hard coded spacing value between cells
    private var models = [DataSetProject]()					/// Array of CoreData models that contain Dataset, and tile image
	private let db : DataBridge! = DataBridge()				/// DataBridge object for file I/O
	private var dbuilder = DatasetBuilder()					/// DatasetBuilder object var. Builds a dataset for CoreData

	private let icons = ["DataSetIcon1", "DataSetIcon2", "DataSetIcon3", "DataSetIcon4", "DataSetIcon5", "DataSetIcon6", "DataSetIcon7", "DataSetIcon8", "DataSetIcon9", "DataSetIcon10", "DataSetIcon11", "DataSetIcon12", "DataSetIcon13", "DataSetIcon14", "DataSetIcon15", "DataSetIcon16"]					/// Array of icon images for each dataset tile

  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	/// Loads visuals to create a menu for other view controllers/views.
	/// - Parameters: None
	/// - Returns: None
	///	- Note: All main method processes should be started in this method for simplicity. It is possible this method will be changed
	///	- Warning: This method may be moved to a new "Main" class or function in the future
	///	- Authors: Kaleb Kim
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Handle view layouts and setup
		let layout = UICollectionViewFlowLayout()
		let width = CGFloat(UIScreen.main.bounds.width)
		print(UIScreen.main.bounds.height)
		layout.footerReferenceSize = CGSizeMake(view.frame.size.width, 100)
		
		if (width < 414) {
			layoutConstraints(layout: layout, width: width)
		} else {
			layoutConstraints(layout: layout, width: 414)
		}
		// Create the collection view
		myCollectionView.collectionViewLayout = layout
		
		getAllItems()	// Load all the items from CoreData and load their class references into memory
		
		let newDatasetMenu = constructNewDatasetMenu()
		newDatasetButton.showsMenuAsPrimaryAction = true
		newDatasetButton.menu = newDatasetMenu
		
		infofooter.setTitle(UIApplication.versionBuild() + "  ", for: .normal)
		infofooter.semanticContentAttribute = .forceRightToLeft

		infofooter.menu = UIMenu(children: [UIDeferredMenuElement.uncached { [weak self] completion in
				if let menu = self?.menuGen() as? UIMenu {
					completion([menu])
				}
		}])
		infofooter.showsMenuAsPrimaryAction = true
		
	}
	
	//MARK: Footer Menu
	
	func menuGen() -> UIMenu {
		return UIMenu(title: "Settings", options: .displayInline, children: [actions(), loginOptions()])
	}
	
	func loginOptions() -> UIMenuElement {
		var login : UIMenuElement
		if (loggedin) {
			login = UIMenu(title: "", options: .displayInline, children: [
				UIAction(title: "Log Out", image: UIImage(systemName: "power"), attributes: .destructive) { (action) in
					self.signout()
				},
				UIAction(title: "Profile", image: UIImage(systemName: "person.circle")) { (action) in
					print("profile")
					let profile = ProfileViewController()
					self.present(profile, animated: true)
				}
			])
		} else {
			login = UIMenu(title: "", options: .displayInline, children: [
				UIAction(title: "Google Log In", image: UIImage(named: "googleicon")) { (action) in
					print("google log in")
					//self.signin()
					let dialog = UIAlertController(title:"Coming Soon!", message:"Currently not a top priority :(", preferredStyle: .alert)
					let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
					dialog.addAction(okAction)
					self.present(dialog, animated:true)
				},
				UIAction(title: "Apple Log In", image: UIImage(systemName: "applelogo")) { (action) in
					print("apple log in")
					let dialog = UIAlertController(title:"Coming Soon!", message:"Currently not a top priority :(", preferredStyle: .alert)
					let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
					dialog.addAction(okAction)
					self.present(dialog, animated:true)
				}
			])
		}
		return login
	}
	
	@objc func tapOutside() {
		self.dismiss(animated: true)
	}
	
	func actions() -> UIMenuElement {
		return UIMenu(title: "", options: .displayInline, children: [
			UIAction(title: "Contact Us", image: UIImage(systemName: "mail")) { (action) in
				print("contact us")
				// implement support email and google form
				let email = "pppoopoo@gmail.com"
				if MFMailComposeViewController.canSendMail() {
					let mailer = MFMailComposeViewController()
					mailer.delegate = self
					mailer.mailComposeDelegate = self
					mailer.setSubject("Feedback / Support")
					mailer.setToRecipients([email])
					self.present(mailer, animated: true)
				} else {
					guard let url = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ") else {
						return
					}
					let smelly = SFSafariViewController(url: url)
					self.present(smelly, animated: true)
				}
			},
			UIAction(title: "Donate", image: UIImage(systemName: "dollarsign")) { (action) in
				guard let url = URL(string: "https://www.buymeacoffee.com/StatScanner") else {
					return
				}
				let smelly = SFSafariViewController(url: url)
				self.present(smelly, animated: true)
			},
			UIAction(title: "Watch Tutorial", image: UIImage(systemName: "play.rectangle.on.rectangle")) { (action) in
				guard let url = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ") else {
					return
				}
				let smelly = SFSafariViewController(url: url)
				self.present(smelly, animated: true)
			}
		])
	}
	
	// MARK: User Account Login
	
	func signin() {
		guard let clientID = FirebaseApp.app()?.options.clientID else { return }
		let config = GIDConfiguration(clientID: clientID)
		GIDSignIn.sharedInstance.configuration = config
		GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
			guard error == nil else { return }
			guard let user = result?.user else {return}
			self.verifyuser(user: user) }
	}
	
	func signout() {
		try? Auth.auth().signOut()
		GIDSignIn.sharedInstance.signOut()
		loggedin = false
	}
	
	func verifyuser(user: GIDGoogleUser) {
		Task {
			guard let idToken = user.idToken?.tokenString else {return}
			let accessToken = user.accessToken.tokenString
			let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
			try await Auth.auth().signIn(with: credential)
			loggedin = true
			print("verified")
		}
	}
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}

	// MARK: Frontend Construction Helper Methods
	
	/// Set the layout constraints and ensure the content frame clip to the edges of the device. This function ensures UI elements are properly adapted properly to difference screen resolutions, scales, and sizes.
	/// - Authors: Kaleb Kim
	/// - Parameters
	/// 	- layout: The UICollectionView flow layout. Needed to adapt the defualt layout to the current screen.
	/// 	- width: Spacing between home screen cells
  
	func layoutConstraints(layout: UICollectionViewFlowLayout, width: CGFloat) {
		layout.itemSize = CGSize(width: (width*(1-3*sc))/2, height: (width*(1.25-sc))/2)
		layout.minimumLineSpacing = sc*width
		layout.minimumInteritemSpacing = sc*width
		layout.sectionInset = UIEdgeInsets(top: 0.02*view.frame.size.width, left: sc*width, bottom: 0, right: sc*width)
	}
    
    // when plus button is pressed (creates new menu)
    func constructNewDatasetMenu() -> UIMenu {
		return UIMenu(title: "New Dataset", children: [
			UIAction(title: "Scan Document", image: UIImage(systemName: "camera")) { (action) in
				self.createWithName(method: 0)
			},
			UIAction(title: "Import Image", image: UIImage(systemName: "square.and.arrow.down")) { (action) in
				self.createWithName(method: 1)
			},
			UIAction(title: "Import CSV", image: UIImage(systemName: "chart.bar.doc.horizontal")) { (action) in
				self.createWithName(method: 2)
			},
			UIAction(title: "Create Empty Dataset", image: UIImage(systemName: "doc.badge.plus")) { (action) in
				self.createWithName(method: 3)
			},
			UIAction(title: "OCR Debug", image: UIImage(systemName: "wrench")) { (action) in
				self.present(VisionDebugView(), animated: true)
			}
		])
    }
	
	// MARK: CSV Import Handling
	
    /// Creates a new ``Dataset`` and adds it to CoreData by adding the new dataset to a created ``DatasetProject`` object
	///
	/// - Parameters:
	/// 	- method: Integer of index of the mode of creation for the new dataset. This value should be supplied by the pop-up window that offers options to create a new dataset.
	/// 			- 0: Scan a new dataset using the camera
	/// 			- 1: Scan a new dataset by importing an image
	/// 			- 2: Import from a CSV fiole
	/// 			- 3: Create a new, "raw" dataset
	/// - Returns: Implicitly returns a ``UIAlertController`` object and presents its UI elements on the screen.
	/// - Authors: Kamran Hussain
    func createWithName(method: Int) {
        let alert = UIAlertController(title: "New DataSet Name", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
			
			let new = Dataset(name: text, icon: self!.iconChoose())
            
		switch(method) {
		case 0:
			self?.dbuilder.name = new.getName()
			self?.dbuilder.icon = new.getIcon()
			self?.scanDocument()
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
	
	// MARK: Scan Handling
	
	/// Function for scanning documents and running the *document* image processing pipeline instead of live view camera feed processing
	/// - Authors: Kamran Hussain
	func scanDocument() {
		let documentCameraViewController = VNDocumentCameraViewController()
		documentCameraViewController.delegate = self
		present(documentCameraViewController, animated: true)
	}
    
	func processImage(image: UIImage) {
		// Load and configure the model
		let model_config = MLModelConfiguration()
		model_config.computeUnits = .cpuAndGPU
		
		// Run prediction on the image
		let model = try! TableTransformer_1301x3016(configuration: model_config)
		let inputs = TableTransformer_1301x3016Input(pixel_values_1: image.toCVPixelBuffer()!)
		let outputs = try? model.prediction(input: inputs)
		
		// Extract logits and predicted boxes from outputs. Ignore the other two auxillary outputs
		let logits = outputs!.var_2280
		let pred_boxes = outputs!.var_2298
		
		// Post Process outputs
		let processed_outputs = self.infer.postProcess(logits: logits, pred_boxes: pred_boxes, target_sizes: image.size, threshold: 0.9)
		
		print("============ FINAL BOXES ===============")
		print(processed_outputs)
		
		// Send to dataset building
		let extracted_data = CoordinateTransformer(coor: processed_outputs, img: image)
		print(extracted_data.result())
		
		// MARK: BUGGGGGG
		let debugViewController = VisionDebugView()
		debugViewController.setValues(outputs: self.infer.getFilteredResults(), image: image)
		self.view.addSubview(debugViewController.view)
		debugViewController.didMove(toParent: self)
		present(debugViewController, animated: true)
		
		
//		self.dbuilder.dataset = Dataset(name: self.dbuilder.name, icon: self.dbuilder.icon, appendable: extracted_data.result(), from_scan: true)
//		self.createItem(item: self.dbuilder.dataset, name: self.dbuilder.name)
	}
	
	// MARK: Data Importing
	
	///Import an image from the user's library by presenting a view controller and having the user select which image they would like to be scanned. Sends the image through the scanning pipeline
	/// - Authors: Kamran Hussain
	func importImage() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	
	/// Image picker view that brings up the users photo library and allows them to select an image to be run through the scanning pipeline.
	/// - Parameters:
	/// 		- picker: UIImagePicker Controller that should be presented. This should have all of its configuration done before hand
	/// 		- info: UIImagaePickerController info key for security and data protection staging
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)
		guard let image = info[.editedImage] as? UIImage else {
			print("No image found")
			return
		}

		//let scanner = ScanViewController()
		// this creates a new dataset with the array returned from the ocr pipeline
		//self.dbuilder.dataset = Dataset(name: self.dbuilder.name, icon: self.dbuilder.icon, appendable: scanner.getResults())

		// creates a new dataset in coredata
		//self.createItem(item: self.dbuilder.dataset, name: self.dbuilder.name)

		print(image) // for checking
	}
	
	/// Launches the controller for CSV importing. Ensures proper file encoding and creates a copy of the desired file, then runs it through the CSV importing algorithm.
	///
	/// - Returns: Implicitly returns a UIDocumentPicker view controller for document selection and presents the view controller
	/// - Authors: Kamran Hussain
	func importCSV() {
		let supportedFiles : [UTType] = [UTType.data]
		let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
		controller.delegate = self
		controller.allowsMultipleSelection = false
		present(controller, animated: true, completion: nil)
	}
	
	/// Reads the selected CSV file into a 2D array of strings via the ``DataBridge`` then uses the ``DatasetBuilder`` to create a CoreData dataset object for saving.
	///
	/// - Parameters:
	/// 	- controller: The UIDocumentPicker view controller that contains the document
	/// 	- urls: The document URL provided by the document picker needed to locate and read the file.
	///
	/// - Authors: Kamran Hussain
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
	
	/// Dismiss the controller if the user chooses to cancel the operations. Thread would continue running without this method.
	/// - Parameters:
	/// 	- controller: UIDocumentPicker view controller that should be dismissed
	/// - Authors: Kamran Hussain
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		controller.dismiss(animated: true)
	}
    

// MARK: CORE DATA CONFIGURATION

    /// Fetches all the ``DataSetProject`` from Core Data and presents them in the collection view. Currently loads the entire object into memory which is inefficient and not scalable for larger datasets.
	///
	/// - Parameters:
	/// 	- context: (implicit) App ui delegate view context needed to index the CoreData objects and ensure the proper data is being accessed by the application
	/// 	- myCollectionView: UICollectionView object that is the main view of the application. Acts as a skeleton where each dataset object is loaded in to.
	/// - Authors: Kamran Hussain
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
    
    /// Writes a datasetproject to Core Data by building the ``DataSetProject`` and saving it using context.
	///	- Parameters:
	///		- item: Dataset object that was created
	///		- name: String containing the name of this dataset or the indexable name of this project
	///
	///	- Authors: Kamran Hussain
	///
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
    
	/// Deleted a datasetproject from CoreData
	///	- Parameters:
	///		- item: DatasetProject object that should be delected
	///
	///	- Authors: Kamran Hussain
	///
    public func deleteItem(item: DataSetProject) {
        context.delete(item)
        
        do {
            try context.save()
			getAllItems()
        } catch {
            fatalError("CORE DATA DELETION FAILED")
        }
    }
    
	/// Update a datasetproject in CoreData
	///	- Parameters:
	///		- item: DatasetProject object that should be updated
	///		- dataset: The dataset object that has been updated. The current object in the project is overwritten with the new one.
	///
	///	- Authors: Kamran Hussain
	///
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
	
//	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//		return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "infofooter", for: indexPath)
//	}
    
    /// Specifies the number of cells to add to the collection view
	///
	/// - Parameters:
	/// 	- collectionView: Collection view that should recieve this data. Also needed to know how many cells are currently being displayed
	/// 	- section: Which axis (column or row) does the count need to return.
	/// - Returns:
	/// 	- Integer representing the number of models available in CoreData
	/// - Authors: Kamran Hussain
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
	/// Collection View confirguation that loads a default cell and provides a skeleton for cells that contain a dataset then adds those cells to the collection view
	///
	/// - Parameters:
	/// 	- collectionView: Collection view that the new cells should be added too. Also needed to understand the position of the current cell.
	/// 	- indexPath: The coordinates of the cell as they are displated on the collection view
	///
	/// - Returns: UICell that is completely configured with the dataset, info, and gesture recognition.
	/// - Authors: Kamran Hussain
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
    
    /// Opens the dataset and loads it from coredata. Then sends the dataset and context to the informational view controllers.
	///
	/// - Parameters:
	/// 	- sender: UIButton that was clicked. This cotnains the dataet object and index of the dataset project that need to be sent to the informational view controllers
	///
	/// - Authors: Kamran Hussain
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
    
	/// Handles the long press gesture on a dataset which the deletes the dataset that was clicked. Provides haptic feedback and then creates a pop up confirmation.
	///
	/// - Parameters:
	/// 	- gesture: UIGesture that was used (should be a long press). Uses the gestures data to identify which indexed tile was pressed and then deletes it
	///
	/// - Authors: Kamran Hussain
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

// MARK: Document Scan Handling

@available(iOS 16.0, *)
extension HomeViewController: VNDocumentCameraViewControllerDelegate {
	func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
		
		controller.dismiss(animated: true) {
			DispatchQueue.global(qos: .userInitiated).async {
				for pageNumber in 0 ..< scan.pageCount {
					let image = scan.imageOfPage(at: pageNumber)
					print(image.size)
					let reshaped_image = image.resizeImageTo(size: CGSize(width:1301, height: 2016))
					print(reshaped_image!.size)
                    self.processImage(image: reshaped_image!)
				}
			}
		}
	}
}

// MARK: UIImage Extensions

extension UIImage {
	func toCVPixelBuffer() -> CVPixelBuffer? {
		let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
		var pixelBuffer : CVPixelBuffer?
		let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
		guard status == kCVReturnSuccess else {
			return nil
		}

		if let pixelBuffer = pixelBuffer {
			CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
			let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

			let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
			let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

			context?.translateBy(x: 0, y: self.size.height)
			context?.scaleBy(x: 1.0, y: -1.0)

			UIGraphicsPushContext(context!)
			self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
			UIGraphicsPopContext()
			CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

			return pixelBuffer
		}

		return nil
	}
	
	func resizeImageTo(size: CGSize) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		self.draw(in: CGRect(origin: CGPoint.zero, size: size))
		let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return resizedImage
	}
}

extension Array where Element == [CGFloat] {
	func transpose() -> [[CGFloat]] {
		guard let firstRow = first else { return [] }
		let rowCount = firstRow.count
		var transposed: [[CGFloat]] = .init(repeating: [], count: rowCount)
		for row in self {
			for (i, element) in row.enumerated() {
				transposed[i].append(element)
			}
		}
		return transposed
	}
}
