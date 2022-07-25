//
//  DatasetSkeleton.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 7/22/22.
//

import Foundation
import CoreData

@objc(DatasetSkeleton)
public class DatasetSkeleton : NSObject, NSCoding {
    
// MARK: Field Variables
    
    private var rawData : [[String]] = [[]]
    private var keys : [[String]] = [[],[],[]]
    private var numericalData : [[Double]] = [[]]
    var calculations : [Double] = Array<Double>(repeating: 0.0, count: 9)
    
    var creationDate : String!
    var name : String = ""
    
    private let db = DataBridge()
    private let h = HomeViewController()
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
    }
    
    required convenience public init?(coder decoder: NSCoder) {
        self.init()
        self.rawData = decoder.decodeObject(forKey:"rawData") as? [[String]] ?? [[]]
        self.keys = decoder.decodeObject(forKey: "keys") as? [[String]] ?? [[],[],[]]
        self.numericalData = decoder.decodeObject(forKey:"numericalData") as? [[Double]] ?? [[]]
        self.calculations = decoder.decodeObject(forKey: "calculations") as? [Double] ?? []
        self.creationDate = decoder.decodeObject(forKey: "creationDate") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        
    }
    
//MARK: Initializers
    
    override init() {
        self.name = "New Unnamed Dataset"
        self.creationDate = formatter.string(from: Date())
        rawData = []
        
    }
    
    init(name : String, appendable: [[String]]) {
        super.init()
        
        self.name = name
        self.creationDate = formatter.string(from: Date())
        self.rawData = appendable
        self.keys = self.solveKeys(appendable)
        self.numericalData = self.cleanData(appendable)
        self.calculations = Calculations(dataset : numericalData).calculate()
    }
    
    init(name : String) {
        self.name = name
        self.rawData = [["0"]]
        self.creationDate = formatter.string(from: Date())
        self.numericalData = [[0]]
        self.keys = []
        self.calculations = Calculations(dataset: numericalData).calculate()
    }
    
// MARK: Data Pre-Processing
    
    private func solveKeys(_ data:[[String]]) -> [[String]] {
        var res : [[String]] = [[],[],[]]
        res[0] = data[0]
        
        var left : [String] = []
        var right : [String] = []
        
        for i in 0...data.count-1 {
            left.append(data[i][0])
        }
        
        for i in 0...data[data[0].count].count-1 {
            right.append(data[data[0].count-1][i])
        }
        
        return res
    }
    
    private func cleanData(_:[[String]]) -> [[Double]]{
        return [[]]
    }
    
// MARK: Getter and Setters
    
    func getName() -> String {
        return self.name
    }
    
    func getCreationDate() -> String {
        return self.creationDate
    }
    
    func getData() -> [[Double]] {
        if(self.numericalData.count*self.numericalData[0].count < 2) {
            return [[0]]
        }
        return self.numericalData
    }
    
    func getKeys() -> [String] {
        return self.keys[0]
    }
    
    func updateVal(x : Int, y : Int, val : Double) {
        self.numericalData[y][x] = val
    }
    
    func updateKey(x : Int, y : Int, val : String) {
        self.keys[y][x] = val
    }
    
    func getCalculations() -> [Double] {
        return self.calculations
    }
    
    func updateData(x : Int = 0, val : [Double]) {
        self.numericalData.append(val)
    }
    
    func getTotalNumItems() -> Int {
        return rawData.count * rawData[0].count
    }
    
// MARK: TO CSV

    func toCSV() {
        if (self.isEmpty()) {
            return
        }
        var result : Array<Array<String>> = [[]]
        //result.append(keys)
        
        for e in numericalData {
            result.append(e.stringArray)
        }
        print(result)
        
        let fileName = self.name.replacingOccurrences(of: " ", with: "") + self.creationDate.replacingOccurrences(of: "/", with: "-") + ".csv"
        db.writeCSV(fileName: fileName, data: result)
    }
    
    func isEmpty() -> Bool{
        return (numericalData.count * numericalData[0].count) < 2
    }
}
