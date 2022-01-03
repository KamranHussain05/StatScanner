//
//  LineChartViewController.swift
//  StatsScanner
//
//  Created by Kamran on 12/29/21.
//

import UIKit
import Charts

class LineChartViewController: UIViewController, ChartViewDelegate {
    
    var lineChart = LineChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lineChart.frame = CGRect(x:0, y:0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.height)
        
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        //create array of entries and add a BarChartDataEntry object to each index
        var entries = [ChartDataEntry]()
        for e in 0..<10{
            entries.append(ChartDataEntry(x:Double(e), y:Double(e)))
        }
             
        //convert the array entries to a barchart entry object
        let set = LineChartDataSet(entries:entries)
        set.colors = ChartColorTemplates.material()
        
        //convert entry object to barchat dataset object
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }

}
