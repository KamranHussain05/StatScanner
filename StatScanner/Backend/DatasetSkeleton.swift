//
//  DatasetSkeleton.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 7/22/22.
//

import Foundation
import CoreData
import UIKit

@objc(Dataset)
public class Dataset: NSObject, NSCoding {
    
// MARK: Field Variables
    
    private var rawData : [[String]]!
    private var keys : [[String]]!
    private var numericalData : [Double]!
    private var calculations : [Double]!
    private var graphData : [[Double]]!
    
    private var creationDate : String!
    private var name : String!
    private var icon : UIImage!
    
    private let db = DataBridge()
    private let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter
    }()

// MARK: CoreData Configuration
    
    public func encode(with coder: NSCoder) {
        coder.encode(rawData, forKey: "rawData")
        coder.encode(keys, forKey: "keys")
        coder.encode(numericalData, forKey: "numericalData")
        coder.encode(calculations, forKey: "calculations")
        coder.encode(creationDate, forKey: "creationDate")
        coder.encode(name, forKey: "name")
        coder.encode(icon, forKey: "icon")
        coder.encode(graphData, forKey: "graphData")
    }
    
//MARK: Initializers
    
    required convenience public init?(coder decoder: NSCoder) {
        self.init()
        
        self.rawData = decoder.decodeObject(forKey:"rawData") as? [[String]] ?? [[]]
        self.keys = decoder.decodeObject(forKey: "keys") as? [[String]] ?? [[],[],[]]
        self.numericalData = decoder.decodeObject(forKey:"numericalData") as? [Double] ?? []
        self.calculations = decoder.decodeObject(forKey: "calculations") as? [Double] ?? []
        self.creationDate = decoder.decodeObject(forKey: "creationDate") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.icon = decoder.decodeObject(forKey: "icon") as? UIImage ?? UIImage(named: "DataSetIcon1")
        self.graphData = decoder.decodeObject(forKey: "graphData") as? [[Double]] ?? [[]]
    }
    
    override init() {
        super.init()
        
        self.name = "New Unnamed Dataset"
        self.icon = UIImage(named: "DatasetIcon1")
        self.creationDate = formatter.string(from: Date())
        self.rawData = []
        self.keys = [[],[],[]]
        self.numericalData = []
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
        self.graphData = [[0]]
    }
    
    init(name: String, icon: UIImage, appendable: [[String]]) {
        super.init()
        
        self.name = name
        self.icon = icon
        self.creationDate = formatter.string(from: Date())
        self.rawData = appendable
        self.cleanRaw()
        self.keys = self.solveKeys(self.rawData)
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
        self.updateNumData()
        self.calculations = Calculations(dataset : self.numericalData).calculate()
        self.graphData = self.genGraphData(array: self.rawData)
    }
    
    init(name: String, icon: UIImage, appendable: [[String]], from_scan: Bool) {
        super.init()
        
        self.name = name
        self.icon = icon
        self.creationDate = formatter.string(from: Date())
        self.rawData = appendable
        self.keys = self.solveKeys(self.rawData)
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
        self.updateNumData()
        self.calculations = Calculations(dataset : self.numericalData).calculate()
        self.graphData = self.genGraphData(array: self.rawData)
    }
    
    init(name: String, icon: UIImage) {
        super.init()
        
        self.name = name
        self.icon = icon
        let rows = Int(UIScreen.main.bounds.height/50)
        self.rawData = Array<Array<String>>(repeating: Array<String>(repeating: "", count: 4), count: rows)
        self.creationDate = formatter.string(from: Date())
        self.numericalData = []
        self.keys = [[], [], []]
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
        self.calculations = Calculations(dataset: numericalData).calculate()
        self.graphData = [[]]
    }
    
