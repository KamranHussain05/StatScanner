//
//  DataSetViewController.swift
//  StatScanner
//
//  Created by Kamran on 12/31/21
//

import UIKit

class DataSetViewController: UIViewController {
    
    private var datasetobj: Dataset!

    @IBOutlet var datasetName: UILabel!
    @IBOutlet var creationDate: UILabel!
    @IBOutlet var numitems: UILabel!
    @IBOutlet var back: UIButton!
    
    @IBOutlet var mean: UILabel!
    @IBOutlet var mode: UILabel!
    @IBOutlet var range: UILabel!
    @IBOutlet var max: UILabel!
    @IBOutlet var min: UILabel!
    @IBOutlet var standardDev: UILabel!
    @IBOutlet var standardError: UILabel!
    @IBOutlet var median: UILabel!
    
    @IBOutlet var ml1: UIButton!
    @IBOutlet var ml2: UIButton!
    @IBOutlet var ml3: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        loadData()
    }
    
    @objc func setDataSetObject(_ notification: Notification) {
        print("statistics view recieved dataset")
        datasetobj = (notification.object as! Dataset)
    }
    
    func loadData() {
        datasetName.text = datasetobj.name
        creationDate.text = datasetobj.creationDate
        numitems.text = String(datasetobj.getTotalNumItems())
        
        mean.text = String(round(1000 * datasetobj.calculations[7]) / 1000)
        mode.text = String(datasetobj.calculations[2])
        range.text = String(datasetobj.calculations[4])
        max.text = String(datasetobj.calculations[0])
        min.text = String(datasetobj.calculations[1])
        standardDev.text = String(round(1000 * datasetobj.calculations[5]) / 1000)
        standardError.text = String(round(1000 * datasetobj.calculations[6]) / 1000)
        median.text = String(datasetobj.calculations[3])
    }
    
    @IBAction func onBackClick(_sender:UIButton) {
        if (_sender == self.back){
            self.dismiss(animated:true)
        }
    }
}

// Created by Caden 6/22/22
//MARK: View Controller

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var back: UIButton!
    private var datasetobj: Dataset!
    
    private var titles = [String]()
    private var names = [String]()
    private var calcs = [String]()
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(StatsCell.self, forCellReuseIdentifier: StatsCell.identifier)
        return table
    }()
    
    var models = [section]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configure()
        title = "Stats"
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.frame = view.bounds
        view.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController!.tabBar.frame.height)).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadData()
    }
    
    @objc func setDataSetObject(_ notification: Notification) {
        print("statistics view recieved dataset")
        datasetobj = (notification.object as! Dataset)
    }
    
    func loadData() {
        titles.append("Information")
        titles.append("Averages")
        titles.append("Scope")
        titles.append("Error")
        names.append("Name")
        names.append("Creation Date")
        names.append("Data Points")
        names.append("Mean")
        names.append("Median")
        names.append("Mode")
        names.append("Max")
        names.append("Min")
        names.append("Range")
        names.append("Standard Deviation")
        names.append("Standard Error")
        calcs.append(datasetobj.name)
        calcs.append(datasetobj.creationDate)
        calcs.append(String(datasetobj.getTotalNumItems()))
        calcs.append(String(round(1000 * datasetobj.calculations[7]) / 1000))
        calcs.append(String(datasetobj.calculations[3]))
        calcs.append(String(datasetobj.calculations[2]))
        calcs.append(String(datasetobj.calculations[1]))
        calcs.append(String(datasetobj.calculations[0]))
        calcs.append(String(datasetobj.calculations[4]))
        calcs.append(String(round(1000 * datasetobj.calculations[5]) / 1000))
        calcs.append(String(round(1000 * datasetobj.calculations[6]) / 1000))
    }
    
    func configure() {
        models.append(section(title: titles[0], cells: [cellStruc(title: names[0], calc: calcs[0]) {}, cellStruc(title: names[1], calc: calcs[1]) {}, cellStruc(title: names[2], calc: calcs[2]) {}]))
        models.append(section(title: titles[1], cells: [cellStruc(title: names[3], calc: calcs[3]) {}, cellStruc(title: names[4], calc: calcs[4]) {}, cellStruc(title: names[5], calc: calcs[5]) {}]))
        models.append(section(title: titles[2], cells: [cellStruc(title: names[6], calc: calcs[6]) {}, cellStruc(title: names[7], calc: calcs[7]) {}, cellStruc(title: names[8], calc: calcs[8]) {}]))
        models.append(section(title: titles[3], cells: [cellStruc(title: names[9], calc: calcs[9]) {}, cellStruc(title: names[10], calc: calcs[10]) {}]))
        /*for i in 0...3 {
            models.append(section(title: titles[i], cells: []))
            for z in models {
                models[i].add(cell: )
            }
        }*/
    }
    
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
    }
    
    @IBAction func onBackClick(_sender:UIButton) {
        if (_sender == self.back){
            self.dismiss(animated:true)
        }
    }
}

//MARK: Structs

struct cellStruc {
    let title: String
    let calc: String
    var handler: (()-> Void)
}

struct section {
    let title: String
    var cells: [cellStruc]
    
    /*mutating func add(_ cell: cellStruc) {
        cells.append(cell)
    }*/
}

//MARK: Stats Cells

class StatsCell: UITableViewCell {
    static let identifier = "StatsCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let numbers : UILabel = {
        let numbers = UILabel()
        //numbers.text = "cocoa puffs"
        numbers.numberOfLines = 1
        return numbers
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        numbers.textAlignment = .justified
        numbers.sizeToFit()
        accessoryView = numbers
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 20, y: 0, width: contentView.frame.size.width - 5, height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        numbers.text = nil
    }
    
    public func configure(with model: cellStruc) {
        label.text = model.title
        numbers.text = model.calc
        print("L" + numbers.text! + "L")
    }
}
