//
//  DatasetSkeleton.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 7/22/22.
//

import Foundation
import CoreData

@objc(DatasetSkeleton)
public class DatasetSkeleton: NSObject, NSCoding, NSFetchRequestResult {
    
// MARK: Field Variables
    
    @NSManaged private var rawData : [[String]]!
    @NSManaged private var keys : [[String]]!
    @NSManaged private var numericalData : [Double]!
    @NSManaged private var calculations : [Double]!
    
    @NSManaged private var creationDate : String!
    @NSManaged private var name : String!
    
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
    }
    
    required convenience public init?(coder decoder: NSCoder) {
        self.init()
        
        self.rawData = decoder.decodeObject(forKey:"rawData") as? [[String]] ?? [[]]
        self.keys = decoder.decodeObject(forKey: "keys") as? [[String]] ?? [[],[],[]]
        self.numericalData = decoder.decodeObject(forKey:"numericalData") as? [Double] ?? []
        self.calculations = decoder.decodeObject(forKey: "calculations") as? [Double] ?? []
        self.creationDate = decoder.decodeObject(forKey: "creationDate") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
    }
    
//MARK: Initializers
    
    override init() {
        super.init()
        
        self.name = "New Unnamed Dataset"
        self.creationDate = formatter.string(from: Date())
        self.rawData = []
        self.keys = [[],[],[]]
        self.numericalData = []
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
    }
    
    init(name : String, appendable: [[String]]) {
        super.init()
        
        self.name = name
        self.creationDate = formatter.string(from: Date())
        self.rawData = appendable
        self.keys = self.solveKeys(appendable)
        self.numericalData = self.cleanData(appendable)
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
        self.calculations = Calculations(dataset : numericalData).calculate()
    }
    
    init(name : String) {
        super.init()
        
        self.name = name
        self.rawData = [["0"]]
        self.creationDate = formatter.string(from: Date())
        self.numericalData = [0]
        self.keys = []
        self.calculations = Array<Double>(repeating: 0.0, count: 9)
        self.calculations = Calculations(dataset: numericalData).calculate()
    }
    
// MARK: Data Pre-Processing
    
    /// Resolves which axis of the CSV array are keys and adds those keys to a key array, the
    /// method always assumes the top header contains keys.
    /// @Return A 2D String array where the indices are Top, Left, and Right, respectively
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
    
    /// Cleans the raw CSV data and extracts the numerical values for calculation and visualizatin
    private func cleanData(_:[[String]]) -> [Double] {
        var result = Array<Double>()
        for x in 0...self.rawData[0].count {
            for y in 0...self.rawData.count {
                if(self.rawData[x][y].isNumeric) {
                    result.append(Double(self.rawData[x][y])!)
                }
            }
        }
        
        return result
    }
    
// MARK: Getter and Setters
    
    func getName() -> String {
        return self.name
    }
    
    func getCreationDate() -> String {
        return self.creationDate
    }
    
    func getData() -> [[String]] {
        if(self.numericalData.count < 2) {
            return [[""]]
        }
        return self.rawData
    }
    
    func getKeys() -> [String] {
        return self.keys[0]
    }
    
    func updateVal(x : Int, y : Int, val : String) {
        self.rawData[y][x] = val
    }
    
    func updateKey(x : Int, y : Int, val : String) {
        self.keys[y][x] = val
    }
    
    func getCalculations() -> [Double] {
        return self.calculations
    }
    
    func getTotalNumItems() -> Int {
        return rawData.count * rawData[0].count
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
        return (numericalData.count) < 2
    }
}


// MARK: CORE DATA EXTENSIONS

extension DatasetSkeleton {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DatasetSkeleton> {
        return NSFetchRequest<DatasetSkeleton>(entityName: "Dataset")
    }

}

extension DatasetSkeleton: Identifiable {

}

