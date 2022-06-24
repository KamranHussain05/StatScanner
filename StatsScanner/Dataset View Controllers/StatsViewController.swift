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
//MARK: New Stat View Controller

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var back: UIButton!
    private var datasetobj: Dataset!
    
    private var name: String!
    private var date: String!
    private var items: String!
    private var mean: String!
    private var median: String!
    private var mode: String!
    private var min: String!
    private var max: String!
    private var range: String!
    private var dev: String!
    private var error: String!
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(StatsCell.self, forCellReuseIdentifier: StatsCell.identifier)
        return table
    }()
    
    var models = [section]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(setDataSetObject(_:)), name: Notification.Name("datasetobj"), object: nil)
        loadData()
        title = "Stats"
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.frame = view.bounds *this stretches the frame to the entire screen
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
        print("StatVIew recieved dataset")
        datasetobj = (notification.object as! Dataset)
    }
    
    func loadData() {
        name = datasetobj.name
        date = datasetobj.creationDate
        items = String(datasetobj.getTotalNumItems())
        mean = String(round(1000 * datasetobj.calculations[7]) / 1000)
        median = String(datasetobj.calculations[3])
        mode = String(datasetobj.calculations[2])
        min = String(datasetobj.calculations[1])
        max = String(datasetobj.calculations[0])
        range = String(datasetobj.calculations[4])
        dev = String(round(1000 * datasetobj.calculations[5]) / 1000)
        error = String(round(1000 * datasetobj.calculations[6]) / 1000)
        
        models[0].cells[0].calc = name
        models[0].cells[1].calc = date
        models[0].cells[2].calc = items
        models[1].cells[0].calc = mean
        models[1].cells[1].calc = median
        models[1].cells[2].calc = mode
        models[2].cells[0].calc = min
        models[2].cells[1].calc = max
        models[2].cells[2].calc = range
        models[3].cells[0].calc = dev
        models[3].cells[1].calc = error
        
        self.tableView.reloadData()
    }
    
    func configure() {
        models.append(section(title: "Information", cells: [cellStruc(title: "Name", calc: name) {}, cellStruc(title: "Creation Date", calc: date) {}, cellStruc(title: "Data Points", calc: items) {}]))
        models.append(section(title: "Averages", cells: [cellStruc(title: "Mean", calc: mean) {}, cellStruc(title: "Median", calc: median) {}, cellStruc(title: "Mode", calc: mode) {}]))
        models.append(section(title: "Scope", cells: [cellStruc(title: "Min", calc: min) {}, cellStruc(title: "Max", calc: max) {}, cellStruc(title: "Range", calc: range) {}]))
        models.append(section(title: "Error", cells: [cellStruc(title: "Standard Deviation", calc: dev) {}, cellStruc(title: "Standard Error", calc: error) {}]))
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
    var calc: String!
    var handler: (()-> Void)
}

struct section {
    let title: String
    var cells: [cellStruc]
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
        //numbers.textAlignment = .right
        numbers.sizeToFit()
        numbers.frame = CGRect(x: (contentView.frame.size.width - numbers.frame.size.width) - 20, y: (contentView.frame.size.height - numbers.frame.size.height)/2, width: numbers.frame.size.width, height: numbers.frame.size.height)
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
    }
}
