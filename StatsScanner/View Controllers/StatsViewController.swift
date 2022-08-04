//
//  StatsViewController.swift
//  StatScanner
//
//  Created by Caden Pun on 6/22/22.

//MARK: New Stat View Controller

import UIKit

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var back: UIButton!
    private var datasetobj: Dataset!
    private var proj : DataSetProject!
    
    private var name: String!
    private var date: String!
    private var items: String!
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
        let version = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let label = UILabel(frame: version.bounds)
        label.text = UIApplication.versionBuild()
        label.numberOfLines = 1
        label.textAlignment = .center
        version.addSubview(label)
        tableView.tableFooterView = version
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
        print("StatView recieved dataset")
        self.proj = (notification.object as! DataSetProject)
        self.datasetobj = proj.datasetobject
    }
    
    func loadData() {
        name = datasetobj.getName()
        date = datasetobj.getCreationDate()
        items = String(datasetobj.getTotalNumItems())
        mean = String(round(1000 * datasetobj.getCalculations()[0]) / 1000)
        median = String(datasetobj.getCalculations()[1])
        mode = String(datasetobj.getCalculations()[2])
        min = String(datasetobj.getCalculations()[3])
        max = String(datasetobj.getCalculations()[4])
        range = String(datasetobj.getCalculations()[5])
        stddev = String(round(1000 * datasetobj.getCalculations()[6]) / 1000)
        abdev = String(round(1000 * datasetobj.getCalculations()[7]) / 1000)
        error = String(round(1000 * datasetobj.getCalculations()[8]) / 1000)
        
        models[0].cells[0].calc = name
        models[0].cells[1].calc = date
        models[0].cells[2].calc = items
        models[1].cells[0].calc = mean
        models[1].cells[1].calc = median
        models[1].cells[2].calc = mode
        models[2].cells[0].calc = min
        models[2].cells[1].calc = max
        models[2].cells[2].calc = range
        models[3].cells[0].calc = stddev
        models[3].cells[1].calc = abdev
        models[3].cells[2].calc = error
        
        self.tableView.reloadData()
    }
    
    func configure() {
        models.append(section(title: "Information", cells: [cellStruc(title: "Name", calc: name) {self.textfieldAlert("New Dataset Name", action: "Rename")}, cellStruc(title: "Creation Date", calc: date) {}, cellStruc(title: "Data Points", calc: items) {}]))
        models.append(section(title: "Averages", cells: [cellStruc(title: "Mean", calc: mean) {}, cellStruc(title: "Median", calc: median) {}, cellStruc(title: "Mode", calc: mode) {}]))
        models.append(section(title: "Scope", cells: [cellStruc(title: "Min", calc: min) {}, cellStruc(title: "Max", calc: max) {}, cellStruc(title: "Range", calc: range) {}]))
        models.append(section(title: "Error", cells: [cellStruc(title: "Standard Deviation", calc: stddev) {}, cellStruc(title: "Mean Absolute Deviation", calc: abdev) {}, cellStruc(title: "Standard Error", calc: error) {}]))
    }
    
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
            print("dismissing dataset")
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
extension UIApplication {
    struct Constants {
        static let CFBundleShortVersionString = "CFBundleShortVersionString"
    }
    class func vers() -> String {
        return Bundle.main.object(forInfoDictionaryKey: Constants.CFBundleShortVersionString) as! String
    }
  
    class func build() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
  
    class func versionBuild() -> String {
        let version = vers(), build = build()
      
        return version == build ? "v\(version)" : "v\(version) (\(build))"
    }
}
