//
//  DataPointViewController.swift
//  StatScanner
//
//  Created by Kamran Hussain on 1/20/22.
//  Took over by Caden Pun on 6/4/22.

import UIKit
import SpreadsheetView

var edible : Bool!
var sa : Bool! = true

class DataPointViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    private let spreadsheetView = SpreadsheetView()
    private var dataset : Dataset!
	@IBOutlet var edit: UIButton!
    private var proj : DataSetProject!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	
	required init?(coder: NSCoder) {
		super.init(coder: coder)

        NotificationCenter.default.addObserver(self, selector: #selector(initDataset(_:)), name: Notification.Name("datasetobj"), object: dataset)
	}

	@objc func initDataset(_ notification: Notification) {
		print("DataPointView recieved dataset")
        self.proj = notification.object as? DataSetProject
        self.dataset = self.proj.datasetobject!
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        edible = false
        //print(dataset.getData())
		spreadsheetView.register(DataPointCell.self, forCellWithReuseIdentifier: DataPointCell.identifier)
		spreadsheetView.gridStyle = .solid(width: 2, color: .gray)
        spreadsheetView.dataSource = self
		spreadsheetView.delegate = self
		
        view.addSubview(spreadsheetView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        spreadsheetView.translatesAutoresizingMaskIntoConstraints = false
        spreadsheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        spreadsheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController!.tabBar.frame.height)).isActive = true
        spreadsheetView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        spreadsheetView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
	//MARK: TABLE INIT
	//var count = 0
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
		let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: DataPointCell.identifier, for: indexPath) as! DataPointCell
        if (dataset.isEmpty()) {
            cell.setup(with: "", dataset: self.dataset)
            return cell
        } else {
            cell.setup(with: String(dataset.getData()[indexPath.row][indexPath.section]), dataset: self.dataset)
            cell.dataset = self.dataset
            cell.x = indexPath.column
            cell.y = indexPath.row
            if (!cell.getText().isNumeric) {
                cell.backgroundColor = .systemFill
            }
		}
		return cell
	}
	
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        if (dataset.isEmpty()) {
            //return Int(view.frame.size.width/100)
            return 4
        } else {
            return self.dataset.getKeys().count
        }
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        if (dataset.isEmpty()) {
            return Int(view.frame.size.height/50)
        } else {
            return self.dataset.getData().count
        }
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        let headerCount = dataset.getKeys().count
        if (headerCount == 0 || (headerCount == 1 && dataset.getKeys()[0].isEmpty)) {
            return (view.frame.size.width - 5.0)/4.0
        } else if (headerCount < 5) {
            return (view.frame.size.width - 5.0) / CGFloat(headerCount)
        } else {
            return 150
        }
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
      return 50
    }
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        if (dataset.isEmpty()) {
            return 0
        }
        return 1
    }
	
//MARK: ON EDIT CLICK
	
	@IBAction func onEditClick() {
		if (edit.imageView?.image == UIImage(systemName: "arrow.down.circle.fill")) {
			print("Saving")
            edible = false
            edit.setImage(UIImage(systemName: "pencil.tip.crop.circle.badge.plus"), for: .normal)
            
            let home = self.presentingViewController as? HomeViewController
            home?.updateItem(item: self.proj, dataset: self.dataset)

            let stat = tabBarController?.viewControllers?.first as? StatsViewController
            stat?.loadData()
            
            if (sa) {
                showAlert()
            }
		} else if (edit.imageView?.image == UIImage(systemName: "pencil.tip.crop.circle.badge.plus")) {
			print("Editing")
			edit.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
			edible = true
		}
	}
    
    @IBAction func share() {
        self.dataset.toCSV()
        let application = UIApplication.shared
        let url = DataBridge.getDocumentsDirectory()
        let heeheeheehaw : URL!
        let ios = url.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
        heeheeheehaw = URL(string: ios)!
        if (application.canOpenURL(heeheeheehaw)) {
            application.open(heeheeheehaw, options: [:], completionHandler: nil)
        } else if (application.canOpenURL(url)) {
            application.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showAlert() {
        let dialog = UIAlertController(title:"Cells Uneditable", message:"Cancel saving to resume editing.", preferredStyle: .alert)
        let one = UIAlertAction(title:"Do not show me this again", style: .default, handler: {(alert:UIAlertAction!)-> Void in sa = false})
        // maybe style destructive if red text is better
        let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
        
        dialog.addAction(one)
        dialog.addAction(okAction)
        dialog.preferredAction = one
        present(dialog, animated:true)
    }
}

	//MARK: Cell Handling

class DataPointCell: Cell, UITextFieldDelegate {
	
	static let identifier = "datapoint"
	
	private let field = UITextField()
    var x : Int! = 0
    var y : Int! = 0
	var dataset: Dataset!
	
    public func setup(with text: String, dataset : Dataset) {
		field.text = text
		field.textColor = .label
        field.keyboardType = .numbersAndPunctuation
		field.textAlignment = .center
		field.returnKeyType = .done
		field.delegate = self
        self.backgroundColor = .systemBackground
        self.dataset = dataset
		contentView.addSubview(field)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
        field.sizeToFit()
		field.delegate = self
		field.frame = contentView.bounds
	}
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return edible
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.becomeFirstResponder()
        if (edible) {
            if (self.field.text!.isNumeric) { // is a number
                let val = Double(self.field.text!)!
                self.dataset.updateVal(x: self.x, y: self.y, val: String(val))
                print("new val: \(val), coordinates: (\(self.x!), \(self.y!))")
                print(self.dataset.getNumericalData())
                print(self.dataset.getData())
                field.resignFirstResponder()
            } else if (self.backgroundColor == .systemFill) { // is a header
                let val = String(self.field.text!)
                //self.dataset.updateKey(x: self.x, y: self.y, val: val)
                self.dataset.updateKey(y: self.x, val: val)
                print("new key: \(val), coordinates: (\(self.x!), \(self.y!))")
                print(self.dataset.getKeys())
                field.resignFirstResponder()
            }
        }
        return edible
	}
	
	func getText() -> String {
		return field.text!
	}
}
