//
//  DataPointViewController.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/20/22.
//

import UIKit
import SpreadsheetView

class DataPointViewController: UIViewController, SpreadsheetViewDataSource {
    
    
    private let spreadsheetView = SpreadsheetView()
    private var dataset = Dataset()
	
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
        spreadsheetView.dataSource = self
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
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
		if(self.dataset.getKeys().count < 5) {
			return 5
		}
        return self.dataset.getKeys().count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        //return self.dataset.getData(axis: 0).count
		return dataset.getData().count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
      return 70
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
      return 50
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
