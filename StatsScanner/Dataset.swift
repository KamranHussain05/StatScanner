//
//  BasicCalculations.swift
//  StatsScanner
//
//  Created by Kamran on 12/20/21.
//  Updated 12/24/21
//

import Foundation

class Dataset {
    var data: [[Double]] = [[]]
    var keys: [String] = []
    var name: String
    
    //creates a new dataset and assumes the first row contains the keys
    init(appendable: [[String]], name: String) {
        self.name = name
        keys = appendable[0]
        var a = appendable
        a.remove(at: 0)
        self.data = cleanData(array: a)
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
    
}
