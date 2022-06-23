// Created by

import UIKit
import AAInfographics

class GraphDirectorViewController: UIViewController, UIPickerViewDelegate {
    let screenSize: CGRect = UIScreen.main.bounds // THIS INCLUDES THE NAVIGATION BAR
    
    var chartScrollerView: UIPickerView!
    var currentGraph:String = "Scatter Plot" // default view begins on scatter plot
    let chartTypeLabels = ["Scatter Plot", "Line Graph", "Bar Chart", "Pie Chart", "Area Chart", "Box Plot", "Bubble Chart", "Waterfall Plot", "Polygon Chart"]
    let chartTypes = [AAChartType.scatter, AAChartType.line, AAChartType.bar, AAChartType.pie, AAChartType.area, AAChartType.boxplot, AAChartType.bubble, AAChartType.waterfall, AAChartType.polygon]
    let width:CGFloat = 200
    let height:CGFloat = 50
    
    // for displaying the dataset
    var dataset = Dataset() // the current dataset which the user is on
    
    var aaChartView: AAChartView!
    var switchingGraph = false
    let aaChartModel = AAChartModel()
    var currentGraphType: AAChartType = AAChartType.scatter
    var xvals = [String]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        NotificationCenter.default.addObserver(self, selector: #selector(initDataSet(_:)), name: Notification.Name("datasetobjectgraph"), object: nil)
    }
    
    @objc func initDataSet(_ notification: Notification) {
        dataset = (notification.object as! Dataset)
        print("graph director successfully got dataset")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(initDataSet(_:)), name: Notification.Name("datasetobjectgraph"), object: nil)
        
        // horizontal scroller initialization
        chartScrollerView = UIPickerView()
        chartScrollerView.delegate = self
        chartScrollerView.dataSource = self
        self.view.addSubview(chartScrollerView)
        
        chartScrollerView.transform = CGAffineTransform(rotationAngle:  -90 * (.pi/180))
        // create the view
        chartScrollerView.frame = CGRect(x: 0, y: screenSize.height - height - screenSize.height/15 - 50, width: screenSize.width, height: height)
        chartScrollerView.backgroundColor = .systemBackground
        
        // graph view initialization
        aaChartView = AAChartView()
        aaChartView.delegate = self
        
        aaChartView.frame = CGRect(x: 0, y: screenSize.height/15, width: screenSize.width, height: 3*screenSize.height/4)
        self.view.addSubview(aaChartView)
    }
}

extension GraphDirectorViewController: AAChartViewDelegate {
    override func viewDidLayoutSubviews() {
        aaChartModel
            .chartType(currentGraphType)
            .animationType(.easeInSine)
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
//            .categories(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
//                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
            .categories(xvalsFormatted())
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .title(dataset.name)
            .backgroundColor("#ffffff")
//            .series([
//                AASeriesElement()
//                    .name("Tokyo")
//                    .data([7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]),
//                AASeriesElement()
//                    .name("New York")
//                    .data([0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]),
//                AASeriesElement()
//                    .name("Berlin")
//                    .data([0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]),
//                AASeriesElement()
//                    .name("London")
//                    .data([3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]),
//                    ])
            .series(formattedData())
        //The chart view object calls the instance object of AAChartModel and draws the final graphic
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    
    func changeGraphType(type: AAChartType){
        currentGraphType = type
        viewDidLayoutSubviews()
        aaChartView.aa_refreshChartWholeContentWithChartModel(aaChartModel)
    }
    
    func addDataCategories(cat:[String]){
        self.aaChartModel.categories(cat)
    }
    
    private func xvalsFormatted() -> [String] {
        var result = [String]()
        let ds = dataset.getData(axis: 0)
        for i in 0...ds.count-1 {
            result.append(String(ds[i]))
        }
        return result
    }
    
    private func formattedData() -> [AASeriesElement] {
        var arr = [AASeriesElement]()
        let d = dataset.getData()
        
        if(dataset.getData().count == 0){
            arr.append(AASeriesElement().data([0]))
            return arr
        }
        
        for i in 0...d[0].count-1 {
            arr.append(AASeriesElement()
                        .name(dataset.getKeys()[i])
                        .data(dataset.getData(axis:i))
            )
        }
        return arr
    }
}

extension GraphDirectorViewController: UIPickerViewDataSource {
    // delegate/datasource method declaration for the horizontal scroller
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return chartTypeLabels.count
    }
    
    /// Changes graph when element changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(chartTypes[row] != currentGraphType) { // ensures graph is not the same
            changeGraphType(type: chartTypes[row])
            print("graph changed to " + currentGraphType.rawValue)
        }
    }
    
    ///Returns current element in the scroller
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("bruh bruh")
        return chartTypeLabels[row]
    }
    
    ///Adjusts width of the carousel
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return width
    }
    
    ///Adjusts height of the carousel
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return height
    }
    
    // responsible for the text
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.text = chartTypeLabels[row]
        label.textColor = .label
        label.textAlignment = .center
        view.addSubview(label)
        
        // rotate!
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
}
