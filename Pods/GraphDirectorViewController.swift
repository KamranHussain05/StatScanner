import UIKit
import AAInfographics

class GraphDirectorViewController: UIViewController, UIPickerViewDelegate {
    let screenSize: CGRect = UIScreen.main.bounds
    
    var chartScroller: UIPickerView!
    var chartScrollerView: UIPickerView!
    var currentGraph:String = "Scatter Plot" // default view begins on scatter plot
    let chartTypes = ["Scatter Plot", "Line Graph", "Bar Chart", "Pie Chart", "Area Chart", "Box Plot", "Bubble Chart", "Waterfall Plot", "Polygon Chart"]
    let width:CGFloat = 1000
    let height:CGFloat = 100
    
    // for displaying the dataset
    var focused = AAChartType(rawValue: "scatter")
    var dataset = Dataset() // the current dataset which the user is on
    var graphView: UIView!
    
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
        // rotation
        self.view.addSubview(chartScrollerView)
        chartScrollerView.transform = CGAffineTransform(rotationAngle:  -90 * (.pi/180))
        // create the view
        print(screenSize.height)
        chartScrollerView.frame = CGRect(x: 0 - width/2, y: screenSize.height - 200, width: view.frame.width + width, height: height)
        chartScrollerView.backgroundColor = .systemBackground
        
        // graph view initialization
        graphView = UIView()
        if graphView.frame.isEmpty {
            graphView.frame = CGRect(x: 10, y: 10, width: screenSize.width - 20, height: screenSize.height - 200)
        }
        self.view.addSubview(graphView)
        
        print("view did load")
    }
    
    
    // called when a graph is selected on the carousel
    func graphSelected(_sender : Int) {

//        let vc  = storyboard?.instantiateViewController(withIdentifier: "graphvisualization") as! LinePlotViewController
//        vc.modalPresentationStyle = .popover

        NotificationCenter.default.post(name: Notification.Name("type"), object: self.focused)
        NotificationCenter.default.post(name: Notification.Name("data"), object: self.dataset)
        print("sent to graph")
    }
}
    
extension GraphDirectorViewController: UIPickerViewDataSource {
    // delegate/datasource method declaration for the horizontal scroller
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return chartTypes.count
    }
    
    ///Returns current element in the scroller
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return chartTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return width
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return height
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width + 300, height: height)
        label.text = chartTypes[row]
        label.textColor = .label
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        view.addSubview(label)
        
        // rotate!
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
}
