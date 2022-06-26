//
//  DataPointViewController.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/20/22.
//  This class is lowkey Caden's since 6/4/22

import UIKit
import SpreadsheetView

var edible : Bool!
var sa : Bool!

class DataPointViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    private let spreadsheetView = SpreadsheetView()
    var dataset : Dataset!
	@IBOutlet var edit: UIButton!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)

        NotificationCenter.default.addObserver(self, selector: #selector(initDataset(_:)), name: Notification.Name("datasetobj"), object: dataset)
	}

	@objc func initDataset(_ notification: Notification) {
		print("DataPoint recieved data")
		self.dataset = notification.object as? Dataset
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        edible = false
        sa = true
		NotificationCenter.default.addObserver(self, selector: #selector(initDataset(_:)), name: Notification.Name("datasetobj"), object: nil)
		
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
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
		let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: DataPointCell.identifier, for: indexPath) as! DataPointCell
        if (dataset.isEmpty()) {
            cell.setup(with: "", dataset: self.dataset)
            return cell
        } else if (indexPath.row == 0) {
            cell.setup(with: String(dataset.getKeys()[indexPath.section]), dataset: self.dataset)
            if (!cell.getText().isNumeric) {
                cell.backgroundColor = .systemFill
            }
			cell.dataset = self.dataset
			cell.x = indexPath.column
			cell.y = indexPath.row
			return cell
		} else {
            cell.setup(with: String(dataset.getData()[indexPath.row][indexPath.section]), dataset: self.dataset)
		}
		return cell
	}
	
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        if (dataset.isEmpty()) {
            return Int(view.frame.size.width/100)
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
        if (headerCount < 8) {
            return (view.frame.size.width - 5.0) / CGFloat(headerCount)
        } else {
            return 200
        }
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
      return 50
    }
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
	
	//MARK: ON EDIT CLICK
	
	@IBAction func onEditClick() {
		if (edit.imageView?.image == UIImage(systemName: "arrow.down.circle.fill")) {
			print("Saving")
			edit.setImage(UIImage(systemName: "pencil.tip.crop.circle.badge.plus"), for: .normal)
			edible = false
            if (sa) {
                showAlert()
            }
		} else if (edit.imageView?.image == UIImage(systemName: "pencil.tip.crop.circle.badge.plus")) {
			print("Editing")
			edit.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
			edible = true
		}
	}
    
    func showAlert() {
        let dialog = UIAlertController(title:"Cells Uneditable", message:"Cancel saving to resume editing.", preferredStyle: .alert)
        let one = UIAlertAction(title:"Do not show me this again", style: .default, handler: {(alert:UIAlertAction!)-> Void in sa = false})
        // maybe style destructive if red text is better
        let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
        
        dialog.addAction(one)
        dialog.addAction(okAction)
        dialog.preferredAction = okAction
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
                self.dataset.updateVal(indexX: self.x, indexY: self.y, val: val)
                print(self.dataset.getData())
                field.resignFirstResponder()
            } else if (self.backgroundColor == .systemFill) { // is a header
                let val = String(self.field.text!)
                self.dataset.updateHeader(index: self.x, val: val)
                print(self.dataset.getData())
                field.resignFirstResponder()
            }
        }
        return edible
	}
	
	func getText() -> String {
		return field.text!
	}
	
}
