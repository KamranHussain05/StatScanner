//
//  Calculations.swift
//  StatsScanner
//
//  Created by Caden Pun on 7/22/22.
//

import Foundation

public class Calculations {
    var calculations : [Double] = Array<Double>(repeating: 0.0, count: 9)
   
    var dataset : [Double]
    
    init(dataset: [Double]) {
        self.dataset = dataset
    }
    
    public func calculate() -> [Double] {
        calculations[0] = (self.getSetAverage())
        calculations[1] = (self.getMedian())
        calculations[2] = (self.getMode())
        calculations[3] = (self.getMin())
        calculations[4] = (self.getMax())
        calculations[5] = (self.getMax() - self.getMin())
        calculations[6] = (self.getStandardDeviation())
        calculations[7] = (self.getMAD())
        calculations[8] = (self.getStandardError())
        print("Re-Did Calculations")
        
        return calculations
    }
    
// MARK: STATISTICS METHODS
    
    /// Returns average of the entire dataset spanning all variables
    private func getSetAverage() -> Double{
        var result = 0.0
        for i in 0...dataset.count-1 {
            result+=dataset[i]
        }
        return result/Double(dataset.count)
    }
    
    /// Returns the maximum value of the data set
    private func getMax() -> Double {
        return self.dataset.max()!
    }
    
    /// Returns the minimum value in the data
    private func getMin() -> Double {
        return self.dataset.min()!
    }
    
    /// Finds the standard deviation of everything in the dataset
    private func getStandardDeviation() -> Double {
        var diffsqrs = 0.0
        for e in dataset {
                diffsqrs += pow(e - getSetAverage(), 2)
        }
        return sqrt(diffsqrs / Double(dataset.count))
    }
    
    /// Finds the mean absolute deviation of  everything in the dataset
    private func getMAD() -> Double {
        var sum = 0.0
        for e in dataset {
            sum += abs(e - getSetAverage())
        }
        return sum / Double(dataset.count)
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
    
    private func getMode() -> Double {
        return getModes(arr: self.dataset)[0]
    }
    
    /// Returns the median of the entire datasete
    private func getMedian() -> Double {
        var oneD = dataset
        oneD.sort()
        if (oneD.count % 2 == 0) {
            let first = oneD[oneD.count/2-1]
            let sec = oneD[(oneD.count)/2]
            return (first + sec)/2
        } else {
            return oneD[(oneD.count-1)/2]
        }
    }
    
    /// Returns the standard error of the entire dataset
    private func getStandardError() -> Double {
        return getStandardDeviation()/sqrt(Double(dataset.count))
    }
}
