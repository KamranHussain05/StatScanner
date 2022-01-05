//
//  LinePlotViewController.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/5/22.
//

import UIKit
import AAInfographics

class LinePlotViewController: UIViewController, AAChartViewDelegate {

    var aaChartView = AAChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aaChartView.delegate = self
        
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        
        self.view.addSubview(aaChartView)
    }
    
    override func viewDidLayoutSubviews() {
        <#code#>
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
