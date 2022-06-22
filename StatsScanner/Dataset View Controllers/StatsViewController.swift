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

class StatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var hey: UIButton!
    
    @IBAction func onBackClick(_sender:UIButton) {
        print("hi")
    }
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: StatsCell.identifier)
        return table
    }()
    
    var models = [format]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "Stats"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func configure() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatsCell.identifier, for: indexPath) as? StatsCell else {
            return UITableViewCell()
        }
        cell.configure(with: model)
        cell.textLabel?.text = model.title
        return cell
    }
}

struct format {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    var handler: (()-> Void)
}

class StatsCell: UITableViewCell {
    static let identifier = "StatsCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        label.frame = CGRect(x: 5, y: 0, width: contentView.frame.size.width - 5, height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with model: format) {
        label.text = model.title
        
    }
}
