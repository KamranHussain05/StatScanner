//
//  BasicCalculations.swift
//  StatsScanner
//
//  Created by Kamran on 12/20/21.
//

import Foundation

class Dataset {
    var data: [Double] = []
    
    func addVal(val:Double){
        data.append(val)
    }
    
    func changeVal(index: Int, val:Double) {
        data[index] = val
    }
    
    func removeVal(index: Int){
        data.remove(at: index)
    }
    
    func removeInstances(val:Double) {
        data.removeAll() { value in
            return value == val
        }
    }
    
    func getArr() -> [Double] {
        return self.data
    }
    
    func getLength() -> Int{
        return data.count
    }

    func hasVal(val:Double) -> Bool {
        return data.contains(val)
    }
    
    func getTotal() -> Double{
        var total: Double = 0
        for val in data{
            total += val
        }
        return total
    }
    
    func getAverage() -> Double {
        var total = 0.0
        total = getTotal() / Double(data.count)
        return total
    }
    
    
    
}
