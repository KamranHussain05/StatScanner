//
//  BasicCalculations.swift
//  StatsScanner
//
//  Created by Kamran on 12/20/21.
//  Updated 12/24/21
//

import Foundation
import CoreData

@objc(Dataset)
public class Dataset: NSObject, NSCoding {
    
    public func encode(with coder: NSCoder) {
        
    }
    
    public required init?(coder: NSCoder) {
        
    }
    
    
    var data: [[Double]] = [[]]
    var keys: [String] = []
    var xvals: [String] = []
    var name: String = "Unnamed Dataset"
    var creationDate: String!
    let db = DataBridge()
    
    //creates a new dataset
    override init() {
        name = "Unnamed DataSet"
        // get the current date and time
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
    }
    
    //creates a new dataset and assumes the first row contains the keys
    init(name: String, appendable: [[String]]) {
        super.init()
        self.name = name
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
        
//        for i in 1...data.count {
//            self.xvals.append(appendable[0][i])
//        }
        
        keys = appendable[0]
        var a = appendable
        a.remove(at: 0)
        self.data = self.cleanData(array: a)
    }
    
    //creates a new dataset object with the specified name
    init(name: String) {
        self.name = name
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
    }
    
    //returns the data 2d array containg the double values of the data
    func getData() -> [[Double]] {
        return self.data
    }
    
    //returns the array containing the data in the specified index
    func getData(axis:Int) -> [Double] {
        var result = [Double]()
        for i in 0...data[0].count-1 {
            result.append(data[axis][i])
        }
        return result
    }
    
    //writes the csv files and imports it
    func toCSV(file:URL) {
        var result = [[String]]()
        result[0] = self.keys
        for i in 0...data.count-1{
            for j in 0...data[i].count-1 {
                result[i-1][j] = String(data[i][j])
            }
        }
        
        let fileName = self.name.replacingOccurrences(of: " ", with: "")
        db.writeCSV(fileName: fileName, data: result)
    }
    
    //returns the array containing the extracted keys from the dataset
    func getKeys() -> [String] {
        return self.keys
    }
    
    //returns the specified dataset key
    func getKey(index: Int) -> String {
        return self.keys[index]
    }
    
    //adds a value to the end of the dataset
    func addVal(val:Double) {
        data[data[0].count-1].append(val)
    }
    
    //changes a specific value
    func changeVal(indexX: Int, indexY: Int, val: Double) {
        data[indexX][indexY] = val
    }
    
    //Adds another dataset or 2D array that does not contain the key row
    func appendArray(array: [[String]]) {
        let cleanArr = cleanData(array: array)
        for i in 0...cleanArr.count-1 {
            data[data.count-1 + i].append(contentsOf: cleanArr[i])
        }
    }
    
    //cleans the data and inputs it to an array of Doubles
    private func cleanData(array: [[String]]) -> [[Double]] {
        var result = [[Double]]()
        for x in 0...array[0].count-1 {
            for y in 0...array.count-1 {
                if(array[x][y].isNumber) {
                    print(result)
                    result[x][y] = Double(array[x][y])!
                }
            }
        }
        return result
    }
    
//===================================
//==    Methods for Statistics     ==
//===================================
    
    //returns the number of items in the dataset
    func getTotalNumItems() -> Int {
        var count = 0
        for i in 0...data.count-1 {
            count+=data[i].count
        }
        return count
    }
    
    //returns the number of items in the specified variable
    func getNumItems(index:Int) -> Int {
        return data[index].count
    }
    
    //returns average of the entire dataset spanning all variables
    func getSetAverage() -> Double{
        var result = 0.0
        for i in 0...data.count-1 {
            for j in 0...data[0].count-1 {
                result+=data[i][j]
            }
        }
        return result/Double(getTotalNumItems())
    }
    
    //returns the average of a specified variable
    func getAverage(axis:Int) -> Double{
        var result = 0.0
        for i in 0...data[axis].count-1 {
            result += data[i][axis]
        }
        return result/Double(getNumItems(index: axis))
    }
    
    //returns the maximum value of the data set
    func getMax() -> Double {
        var result = [Double]()
        for i in 0...data.count {
            result.append(data[i].max()!)
        }
        return result.max()!
    }
    
    //returns the highest value in the specified index
    func getMax(index: Int) -> Double {
        return data[index].max()!
        
    }
    
    //returns the minimum value in the data
    func getMin() -> Double {
        var result = [Double]()
        for i in 0...data.count {
            result.append(data[i].min()!)
        }
        return result.min()!
    }
    
    //returns the minimum value in the specified index
    func getMin(index:Int) -> Double {
        return data[index].min()!
    }
    
    //finds the standard deviation of everything in the dataset
    func getStandardDeviation() -> Double {
        var diffsqrs = 0.0
        for e in data {
            for i in e {
                diffsqrs += pow(i - getSetAverage(), 2)
            }
        }
        return sqrt(diffsqrs - Double(getTotalNumItems()))
    }
    
    //finds the standard deviation of the specified axis
    func getStandardDeviation(index:Int) -> Double {
        var diffsqrs = 0.0
        for e in data[index] {
            diffsqrs += pow(e-getAverage(axis: index), 2)
        }
        return sqrt(diffsqrs - Double(getNumItems(index: index)))
    }
    
    //returns the mode(s) of the entire dataset
    func getModes() -> [Double] {
        var res = [Double]()
        for i in 0...data.count{
            res.append(contentsOf: getModes(arr: data[i]))
        }
        return getModes(arr: res)
    }
    
    //returns the mode(s) of the specified axis
    func getModes(arr: [Double]) -> [Double] {
        var counts: [Double: Double] = [:]
            
        arr.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        if let count = counts.max(by: {$0.value < $1.value})?.value {
             return (counts.compactMap { $0.value == count ? $0.key : nil })
        }
        return []
    }
    
    //returns the median of the entire datasete
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
    
    //returns the median of the specified axis
    func getMedian(axis: Int) -> Double {
        var copy = data[axis]
        copy.sort()
        
        let i = copy.count/2
        if(i%2 == 0) {
            return (copy[i]+copy[i+1])/2
        }
        return copy[i]
    }
    
    //returns the standard error of the entire dataset
    func getStandardError() -> Double {
        return getStandardDeviation()/sqrt(Double(data.count))
    }
    
    //returns the standard error of the specified axis
    func getStandardError(axis: Int) -> Double {
        return getStandardDeviation(index: axis)/sqrt(Double(getData(axis: axis).count))
    }
}
