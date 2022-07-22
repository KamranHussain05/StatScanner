//
//  Calculations.swift
//  StatsScanner
//
//  Created by Caden Pun on 7/22/22.
//

import Foundation

public class Calculations {
    var calculations : [Double] = Array<Double>(repeating: 0.0, count: 9)
    var dataset : Dataset!
    
    init(dataset: Dataset) {
        self.dataset = dataset
    }
    
    func calculate() {
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
    }
    
// MARK: STATISTICS METHODS
    
    /// Returns average of the entire dataset spanning all variables
    private func getSetAverage() -> Double{
        var result = 0.0
        for i in 0...dataset.getData().count-1 {
            for j in 0...dataset.getData()[0].count-1 {
                result+=dataset.getData()[i][j]
            }
        }
        return result/Double(dataset.getTotalNumItems())
    }
    
    /// Returns the average of a specified variable
    private func getAverage(axis:Int) -> Double{
        var result = 0.0
        for i in 0...dataset.getData()[axis].count-1 {
            result += dataset.getData()[i][axis]
        }
        return result/Double(dataset.getNumItems(index: axis))
    }
    
    /// Returns the maximum value of the data set
    private func getMax() -> Double {
        var result = [Double]()
        for i in 0...dataset.getData().count-1 {
            result.append(dataset.getData()[i].max() ?? 0)
        }
        return result.max()!
    }
    
    /// Returns the highest value in the specified index
    private func getMax(index: Int) -> Double {
        return dataset.getData()[index].max()!
        
    }
    
    /// Returns the minimum value in the data
    private func getMin() -> Double {
        var result = [Double]()
        for i in 0...dataset.getData().count-1 {
            result.append(dataset.getData()[i].min() ?? 0)
        }
        return result.min()!
    }
    
    /// Returns the minimum value in the specified index
    private func getMin(index:Int) -> Double {
        return dataset.getData()[index].min()!
    }
    
    /// Finds the standard deviation of everything in the dataset
    private func getStandardDeviation() -> Double {
        var diffsqrs = 0.0
        for e in dataset.getData() {
            for i in e {
                diffsqrs += pow(i - getSetAverage(), 2)
            }
        }
        return sqrt(diffsqrs / Double(dataset.getTotalNumItems()))
    }
    
    /// Finds the standard deviation of the specified axis
    private func getStandardDeviation(index:Int) -> Double {
        var diffsqrs = 0.0
        for e in dataset.getData()[index] {
            diffsqrs += pow(e-getAverage(axis: index), 2)
        }
        return sqrt(diffsqrs / Double(dataset.getNumItems(index: index)))
    }
    
    /// Finds the mean absolute deviation of  everything in the dataset
    private func getMAD() -> Double {
        var stuff = 0.0
        for i in dataset.getData() {
            for z in i {
                stuff += abs(z - getSetAverage())
            }
        }
        return stuff / Double(dataset.getTotalNumItems())
    }
    
    /// Returns the mode(s) of the entire dataset
    private func getModes() -> [Double] {
        var res = [Double]()
        for i in 0...dataset.getData().count-1 {
            res.append(contentsOf: getModes(arr: dataset.getData()[i]))
        }
        return getModes(arr: res)
    }
    
    private func getMode() -> Double {
        return getModes()[0]
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
    
    /// Returns the median of the entire datasete
    private func getMedian() -> Double {
        var copy = dataset.getData()
        for i in 0...copy.count-1 {
            copy[i].sort()
        }
        let y = copy.count/2 - 1
        let x = copy[y].count/2
        print(x)
        print(y)
        if(y%2 == 0) {
            return (copy[y][copy[x].count-1] + copy[y+1][0]) / 2
        }
        if(x%2 == 0) {
            return (copy[y][x+1] + copy[y][x]) / 2
        }
        
        return copy[x][y]
    }
    
    /// Returns the median of the specified axis
    private func getMedian(axis: Int) -> Double {
        var copy = dataset.getData()[axis]
        copy.sort()
        
        let i = copy.count/2
        if(i%2 == 0) {
            return (copy[i]+copy[i+1])/2
        }
        return copy[i]
    }
    
    /// Returns the standard error of the entire dataset
    private func getStandardError() -> Double {
        return getStandardDeviation()/sqrt(Double(dataset.getData().count))
    }
    
    /// Returns the standard error of the specified axis
    private func getStandardError(axis: Int) -> Double {
        return getStandardDeviation(index: axis)/sqrt(Double(dataset.getData()[axis].count))
    }
}
