//
//  BasicCalculations.swift
//  StatsScanner
//
//  Created by Kamran on 12/20/21.
//  Updated 12/24/21
//

import Foundation
import CoreData

class Dataset {
    var data: [[Double]] = [[]]
    var keys: [String] = []
    var name: String
    var creationDate: String
    
    //creates a new dataset
    init() {
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
        self.name = name
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
        
        keys = appendable[0]
        var a = appendable
        a.remove(at: 0)
        self.data = cleanData(array: a)
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
    
    func getData(axis:Int) -> [Double] {
        var result = [Double]()
        for i in 0...data[0].count-1 {
            result.append(data[axis][i])
        }
        return result
    }
    
    //returns the given name of the dataset
    func getName() -> String {
        return self.name
    }
    
    //returns the array containing the extracted keys from the dataset
    func getKeys() -> [String] {
        return self.keys
    }
    
    //returns the specified dataset key
    func getKey(index: Int) -> String {
        return self.keys[index]
    }
    
    //add a value to the end of the dataset
    func addVal(val:Double) {
        data[data[0].count-1].append(val)
    }
    
    //changes a specific value
    func changeVal(indexX: Int, indexY: Int, val: Double) {
        data[indexX][indexY] = val
    }
    
    //Add another dataset or 2D array that does not contain the key row
    func appendArray(array: [[String]]) {
        let cleanArr = cleanData(array: array)
        for i in 0...cleanArr.count-1 {
            data[data.count-1 + i].append(contentsOf: cleanArr[i])
        }
    }
    
    //cleans the data and inputs it to an array of Doubles
    private func cleanData(array: [[String]]) -> [[Double]] {
        var result: [[Double]] = []
        for i in 0...array.count{
            for j in 0...array[i].count {
                if(array[i][j].isNumber){
                    result[i][j] = Double(array[i][j])!
                }
            }
        }
        return result
    }
    
//===================================
//==    Methods for Statistics     ==
//==                               ==
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
    func getDataStandardDeviation() -> Double {
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
    
    //returns the standard deviation of the entire dataset
    func getStandardDeviation() -> Double {
        var diffsqrs = 0.0
        for e in data {
            for i in 0...e.count-1{
                diffsqrs += pow(e[i]-getSetAverage(), 2)
            }
        }
        return sqrt(diffsqrs - Double(getTotalNumItems()))
    }
    
    //returns the mode of the entire dataset
    func getMode() -> Double {
        return 0
    }
    
    //returns the median of the entire dataset
    func getMedian() -> Double {
        return 0
    }
    
    //returns the standard error of the entire dataset
    func getStandardError() -> Double {
        return 0
    }
}
