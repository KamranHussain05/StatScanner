//
//  GraphDirectorViewController.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/17/22.
//

import UIKit
import AAInfographics

class GraphDirectorViewController: UIViewController {

    @IBOutlet var scatterPlot: UIButton!
    @IBOutlet var lineGraph: UIButton!
    @IBOutlet var barChart: UIButton!
    @IBOutlet var pieChart: UIButton!
    @IBOutlet var areaChart: UIButton!
    @IBOutlet var boxPlot: UIButton!
    @IBOutlet var bubbleChart: UIButton!
    @IBOutlet var waterfallPlot: UIButton!
    @IBOutlet var polygonChart: UIButton!
    
    private var focused = AAChartType(rawValue: "scatter")
    private var dataset = Dataset()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(initDataSet(_:)), name: Notification.Name("datasetobject"), object: nil)
    }
    
    @objc func initDataSet(_ notification: Notification) {
        self.dataset = notification.object as! Dataset
    }
    
    @IBAction func graphSelected(_sender : UIButton) {
        if(_sender == scatterPlot) {
            focused = AAChartType.scatter
            print("scatter")
        } else if (_sender == lineGraph) {
            focused = AAChartType.line
            print("line")
        } else if (_sender == barChart) {
            focused = AAChartType.bar
            print("bar")
        } else if (_sender == pieChart) {
            focused = AAChartType.pie
            print("pie")
        } else if (_sender == areaChart) {
            print("area")
            focused = AAChartType.arearange
        } else if (_sender == bubbleChart) {
            print("bubble")
            focused = AAChartType.bubble
        } else if (_sender == waterfallPlot) {
            print("waterfall")
            focused = AAChartType.waterfall
        } else if (_sender == polygonChart) {
            print("polygon")
            focused = AAChartType.polygon
        }
        
        let vc  = storyboard?.instantiateViewController(withIdentifier: "graphvisualization") as! LinePlotViewController
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
        
        NotificationCenter.default.post(name: Notification.Name("type"), object: self.focused)
        print("sent to graph")
        
        title = dataset.getName()
        NotificationCenter.default.post(name: Notification.Name("title"), object: title)
        
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
