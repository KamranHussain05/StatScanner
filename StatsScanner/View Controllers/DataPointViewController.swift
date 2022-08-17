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
        self.proj = notification.object as? DataSetProject
        self.dataset = self.proj.datasetobject!
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        edible = false
		spreadsheetView.register(DataPointCell.self, forCellWithReuseIdentifier: DataPointCell.identifier)
        spreadsheetView.register(AddColumnCell.self, forCellWithReuseIdentifier: AddColumnCell.identifier)
        spreadsheetView.register(AddRowCell.self, forCellWithReuseIdentifier: AddRowCell.identifier)
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
        if((indexPath.column == self.dataset.getKeys().count && !self.dataset.isEmpty()) || (indexPath.column == 4 && self.dataset.isEmpty())) { // addcolumn
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: AddColumnCell.identifier, for: indexPath) as! AddColumnCell
            cell.setup(with: indexPath.row, with: indexPath.column, dataset: self.dataset, view: self.spreadsheetView)
            cell.x = indexPath.column
            cell.y = indexPath.row
            cell.gridlines.top = .none
            cell.gridlines.bottom = .none
            cell.gridlines.right = .none
            return cell
        } else if (indexPath.row == self.dataset.getData().count) { // addrow
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: AddRowCell.identifier, for: indexPath) as! AddRowCell
            cell.setup(with: indexPath.row, with: indexPath.column, dataset: self.dataset, view: self.spreadsheetView)
            cell.x = indexPath.column
            cell.y = indexPath.row
            cell.gridlines.bottom = .none
            cell.gridlines.left = .none
            cell.gridlines.right = .none
            return cell
        }
        
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: DataPointCell.identifier, for: indexPath) as! DataPointCell
        cell.setup(with: String(dataset.getData()[indexPath.row][indexPath.section]), dataset: self.dataset)
        
        // Check if the cell is a key and change its fill color
        for i in 0...self.dataset.getKeys().count-1 { // change when implement side keys
            if (cell.getText() == self.dataset.getKeys()[i] && cell.getText() != "") {
                cell.backgroundColor = .systemFill
            }
        }
        
        cell.dataset = self.dataset
        cell.x = indexPath.column
        cell.y = indexPath.row
        
		return cell
	}
	
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        if (dataset.isEmpty() || self.dataset.getKeys().isEmpty || self.dataset.getKeys() == [""]) {
            return 4+1
        } else {
            return self.dataset.getKeys().count+1
        }
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return self.dataset.getData().count+1
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        let headerCount = dataset.getKeys().count
        if ((column == headerCount && !self.dataset.isEmpty()) || (column == 4 && self.dataset.isEmpty())) {
            return 30
        }
        if (headerCount == 0 || (headerCount == 1 && dataset.getKeys()[0].isEmpty)) {
            return (view.frame.size.width - 5.0) / CGFloat(4+1)
        } else if (headerCount < 6) {
            return (view.frame.size.width - 5.0-30) / CGFloat(headerCount)
        } else {
            return 200
        }
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if(row == self.dataset.getData().count) {
            return 30
        }
        return 50
    }
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        if (self.dataset.isEmpty() || self.dataset.getKeys().isEmpty || self.dataset.getKeys() == [""] || !isPhone()) {
            return 0
        }
        return 1
    }
    
