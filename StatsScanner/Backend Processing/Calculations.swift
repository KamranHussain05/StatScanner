//
//  Calculations.swift
//  StatsScanner
//
//  Created by Caden Pun on 7/22/22.
//

import Foundation

public class Calculations {
    var calculations : [Double] = Array<Double>(repeating: 0.0, count: 9)
    var dataset : [[Double]]
    
    init(dataset: [[Double]]) {
        self.dataset = dataset
    }
    
    public func calculate() -> [Double] {
        calculations[0] = (self.getMax())
        calculations[1] = (self.getMin())
        calculations[2] = (self.getMedian())
        calculations[3] = (self.getMode())
        calculations[4] = (self.getMax() - self.getMin())
        calculations[5] = (self.getStandardDeviation())
        calculations[6] = (self.getStandardError())
        calculations[7] = (self.getSetAverage())
        calculations[8] = (self.getMAD())
        print("Re-Did Calculations")
        /*do {
            try h.context.save()
        } catch {
            fatalError("Core Data Save Failed")
        }*/
        return calculations
    }
    
// MARK: STATISTICS METHODS
    
    /// Returns average of the entire dataset spanning all variables
    private func getSetAverage() -> Double{
        var result = 0.0
        for i in 0...dataset.count-1 {
            for j in 0...dataset[0].count-1 {
                result+=dataset[i][j]
            }
        }
        return result/Double(dataset.count * dataset[0].count)
    }
    
    /// Returns the maximum value of the data set
    private func getMax() -> Double {
        var result = [Double]()
        for i in 0...dataset.count-1 {
            result.append(dataset[i].max() ?? 0)
        }
        return result.max()!
    }
    
    /// Returns the minimum value in the data
    private func getMin() -> Double {
        var result = [Double]()
        for i in 0...dataset.count-1 {
            result.append(dataset[i].min() ?? 0)
        }
        return result.min()!
    }
    
    /// Finds the standard deviation of everything in the dataset
    private func getStandardDeviation() -> Double {
        var diffsqrs = 0.0
        for e in dataset {
            for i in e {
                diffsqrs += pow(i - getSetAverage(), 2)
            }
        }
        return sqrt(diffsqrs / Double(dataset.count * dataset[0].count))
    }
    
    /// Finds the mean absolute deviation of  everything in the dataset
    private func getMAD() -> Double {
        var stuff = 0.0
        for i in dataset {
            for z in i {
                stuff += abs(z - getSetAverage())
            }
        }
        return stuff / Double(dataset.count * dataset[0].count)
    }
    
    /// Returns the mode(s) of the specified axis
    private func getModes(arr: [Double]) -> [Double] {
        var counts: [Double: Double] = [:]
            
        arr.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        if let count = counts.max(by: {$0.value < $1.value})?.value {
             return (counts.compactMap { $0.value == count ? $0.key : nil })
        }
        return []
    }
    
    /// Returns the mode(s) of the entire dataset
    private func getModes() -> [Double] {
        var res = [Double]()
        for i in 0...dataset.count-1 {
            res.append(contentsOf: getModes(arr: dataset[i]))
        }
        return getModes(arr: res)
    }
    
    private func getMode() -> Double {
        return getModes()[0]
    }
    
    /// Returns the median of the entire datasete
    private func getMedian() -> Double {
        var oneD = Array<Double>(repeating: 0.0, count: 0)
        for i in 0...dataset.count-1 {
            for j in 0...dataset[0].count-1 {
                oneD.append(dataset[i][j])
            }
        }
        oneD.sort()
        if (oneD.count % 2 == 0) {
            let first = oneD[oneD.count/2-1]
            let sec = oneD[(oneD.count)/2]
            return (first + sec)/2
        } else {
            return oneD[(oneD.count-1)/2]
        }
    }
    
    /// Returns the median of the specified axis
    private func getMedian(axis: Int) -> Double {
        var copy = dataset[axis]
        copy.sort()
        
        let i = copy.count/2
        if(i%2 == 0) {
            return (copy[i]+copy[i+1])/2
        }
        return copy[i]
    }
    
    /// Returns the standard error of the entire dataset
    private func getStandardError() -> Double {
        return getStandardDeviation()/sqrt(Double(dataset.count*dataset[0].count))
    }
}
