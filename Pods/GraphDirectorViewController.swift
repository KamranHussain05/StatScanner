//
//  GraphDirectorViewController.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/17/22.
//

import UIKit
import AAInfographics

class GraphDirectorViewController: UIViewController, UIPickerViewDelegate {

    
    @IBOutlet var chartScroller: UIPickerView!
    let chartTypes = ["Scatter Plot", "Line Graph", "Bar Chart", "Pie Chart", "Area Chart", "Box Plot", "Bubble Chart", "Waterfall Plot", "Polygon Chart"]
    
//    private var focused = AAChartType(rawValue: "scatter")
//    private var dataset: Dataset!
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(initDataSet(_:)), name: Notification.Name("datasetobjectgraph"), object: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartScroller = UIPickerView()
        chartScroller.delegate = self
        chartScroller.dataSource = self
        self.view.addSubview(chartScroller)
//        NotificationCenter.default.addObserver(self, selector: #selector(initDataSet(_:)), name: Notification.Name("datasetobjectgraph"), object: nil)
        let rotationAngle: CGFloat! = -90 * (.pi/180)
        chartScroller.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
//    @objc func initDataSet(_ notification: Notification) {
//        print("graph director got dataset")
//        self.dataset = (notification.object as! Dataset)
//    }
//
//    @IBAction func graphSelected(_sender : Int) {
//
//
//        let vc  = storyboard?.instantiateViewController(withIdentifier: "graphvisualization") as! LinePlotViewController
//        vc.modalPresentationStyle = .popover
//
//        NotificationCenter.default.post(name: Notification.Name("type"), object: self.focused)
//        NotificationCenter.default.post(name: Notification.Name("data"), object: self.dataset)
//        print("sent to graph")
//
//        present(vc, animated: true, completion: nil)
//    }

}

extension GraphDirectorViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return chartTypes.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let modeView = UIView()
//        modeView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        let modeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        modeLabel.textColor = .yellow
//        modeLabel.text = chartTypes[row]
//        modeLabel.textAlignment = .center
//        modeView.addSubview(modeLabel)
//        return modeView
//    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
}