//MARK: ON EDIT CLICK
	
	@IBAction func onEditClick() {
		if (edit.imageView?.image == UIImage(systemName: "arrow.down.circle.fill")) {
            edible = false
            edit.setImage(UIImage(systemName: "pencil.tip.crop.circle.badge.plus"), for: .normal)
            
            let home = self.presentingViewController as? HomeViewController
            home?.updateItem(item: self.proj, dataset: self.dataset)

            let stat = tabBarController?.viewControllers?.first as? StatsViewController
            stat?.loadData()
            
            self.spreadsheetView.reloadData()
            
            if (sa) {
                // showAlert()
            }
		} else if (edit.imageView?.image == UIImage(systemName: "pencil.tip.crop.circle.badge.plus")) {
			edit.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
			edible = true
		}
	}
    
    @IBAction func share() {
        self.dataset.toCSV()
        let mac = DataBridge.getDocumentsDirectory()
        let heeheeheehaw = URL(string: mac.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://"))!
        if (isPhone()) {
            UIApplication.shared.open(heeheeheehaw, options: [:], completionHandler: nil)
        } else if (UIApplication.shared.canOpenURL(mac)) {
            UIApplication.shared.open(mac, options: [:], completionHandler: nil)
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

class DataPointCell : Cell, UITextFieldDelegate {
	
	static let identifier = "datapointcell"
	
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
        
        if (self.backgroundColor == .systemFill) { // is a header
            let val = String(self.field.text!)
            self.dataset.updateKey(x: self.x, val: val)
            field.resignFirstResponder()
        } else { // is a datapoint
            let val = self.field.text!
            self.dataset.updateVal(x: self.x, y: self.y, val: String(val))
            field.resignFirstResponder()
        }
        return edible
	}
	
	func getText() -> String {
		return field.text!
	}
}

class AddColumnCell : Cell {
    
    static let identifier = "addcolumn"
    private var button = UIButton()
    var x : Int! = 0
    var y : Int! = 0
    private var dataset : Dataset!
    private var spview : SpreadsheetView!
    
    public func setup(with x : Int, with y : Int, dataset : Dataset, view : SpreadsheetView) {
        self.x = x
        self.y = y
        self.dataset = dataset
        self.spview = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.sizeToFit()
        button.frame = contentView.bounds
        if (y == 0) {
            button.setImage(UIImage(systemName: "plus.diamond.fill"), for: .normal)
            button.tintColor = .systemGreen
            button.addTarget(self, action: #selector(self.addColumn), for: .touchUpInside)
            contentView.addSubview(button)
        } else if (y == 1) {
            button.setImage(UIImage(systemName: "minus.diamond.fill"), for: .normal)
            button.tintColor = .systemRed
            button.addTarget(self, action: #selector(self.delColumn), for: .touchUpInside)
            contentView.addSubview(button)
        }
        
        self.backgroundColor = .systemBackground
    }
    
    @objc func addColumn() {
        self.dataset.addColumn()
        self.spview.reloadData()
        print("adding column")
    }
    
    @objc func delColumn() {
        self.dataset.delColumn()
        self.spview.reloadData()
        print("deleting column")
    }
    
}

class AddRowCell : Cell {
    
    static let identifier = "addrow"
    private var button : UIButton! = UIButton()
    var x : Int! = 0
    var y : Int! = 0
    private var dataset : Dataset!
    private var spview : SpreadsheetView!
    
    public func setup(with x : Int, with y : Int, dataset : Dataset, view : SpreadsheetView) {
        self.x = x
        self.y = y
        self.dataset = dataset
        self.spview = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.sizeToFit()
        button.frame = contentView.bounds
        if (x == 0) {
            button.setImage(UIImage(systemName: "plus.diamond.fill"), for: .normal)
            button.tintColor = .systemGreen
            button.addTarget(self, action: #selector(self.addRow), for: .touchUpInside)
            contentView.addSubview(button)
        } else if (x == 1) {
            button.setImage(UIImage(systemName: "minus.diamond.fill"), for: .normal)
            button.tintColor = .systemRed
            button.addTarget(self, action: #selector(self.delRow), for: .touchUpInside)
            contentView.addSubview(button)
        }

        self.backgroundColor = .systemBackground
    }
    
    @objc func addRow() {
        self.dataset.addRow()
        self.spview.reloadData()
        print("adding row")
    }
    
    @objc func delRow() {
        self.dataset.delRow()
        self.spview.reloadData()
        print("deleting row")
    }
    
}