// MARK: Data Pre-Processing
    
    /// Solves the keys and determines which keys are being used
    private func solveKeys(_ data:[[String]]) -> [[String]] {
        var res : [[String]] = [[""],[""]]
        
        // Check if top is keys
        var topCount = 0
        for i in 0...data[0].count-1 {
            if(!data[0][i].isNumeric && !data[0][i].isEmpty) {
                topCount += 1
            }
        }
        
        if(topCount > 1) {
            res[0] = data[0]
        }
        
        //Check if left is keys
        var leftCount = 0
        var left : [String] = []
        for i in 0...data.count-1 {
            left.append(data[i][0])
        }
        
        for i in 0...left.count-1 {
            if(!left[i].isNumeric && !left[i].isEmpty) {
                leftCount += 1
            }
        }
        
        if(leftCount > 1) {
            res[1] = left
        }
                
        return res
    }
    
    /// Cleans the raw CSV data and extracts the numerical values for calculation and visualization
    private func updateNumData() {
        var result = Array<Double>()
        for i in 0...self.rawData.count-1 {
            for j in 0...self.rawData[0].count-1 {
                if(self.rawData[i][j].isNumeric) {
                    result.append(Double(self.rawData[i][j])!)
                }
            }
        }
        
        self.numericalData = result
    }
    
    /// Clean rawData array
    private func cleanRaw() {
        let n = self.rawData.count
        for i in (0..<n).reversed() {
            var count = 0
            for j in 0...self.rawData[0].count-1 {
                if (rawData[i][j].isEmpty) {
                    count+=1
                }
            }
            if (count == self.rawData[0].count) {
                self.rawData.remove(at: i)
            }
        }
        for j in 0..<self.rawData[0].count {
            var count = 0
            for i in 0..<self.rawData.count {
                let str = rawData[i][j].trimmingCharacters(in: .whitespacesAndNewlines)
                if (str.isEmpty) {
                    count+=1
                }
            }
            if (count == self.rawData.count) {
                for x in 0..<rawData.count {
                    self.rawData[x].remove(at: j)
                }
            }
        }
    }
    
    private func reCalculate() {
        self.calculations = Calculations(dataset:numericalData).calculate()
    }
    
    private func genGraphData(array: [[String]]) -> [[Double]] {
        // Build the initial array and convert values to doubles
        var joe : Array<Array<String>> = []
        
        if (array.count == 1) {
            return [[]]
        }
        
        for i in 1...array.count-1 {
            joe.append(array[i])
        }
        
        // Rotate the array
        var mid = Array<Array<String>>(repeating: Array<String>(repeating: "", count: joe.count), count: joe[0].count)
        
        for i in 0...mid.count-1 {
            for j in 0...mid[i].count-1 {
                mid[i][j] = joe[j][i]
            }
        }
        
        // Convert to doubles and remove string columns
        var res = Array<Array<Double>>(repeating: Array<Double>(repeating: 0, count: joe.count), count: joe[0].count)
        for i in 0...mid.count-1 {
            res[i] = mid[i].doubleArray
        }
        
        return res
    }
    
    private func refresh() {
        self.keys = self.solveKeys(self.rawData)
        self.updateNumData()
        self.reCalculate()
        self.graphData = self.genGraphData(array: self.rawData)
    }
    
// MARK: Setters
    
    func updateVal(x : Int, y : Int, val : String) {
        self.rawData[y][x] = val
        self.refresh()
    }
    
    func updateKey(x: Int, y: Int, val : String) { //assuming top row key
        if (x == 0) {
            self.keys[1][y] = val
        }
        if (y == 0) {
            self.keys[y][x] = val
        }
        self.rawData[y][x] = val
    }
    
    func setName(name : String) {
        self.name = name
    }
    
    func setIcon(icon: UIImage) {
        self.icon = icon
    }
    
    func addColumn() {
        for i in 0...rawData.count-1 {
            rawData[i].append("")
        }
        self.refresh()
    }
    
    func delColumn() {
        if (rawData[0].count > 1) {
            for i in 0...rawData.count-1 {
                rawData[i].removeLast()
            }
        } else {
            print("become mt dataset")
            let rows = Int(UIScreen.main.bounds.height/50)
            rawData = Array<Array<String>>(repeating: Array<String>(repeating: "", count: 4), count: rows)
        }
        self.refresh()
    }
    
    func addRow() {
        rawData.append(Array<String>.init(repeating: "", count: rawData[0].count))
        
        self.refresh()
    }
    
    func delRow() {
        if (rawData.count > 1) {
            rawData.removeLast()
        } else {
            print("become mt dataset")
            let rows = Int(UIScreen.main.bounds.height/50)
            rawData = Array<Array<String>>(repeating: Array<String>(repeating: "", count: 4), count: rows)
        }
        self.refresh()
    }
    
