// Created by

import UIKit
import AAInfographics

class GraphDirectorViewController: UIViewController, UIPickerViewDelegate {
    let screenSize: CGRect = UIScreen.main.bounds // THIS INCLUDES THE NAVIGATION BAR
    
    var chartScrollerView: UIPickerView!
    let chartTypeLabels = ["Area Chart", "Area Spline Chart", "Bar Chart", "Bubble Chart", "Column Chart", "Column Range Chart", "Line Graph", "Pie Chart", "Polygon Chart", "Pyramid Chart", "Scatter Plot", "Waterfall Plot"]
    let chartTypes = [AAChartType.area, AAChartType.areaspline, AAChartType.bar, AAChartType.bubble, AAChartType.column, AAChartType.columnrange, AAChartType.line, AAChartType.pie, AAChartType.polygon, AAChartType.pyramid, AAChartType.scatter, AAChartType.waterfall]
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

        NotificationCenter.default.addObserver(self, selector: #selector(initDataSet(_:)), name: Notification.Name("datasetobj"), object: nil)
    }
    
    @objc func initDataSet(_ notification: Notification) {
        let proj = (notification.object as! DataSetProject)
        self.dataset = proj.datasetobject!
        print("Graph View received dataset")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        aaChartView.backgroundColor = .systemBackground
        
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
            .title(dataset.getName())
            .series(formattedData())
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
        // The chart view object calls the instance object of AAChartModel and draws the final graphic
        print(UIColor.systemFill)
        let color : AAStyle
        if(self.traitCollection.userInterfaceStyle != .dark) { // light mode
            aaChartModel.backgroundColor("#ffffff")
            color = AAStyle(color: "#000000")
            aaChartModel.titleStyle(color)
            aaChartModel.xAxisLabelsStyle(color)
            aaChartModel.yAxisLabelsStyle(color)
            //aaChartModel.dataLabelsStyle(color)
        } else { // dark mode
            aaChartModel.backgroundColor("#000000")
            color = AAStyle(color: "#ffffff")
            aaChartModel.titleStyle(color)
            aaChartModel.xAxisLabelsStyle(color)
            aaChartModel.yAxisLabelsStyle(color)
            //aaChartModel.dataLabelsStyle(color)
        }
        
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
        let ds = dataset.getData()[0]
        for i in 0...ds.count-1 {
            result.append(String(ds[i]))
        }
        return result
    }
    
    private func formattedData() -> [AASeriesElement] {
        var arr = [AASeriesElement]()
        let d = dataset.getData()
        
        if(dataset.getData().count <= 1) {
            arr.append(AASeriesElement().data([0]))
            return arr
        }
        
        for i in 0...d[0].count-1 {
            arr.append(AASeriesElement()
                        .name(dataset.getKeys()[i])
                        .data(dataset.getData()[i])
            )
        }
        return arr
    }
}

extension GraphDirectorViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return chartTypeLabels.count
    }
    
    /// Changes graph when element changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(chartTypes[row] != currentGraphType) { // ensures graph is not the same (to prevent the graph doesn't prematurely refresh)
            changeGraphType(type: chartTypes[row])
        }
    }
    
    ///Returns current element in the scroller
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
