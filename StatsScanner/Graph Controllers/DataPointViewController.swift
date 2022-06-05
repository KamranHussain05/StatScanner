//
//  DataPointViewController.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/20/22.
//

import UIKit
import SpreadsheetView

class DataPointViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    private let spreadsheetView = SpreadsheetView()
	var dataset = Dataset()
	@IBOutlet var edit: UIButton!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)

		NotificationCenter.default.addObserver(self, selector: #selector(initDataset(_:)), name: Notification.Name("datasetobjpoints"), object: nil)
	}

	@objc func initDataset(_ notification: Notification) {
		print("table view recieved data")
		self.dataset = notification.object as! Dataset
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(initDataset(_:)), name: Notification.Name("datasetobjpoints"), object: nil)
		
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
        spreadsheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        spreadsheetView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        spreadsheetView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
	//MARK: TABLE INIT
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
		let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: DataPointCell.identifier, for: indexPath) as! DataPointCell
		if(indexPath.row == 0){ //why is this an if
			cell.setup(with: String(dataset.getKeys()[indexPath.section]))
			cell.backgroundColor = .lightGray
			cell.dataset = self.dataset
			cell.x = indexPath.column
			cell.y = indexPath.row
			return cell
		}
		cell.setup(with: String(dataset.getData()[indexPath.row][indexPath.section]))
		return cell
	}
	
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return self.dataset.getKeys().count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
		return dataset.getData().count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
		//return spreadsheetView.frame.width/CGFloat(self.dataset.getKeys().count)
		return 100
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
      return 50
    }
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	//MARK: ON EDIT CLICK
	
	@IBAction func onEditClick() {
		var edible : Bool! = false
		if (edit.imageView?.image == UIImage(systemName: "arrow.down.circle.fill")) {
			print("saving")
			edit.setImage(UIImage(systemName: "pencil.tip.crop.circle.badge.plus"), for: .normal)
			edible = true
			// code to update csv file and allow editing
		} else if (edit.imageView?.image == UIImage(systemName: "pencil.tip.crop.circle.badge.plus")) {
			print("cancelling")
			edit.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
			edible = false
			// code to disable editing or cancel updating csv file
		}
		if(edible) { // just put something in here so it would run
			print("clicked a cell")
			if (edible) {
				print("able to edit this cell")
				// code to edit clicked cell
			} else {
				print("cannot edit this cell")
				// maybe popup message saying this cell cannot be edited
			}
		}
	}
}

	//MARK: Cell Handling
	// convert edible to a field

class DataPointCell: Cell, UITextFieldDelegate {
	
	static let identifier = "datapoint"
	
	private let field = UITextField()
	var x = 0
	var y = 0
	var dataset: Dataset!
	
	public func setup(with text: String) {
		field.text = text
		field.textColor = .black
		field.keyboardType = .numbersAndPunctuation
		field.textAlignment = .center
		field.returnKeyType = .done
		field.delegate = self
		contentView.addSubview(field)
	}
	
	public func edit() {
		field.isEnabled = true
	}
	
	public func save() {
		field.isEnabled = false
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		field.delegate = self
		field.frame = contentView.bounds
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		let val = Double(self.field.text!)!
		print(val)
		self.dataset.updateVal(indexX: x, indexY: y, val: val)
		return true
	}
	
	override func becomeFirstResponder() -> Bool {
		return true
	}
}
