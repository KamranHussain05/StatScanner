//
//  StatsViewController.swift
//  StatScanner
//
//  Created by Caden Pun on 6/22/22.

//MARK: New Stat View Controller

import UIKit
import CoreGraphics

@available(iOS 16.0, *)
class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var back: UIButton!
    private var datasetobj: Dataset!
    private var proj: DataSetProject!
    private var pickerView : UIPickerView!
    private var calcTypes : [String] = ["Whole Dataset", "Column", "Row"]
    private var chosenAxis: String! = "Whole Dataset"
    private var index: Int!
    
    private var name: String!
    private var date: String!
    private var points: String!
    private var mean: String!
    private var median: String!
    private var mode: String!
    private var min: String!
    private var max: String!
    private var range: String!
    private var stddev: String!
    private var abdev: String!
    private var error: String!
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(StatsCell.self, forCellReuseIdentifier: StatsCell.identifier)
        return table
    }()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [section]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
        
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        title = "Stats"
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        loadData()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController!.tabBar.frame.height)).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    @objc func setDataSetObject(_ notification: Notification) {
        self.proj = notification.object as? DataSetProject
        self.datasetobj = self.proj.datasetobject!
    }
    
    func loadData() {
        let home = self.presentingViewController as? HomeViewController
        home?.updateItem(item: self.proj, dataset: self.datasetobj)
        
        name = datasetobj.getName()
        date = datasetobj.getCreationDate()
        points = String(datasetobj.getTotalNumItems())
        mean = String(round(1000 * datasetobj.getCalculations()[0]) / 1000)
        median = String(round(1000 * datasetobj.getCalculations()[1]) / 1000)
        mode = String(round(1000 * datasetobj.getCalculations()[2]) / 1000)
        min = String(round(1000 * datasetobj.getCalculations()[3]) / 1000)
        max = String(round(1000 * datasetobj.getCalculations()[4]) / 1000)
        range = String(round(1000 * datasetobj.getCalculations()[5]) / 1000)
        stddev = String(round(1000 * datasetobj.getCalculations()[6]) / 1000)
        abdev = String(round(1000 * datasetobj.getCalculations()[7]) / 1000)
        error = String(round(1000 * datasetobj.getCalculations()[8]) / 1000)
        
        models[0].cells[0].calc = name
        models[0].cells[1].calc = date
        models[0].cells[2].calc = points
        models[2].cells[0].calc = mean
        models[2].cells[1].calc = median
        models[2].cells[2].calc = mode
        models[3].cells[0].calc = min
        models[3].cells[1].calc = max
        models[3].cells[2].calc = range
        models[4].cells[0].calc = stddev
        models[4].cells[1].calc = abdev
        models[4].cells[2].calc = error
        
        self.tableView.reloadData()
    }
    
    //MARK: TABLE INIT
    
    func configure() {
        models.append(section(title: "Information", cells: [cellStruct(title: "Name", calc: name) {self.textfieldAlert("New Dataset Name", action: "Rename")}, cellStruct(title: "Creation Date", calc: date) {}, cellStruct(title: "Data Points", calc: points) {}]))
        models.append(section(title:"Configuation", cells: [cellStruct(title: "Axis", calc: calcTypes[0]) {self.axisMenu()}, cellStruct(title: "Index") {self.indexMenu()}]))
        models.append(section(title: "Averages", cells: [cellStruct(title: "Mean", calc: mean) {}, cellStruct(title: "Median", calc: median) {}, cellStruct(title: "Mode", calc: mode) {}]))
        models.append(section(title: "Scope", cells: [cellStruct(title: "Min", calc: min) {}, cellStruct(title: "Max", calc: max) {}, cellStruct(title: "Range", calc: range) {}]))
        models.append(section(title: "Error", cells: [cellStruct(title: "Standard Deviation", calc: stddev) {}, cellStruct(title: "Mean Absolute Deviation", calc: abdev) {}, cellStruct(title: "Standard Error", calc: error) {}]))
    }
    
    // MARK: Text Field Handling
    
    func textfieldAlert(_ title: String, action: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self.datasetobj.setName(name: text)
            self.loadData()
            
            let home = self.presentingViewController as? HomeViewController
            home?.updateItem(item: self.proj, dataset: self.datasetobj)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel/*, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
        }*/))
        alert.popoverPresentationController?.sourceView = self.view
        present(alert, animated:true)
    }
    
    // MARK: Table View Configuration
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = models[section]
        return model.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].cells[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatsCell.identifier, for: indexPath) as? StatsCell else {
            return UITableViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].cells[indexPath.row]
        model.handler()
        self.tableView.reloadData()
    }
    
    @IBAction func onBackClick(_sender:UIButton) {
        if (_sender == self.back) {
            self.dismiss(animated:true)
        }
    }
    
    // MARK: Picker Menu Setup
    
    func axisMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for option in calcTypes {
            let action = UIAlertAction(title: option, style: .default, handler: { [self] (action) in
                self.models[1].cells[0].calc = option
                self.chosenAxis = option
                self.tableView.reloadData()
            })
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func indexMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var options : [Int]! = [0]
        var ax = 0
        if(chosenAxis == calcTypes[0]) {
            ax = 0
        } else if(chosenAxis == calcTypes[1]) {
            for i in 0...self.datasetobj.getGraphData().count-2 {
                options.append(i+1)
            }
            ax=1
        } else {
            for i in 0...self.datasetobj.getGraphData()[0].count-1 {
                options.append(i+1)
            }
            ax=2
        }
        
        for option in options {
            let action = UIAlertAction(title: String(option), style: .default, handler: { [self] (action) in
                self.models[1].cells[1].calc = String(option)
                var newCalc = [0.0]
                // Update the stats
                if(ax==0) {
                    updateCalcs(newCalc:self.datasetobj.getCalculations(), num:self.datasetobj.getTotalNumItems())
                } else if(ax==1) {
                    newCalc = self.datasetobj.getColumnCalcs(axis: option)
                    updateCalcs(newCalc: newCalc, num:options.count)
                } else {
                    newCalc = self.datasetobj.getRowCalcs(axis: option)
                    updateCalcs(newCalc: newCalc, num:options.count)
                }
            })
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateCalcs(newCalc:[Double], num:Int) {
        models[0].cells[2].calc = String(num)
        models[2].cells[0].calc = String(round(1000 * newCalc[0]) / 1000)
        models[2].cells[1].calc = String(round(1000 * newCalc[1]) / 1000)
        models[2].cells[2].calc = String(round(1000 * newCalc[2]) / 1000)
        models[3].cells[0].calc = String(round(1000 * newCalc[3]) / 1000)
        models[3].cells[1].calc = String(round(1000 * newCalc[4]) / 1000)
        models[3].cells[2].calc = String(round(1000 * newCalc[5]) / 1000)
        models[4].cells[0].calc = String(round(1000 * newCalc[6]) / 1000)
        models[4].cells[1].calc = String(round(1000 * newCalc[7]) / 1000)
        models[4].cells[2].calc = String(round(1000 * newCalc[8]) / 1000)
        
        self.tableView.reloadData()
    }
    
}

//MARK: Structs

struct cellStruct {
    let title: String
    var calc: String!
    var handler: (()-> Void)
}

struct section {
    let title: String
    var cells: [cellStruct]
}

//MARK: StatsCell

class StatsCell: UITableViewCell {
    static let identifier = "StatsCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let numbers : UILabel = {
        let numbers = UILabel()
        numbers.numberOfLines = 1
        return numbers
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(numbers)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        numbers.sizeToFit()
        numbers.frame = CGRect(x: (contentView.frame.size.width - numbers.frame.size.width) - 20, y: (contentView.frame.size.height - numbers.frame.size.height)/2, width: numbers.frame.size.width, height: numbers.frame.size.height)
        label.frame = CGRect(x: 20, y: 0, width: contentView.frame.size.width - 5, height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        numbers.text = nil
    }
    
    public func configure(with model: cellStruct) {
        label.text = model.title
        numbers.text = model.calc
    }
}
