import UIKit
import AAInfographics

class GraphDirectorViewController: UIViewController, UIPickerViewDelegate {
    let screenSize: CGRect = UIScreen.main.bounds
    
    var chartScroller: UIPickerView!
    var chartScrollerView: UIPickerView!
    let chartTypes = ["Scatter Plot", "Line Graph", "Bar Chart", "Pie Chart", "Area Chart", "Box Plot", "Bubble Chart", "Waterfall Plot", "Polygon Chart"]
    let width:CGFloat = 500
    let height:CGFloat = 100
    
    private var focused = AAChartType(rawValue: "scatter")
    private var dataset: Dataset!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // horizontal scroller initialization
        chartScrollerView = UIPickerView()
        chartScrollerView.delegate = self
        chartScrollerView.dataSource = self
        // rotation
        self.view.addSubview(chartScrollerView)
        chartScrollerView.transform = CGAffineTransform(rotationAngle:  -90 * (.pi/180))
        // create the view
        print(screenSize.height)
        chartScrollerView.frame = CGRect(x: 0 - 150, y: screenSize.height - 200, width: view.frame.width + 300, height: height)
        chartScrollerView.backgroundColor = .systemBackground
        
        // dataset importing (with obj c)
//                NotificationCenter.default.addObserver(self, selector: #selector(initDataSet(_:)), name: Notification.Name("datasetobjectgraph"), object: nil)
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
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
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
