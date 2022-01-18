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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            focused = AAChartType.arearange
        } else if (_sender == bubbleChart) {
            focused = AAChartType.bubble
        } else if (_sender == waterfallPlot) {
            focused = AAChartType.waterfall
        } else if (_sender == polygonChart) {
            focused = AAChartType.polygon
        }
        
        let vc  = storyboard?.instantiateViewController(withIdentifier: "graphvisualization") as! LinePlotViewController
        vc.modalPresentationStyle = .popover
        
        NotificationCenter.default.post(name: Notification.Name("charttype"), object: self.focused)
        
        present(vc, animated: true)
        
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