// MARK: Getters
    
    func getName() -> String {
        return self.name
    }
    
    func getCreationDate() -> String {
        return self.creationDate
    }
    
    func getData() -> [[String]] {
        return self.rawData
    }
    
    func getNumericalData() -> [Double] {
        return self.numericalData
    }
    
    func getKeys() -> [[String]] {
        if(self.isEmpty() || self.keys.isEmpty) {
            return [[],[],[]]
        }
        return self.keys
    }
    
    func getKeys(index: Int) -> [String] {
        if(self.isEmpty() || self.keys.isEmpty) {
            return []
        }
        return self.keys[index]
    }

    func getGraphData() -> [[Double]] {
        return self.graphData
    }
    
    func getColumnCalcs(axis:Int) -> [Double] {
        var bald = Array<Double>(repeating:0.0, count: graphData[0].count)
        var idx = 0
        bald[0] = numericalData[axis]
        
        // Columns
        for i in 1...graphData[0].count-1 {
            idx = axis+(i*(keys[0].count))  // Formula to calculate idx for matrix transposition
            bald[i] = self.numericalData[idx]
        }
        
        let newCalcs = Calculations(dataset:bald).calculate()
        print(newCalcs)
        return newCalcs
    }
    
    func getRowCalcs(axis:Int) -> [Double] {
        var bald = Array<Double>(repeating:0.0, count:graphData.count)
        var idx = 0
        bald[0] = numericalData[axis]
        
        // Rows
        for i in 1...graphData.count-1 {
            idx = (axis*(keys[1].count)) + i // Formula to calculate idx for matrix transposition
            bald[i] = self.numericalData[idx]
        }
        
        let newCalcs = Calculations(dataset:bald).calculate()
        print(newCalcs)
        return newCalcs
    }
    
    func getCalculations() -> [Double] {
        return self.calculations
    }
    
    func getTotalNumItems() -> Int {
        var counter = 0
        if (!self.isEmpty()) {
            for i in 0...rawData.count-1 {
                for j in 0...rawData[i].count-1 {
                    if (!rawData[i][j].isEmpty || rawData[i][j] != "") {
                        counter+=1
                    }
                }
            }
        }
        if (!self.keysEmpty(index:0)) {
            for i in 0...keys.count-1 {
                for j in 0...keys[i].count-1 {
                    if (!keys[i][j].isEmpty || keys[i][j] != "") {
                        counter-=1
                    }
                }
            }
        }
        
        if (counter < 0) {
            return 0
        }
        return counter
    }
    
    func getIcon() -> UIImage {
        return self.icon
    }
    
// MARK: TO CSV

    func toCSV() {
        if (self.isEmpty()) {
            return
        }
        
        let fileName = self.name.replacingOccurrences(of: " ", with: "") + self.creationDate.replacingOccurrences(of: "/", with: "-") + ".csv"
        db.writeCSV(fileName: fileName, data: self.rawData)
    }
    
    func isEmpty() -> Bool{
        if (rawData.isEmpty || rawData[0].isEmpty) {
            return true
        }
        var counter = 0
        for i in 0...rawData.count-1 {
            for j in 0...rawData[i].count-1 {
                if (rawData[i][j].isEmpty || rawData[i][j] == "") {
                    counter+=1
                }
            }
        }
        if (counter == rawData.count*rawData[0].count) {
            return true
        }
        return false
    }
    
    func keysEmpty() -> Bool {
        if (keys.isEmpty) {
            return true
        }
        var counter = 0
        var total = 0
        for i in 0...keys.count-1 {
            for j in 0...keys[i].count-1 {
                total+=1
                if (keys[i][j].isEmpty || keys[i][j] == "") {
                    counter+=1
                }
            }
        }
        if (counter == total) {
            return true
        }
        return false
    }
    
    func keysEmpty(index: Int) -> Bool {
        if (keys[index].isEmpty) {
            return true
        }
        var counter = 0
        for i in 0...keys[index].count-1 {
            if (keys[index][i].isEmpty || keys[index][i] == "") {
                counter+=1
            }
        }
        if (counter == keys[index].count) {
            return true
        }
        return false
    }
}

// MARK: DATA EXTENSIONS
extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}

extension Collection where Iterator.Element == Double {
    var stringArray : [String] {
        return compactMap{ String($0) }
    }
}

extension Collection where Iterator.Element == String {
    var doubleArray: [Double] {
        return compactMap{ Double($0) }
    }
}
