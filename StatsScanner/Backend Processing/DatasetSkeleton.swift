//
//  DatasetSkeleton.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 7/22/22.
//

import Foundation
import CoreData

@objc(DataSet)
public class DataSet : NSObject, NSCoding {
    
// MARK: Field Variables
    
    private var rawData : [[String]] = [[]]
    private var keys : [[String]] = [[],[],[]]
    private var numericalData : [[Double]] = [[]]
    private var calculations : [Double] = Array<Double>(repeating: 0.0, count: 9)
    
    private var creationDate : String!
    private var name : String = ""
    
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
    
    public required convenience init?(coder decoder: NSCoder) {
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
    
    public init(name : String, fileContents: [[String]]) {
        super.init()
        self.name = name
        self.creationDate = formatter.string(from: Date())
        self.rawData = fileContents
        self.keys = self.solveKeys(fileContents)
        self.numericalData = self.cleanData(fileContents)
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
}
