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

    override func viewDidLoad() {
        super.viewDidLoad()
        spreadsheetView.dataSource = self
        view.addSubview(spreadsheetView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(initDataset(_:)), name: Notification.Name("datasetobjpoints"), object: nil)
        
        spreadsheetView.frame = CGRect(x: 0, y: 130, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    @objc func initDataset(_ notification: Notification) {
        self.dataset = notification.object as! Dataset
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 200
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 400
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
      return 80
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
      return 40
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
