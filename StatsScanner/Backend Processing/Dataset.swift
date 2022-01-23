//
//  BasicCalculations.swift
//  StatsScanner
//
//  Created by Kamran on 12/20/21.
//  Updated 12/24/21
//

import Foundation
import CoreData

/// A DataSet Object which stores the array, name, creationdate, and more data
@objc(Dataset)
public class Dataset: NSObject, NSCoding {
    
    var data: [[Double]] = [[]]
    var keys: [String] = []
    var xvals: [String] = []
    var name: String = "Unnamed Dataset"
    var creationDate: String!
    let db = DataBridge()
    
    public func encode(with coder: NSCoder) {
		coder.encode(data, forKey:"data")
		coder.encode(keys, forKey:"keys")
        coder.encode(xvals, forKey: "xvals")
        coder.encode(name, forKey: "name")
        coder.encode(creationDate, forKey: "creationDate")
    }
    
    public required convenience init?(coder decoder: NSCoder) {
        self.init()
        
        data = decoder.decodeObject(forKey: "data") as? [[Double]] ?? [[]]
        name = decoder.decodeObject(forKey: "name") as? String ?? "Unnamed Dataset"
        creationDate = decoder.decodeObject(forKey: "creationDate") as? String ?? ""
        keys = decoder.decodeObject(forKey: "keys") as? [String] ?? []
        xvals = decoder.decodeObject(forKey: "xvals") as? [String] ?? []
		
    }
    
    /// Creates a new dataset
    override init() {
        name = "Unnamed DataSet"
        // get the current date and time
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
    }
    
    /// Creates a new dataset and assumes the first row contains the keys
    init(name: String, appendable: [[String]]) {
        super.init()
        self.name = name
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
        
        keys = appendable[0]
        var a = appendable
        a.remove(at: 0)
        self.data = self.cleanData(array: a)
    }
    
    /// Creates a new dataset object with the specified name
    init(name: String) {
        self.name = name
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
    }
    
    /// Returns the data 2d array containg the double values of the data
    func getData() -> [[Double]] {
        return self.data
    }
    
    /// Returns the array containing the data in the specified index
    func getData(axis:Int) -> [Double] {
        var result = [Double]()
        for i in 0...data[0].count-1 {
            result.append(data[axis][i])
        }
        return result
    }
    
    /// Writes the csv files and imports it
    func toCSV() {
        var result = [[String]](repeating: [String](repeating: "", count: data[0].count), count: data.count+1)
        result.insert(keys, at: 0)
        for x in 1...result.count-2 {
            for y in 0...result[x].count-1 {
                result[x][y] = String(data[x-1][y])
            }
        }
        
        let fileName = self.name.replacingOccurrences(of: " ", with: "") + self.creationDate.replacingOccurrences(of: "/", with: "-") + ".csv"
        db.writeCSV(fileName: fileName, data: result)
    }
    
    /// Returns the array containing the extracted keys from the dataset
    func getKeys() -> [String] {
        return self.keys
    }
    
    /// Returns the specified dataset key
    func getKey(index: Int) -> String {
        return self.keys[index]
    }
    
    /// Adds a value to the end of the dataset
    func addVal(val:Double) {
        data[data[0].count-1].append(val)
    }
    
    /// Changes a specific value
    func changeVal(indexX: Int, indexY: Int, val: Double) {
        data[indexX][indexY] = val
    }
    
    /// Adds another dataset or 2D array that does not contain the key row
    func appendArray(array: [[String]]) {
        let cleanArr = cleanData(array: array)
        data.append(contentsOf: cleanArr)
    }
    
    /// Cleans the data and inputs it to an array of Doubles
    private func cleanData(array: [[String]]) -> [[Double]] {
        var result = [[Double]](repeating: [Double](repeating: Double.nan, count: array[0].count), count: array.count)
        for x in 0...array.count-1 {
            for y in 0...array[x].count-1 {
                if(array[x][y].isNumeric) {
                    result[x][y] = Double(array[x][y])!
                } else if(array[x][y].isEmpty){
                    result[x][y] = Double.nan
                }
            }
        }
        return result
    }
    
//===================================
//==    Methods for Statistics     ==
//===================================
    
