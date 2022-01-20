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
    let aaChartModel = AAChartModel()
    var data = Dataset()
    var type: AAChartType = AAChartType.scatter
    var text = "Data Visualization"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aaChartView.delegate = self
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight-20)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("type"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(didgetData(_:)), name: Notification.Name("data"), object: nil)
        
        self.view.addSubview(aaChartView)
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        self.type = notification.object as! AAChartType
    }
    
    @objc func didgetData(_ notification : Notification) {
        self.data = notification.object as! Dataset
    }
    
    override func viewDidLayoutSubviews() {
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("type"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didgetData(_:)), name: Notification.Name("data"), object: nil)
        
        aaChartModel
            .chartType(type) //Can be any of the chart types listed under `AAChartType`.
            .animationType(.easeInSine)
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            //.tooltipValueSuffix("USD") //the value suffix of the chart tooltip
            .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .title(data.getName())
            .backgroundColor("#ffffff")
            .series([
//                AASeriesElement()
//                    .name(data.getKey(index:0))
//                    .data(data.getData()[0]),
//                AASeriesElement()
//                    .name(data.getKey(index: 1))
//                    .data(data.getData()[0]),
                AASeriesElement()
                    .name("Berlin")
                    .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]),
                AASeriesElement()
                    .name("London")
                    .data([3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]),
                    ])
            //.series(formattedData())
        //The chart view object calls the instance object of AAChartModel and draws the final graphic
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    func changeGraphType(type: AAChartType){
        self.type = type
        //Refresh the chart after the AAChartModel whole content is updated
        aaChartView.aa_refreshChartWholeContentWithChartModel(aaChartModel)
    }
    
    func addDataCategories(cat:[String]){
        self.aaChartModel.categories(cat)
    }
    
    private func formattedData() -> [AASeriesElement] {
        var arr = [AASeriesElement]()
        let d = data.getData()
        
        for i in 0...d.count-1 {
            arr.append(AASeriesElement()
                        .name(self.data.getKeys()[i])
                        .data(data.getData(axis:i))
            )
        }
        return arr
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
