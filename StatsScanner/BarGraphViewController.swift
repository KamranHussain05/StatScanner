//
//  BarGraphViewController.swift
//  StatsScanner
//
//  Created by Kamran on 12/28/21.
//

import Charts
import UIKit

class BarGraphViewController: UIViewController, ChartViewDelegate {
    
    var barChart = BarChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x:0, y:0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.height)
        barChart.center = view.center
        
        var entries = [BarChartDataEntry]()
        
        for e in 0..<10{
            entries.append(BarChartDataEntry(x:Double(e), y:Double(e)))
        }
                           
        let set = BarChartDataSet(entries:entries)
        set.colors = ChartColorTemplates.joyful()
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
}