    /// Returns the number of items in the dataset
    func getTotalNumItems() -> Int {
        var count = 0
        for i in 0...data.count-1 {
            count+=data[i].count
        }
        return count
    }
    
    /// Returns the number of items in the specified variable
    func getNumItems(index:Int) -> Int {
        return data[index].count
    }
    
    /// Returns average of the entire dataset spanning all variables
    func getSetAverage() -> Double{
        var result = 0.0
        for i in 0...data.count-1 {
            for j in 0...data[0].count-1 {
                result+=data[i][j]
            }
        }
        return result/Double(getTotalNumItems())
    }
    
    /// Returns the average of a specified variable
    func getAverage(axis:Int) -> Double{
        var result = 0.0
        for i in 0...data[axis].count-1 {
            result += data[i][axis]
        }
        return result/Double(getNumItems(index: axis))
    }
    
    /// Returns the maximum value of the data set
    func getMax() -> Double {
        var result = [Double]()
        for i in 0...data.count {
            result.append(data[i].max()!)
        }
        return result.max()!
    }
    
    /// Returns the highest value in the specified index
    func getMax(index: Int) -> Double {
        return data[index].max()!
        
    }
    
    /// Returns the minimum value in the data
    func getMin() -> Double {
        var result = [Double]()
        for i in 0...data.count {
            result.append(data[i].min()!)
        }
        return result.min()!
    }
    
    /// Returns the minimum value in the specified index
    func getMin(index:Int) -> Double {
        return data[index].min()!
    }
    
    /// Finds the standard deviation of everything in the dataset
    func getStandardDeviation() -> Double {
        var diffsqrs = 0.0
        for e in data {
            for i in e {
                diffsqrs += pow(i - getSetAverage(), 2)
            }
        }
        return sqrt(diffsqrs - Double(getTotalNumItems()))
    }
    
    /// Finds the standard deviation of the specified axis
    func getStandardDeviation(index:Int) -> Double {
        var diffsqrs = 0.0
        for e in data[index] {
            diffsqrs += pow(e-getAverage(axis: index), 2)
        }
        return sqrt(diffsqrs - Double(getNumItems(index: index)))
    }
    
    /// Returns the mode(s) of the entire dataset
    func getModes() -> [Double] {
        var res = [Double]()
        for i in 0...data.count{
            res.append(contentsOf: getModes(arr: data[i]))
        }
        return getModes(arr: res)
    }
    
    /// Returns the mode(s) of the specified axis
    func getModes(arr: [Double]) -> [Double] {
        var counts: [Double: Double] = [:]
            
        arr.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        if let count = counts.max(by: {$0.value < $1.value})?.value {
             return (counts.compactMap { $0.value == count ? $0.key : nil })
        }
        return []
    }
    
    /// Returns the median of the entire datasete
    func getMedian() -> Double {
        var copy = data
        for i in 0...copy.count-1 {
            copy[i].sort()
        }
        let y = copy.count/2
        let x = copy[y].count/2
        if(y%2 == 0) {
            return (copy[y][copy[x].count-1] + copy[y+1][0]) / 2
        }
        if(x%2 == 0) {
            return (copy[y][x+1] + copy[y][x]) / 2
        }
        
        return copy[x][y]
    }
    
    /// Returns the median of the specified axis
    func getMedian(axis: Int) -> Double {
        var copy = data[axis]
        copy.sort()
        
        let i = copy.count/2
        if(i%2 == 0) {
            return (copy[i]+copy[i+1])/2
        }
        return copy[i]
    }
    
    /// Returns the standard error of the entire dataset
    func getStandardError() -> Double {
        return getStandardDeviation()/sqrt(Double(data.count))
    }
    
    /// Returns the standard error of the specified axis
    func getStandardError(axis: Int) -> Double {
        return getStandardDeviation(index: axis)/sqrt(Double(getData(axis: axis).count))
    }
}

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}
