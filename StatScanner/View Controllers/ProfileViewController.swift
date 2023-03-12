//
//  ProfileViewController.swift
//  StatScanner
//
//  Created by Caden Pun on 2/24/23.
//

import Foundation
import UIKit
import CoreGraphics
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

@available(iOS 16.0, *)
class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var name: String!
    private var email: String!
    private var accountage: String!
    private var method: String!
    private var back: UIButton!
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        return table
    }()

    private var models = [section]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        
        let user = Auth.auth().currentUser
        email = user!.email
        accountage = String(Calendar.current.dateComponents([.day], from: user!.metadata.creationDate!).day!)
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController!.tabBar.frame.height)).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    //MARK: TABLE INIT
    
    func configure() {
        models.append(section(title: "Information", cells: [cellStruct(title: "Name", calc: name) {}, cellStruct(title: "Email", calc: email) {}, cellStruct(title: "Account Age", calc: accountage) {}, cellStruct(title: "Sign-In Method", calc: method) {}]))
    }
    
    // MARK: Text Field Handling
    
    func textfieldAlert(_ title: String, action: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }

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

//MARK: ProfileCell

class ProfileCell: UITableViewCell {
    static let identifier = "StatsCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let info : UILabel = {
        let info = UILabel()
        info.numberOfLines = 1
        return info
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(info)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        info.sizeToFit()
        info.frame = CGRect(x: (contentView.frame.size.width - info.frame.size.width) - 20, y: (contentView.frame.size.height - info.frame.size.height)/2, width: info.frame.size.width, height: info.frame.size.height)
        label.frame = CGRect(x: 20, y: 0, width: contentView.frame.size.width - 5, height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        info.text = nil
    }
    
    public func configure(with model: cellStruct) {
        label.text = model.title
        info.text = model.calc
    }
}
