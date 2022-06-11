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
    
	var data : [[Double]] = [[]]
    private var keys: [String] = []
	var name: String = "Unnamed Dataset"
	var creationDate: String!
	var calculations : [Double] = Array<Double>(repeating: 0.0, count:8)
	private let db = DataBridge()
	private let h = HomeViewController()
	
// MARK: INIT'S
    
    public func encode(with coder: NSCoder) {
		coder.encode(data, forKey:"data")
		coder.encode(keys, forKey:"keys")
        coder.encode(name, forKey: "name")
        coder.encode(creationDate, forKey: "creationDate")
		coder.encode(calculations, forKey: "calculations")
    }
    
    public required convenience init?(coder decoder: NSCoder) {
        self.init()
        
        data = decoder.decodeObject(forKey: "data") as? [[Double]] ?? [[]]
        name = decoder.decodeObject(forKey: "name") as? String ?? "Unnamed Dataset"
        creationDate = decoder.decodeObject(forKey: "creationDate") as? String ?? ""
        keys = decoder.decodeObject(forKey: "keys") as? [String] ?? []
		calculations = decoder.decodeObject(forKey: "calculations") as? [Double] ?? []
    }
    
    /// Creates a new dataset
    override init() {
        name = "Unnamed DataSet"
		data = [[]]
        // get the current date and time
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
    }
    
    /// Creates a new dataset and assumes the first row contains the keys
    public init(name: String, appendable: [[String]]) {
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
		
		self.calculate()
    }
    
    /// Creates a new dataset object with the specified name
    public init(name: String) {
        self.name = name
		data = [[1]]
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
    }
	
	///Runs all dataset calculations and stores them in the calculation structure for faster loading
	private func calculate() {
		calculations[0] = (self.getMax())
		calculations[1] = (self.getMin())
		calculations[2] = (self.getMedian())
		calculations[3] = (self.getMode())
		calculations[4] = (self.getMax() - self.getMin())
		calculations[5] = (self.getStandardDeviation())
		calculations[6] = (self.getStandardError())
		calculations[7] = (self.getSetAverage())
		print("Re-Did Calculations")
		do {
			try h.context.save()
		} catch {
			fatalError("Core Data Save Failed")
		}
	}
	
	// MARK: GETTERS AND MODIFIERS
	
	///Returns the dataset array without keys
	public func getData() -> [[Double]] {
		return self.data
	}
	
	/// Returns the array containing the data in the specified index
   public func getData(axis:Int) -> [Double] {
	   var result = [Double]()
	   for i in 0...data[0].count-1 {
		   result.append(data[axis][i])
	   }
	   return result
   }
	
	///Returns the Dataset keys/x-axis
	public func getKeys() -> [String]{
		return self.keys
	}
	
	/// Returns the specified dataset key
	func getKey(index: Int) -> String {
		return self.keys[index]
	}
    
    /// Adds a value to the end of the dataset
    func addVal(val:Double) {
        data[data[0].count-1].append(val)
		self.calculate()
    }
    
    /// Changes a specific value
    func updateVal(indexX: Int, indexY: Int, val: Double) {
        data[indexX][indexY] = val
		self.calculate()
    }
    
    /// Adds another dataset or 2D array that does not contain the key row
    func appendArray(array: [[String]]) {
        let cleanArr = cleanData(array: array)
        data.append(contentsOf: cleanArr)
		self.calculate()
    }
	
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
	
//MARK: DATA CLEANING AND PREPROCESSING
		
	/// Writes the data to a csv file and converts the dataset to a CSV string
	func toCSV() {
		var result : Array<Array<String>> = [[]]
		
		for e in data {
			result.append(e.stringArray)
		}
		result.insert(keys, at: 0)
		
		let fileName = self.name.replacingOccurrences(of: " ", with: "") + self.creationDate.replacingOccurrences(of: "/", with: "-") + ".csv"
		db.writeCSV(fileName: fileName, data: result)
	}
    
    /// Cleans the data and inputs it to an array of Doubles
    private func cleanData(array: [[String]]) -> [[Double]] {
		var result : Array<Array<Double>> = [[]]
		
		for e in array {
			result.append(e.doubleArray)
		}
		result.removeFirst()
		result.removeLast()
        return result
    }
	
	///Checks if the dataset is empty
	public func isEmpty() -> Bool {
		return data.isEmpty || keys.isEmpty
	}
    
// MARK: STATISTICS METHODS
    
    /// Returns average of the entire dataset spanning all variables
    private func getSetAverage() -> Double{
        var result = 0.0
        for i in 0...data.count-1 {
            for j in 0...data[0].count-1 {
                result+=data[i][j]
            }
        }
        return result/Double(getTotalNumItems())
    }
    
    /// Returns the average of a specified variable
    private func getAverage(axis:Int) -> Double{
        var result = 0.0
        for i in 0...data[axis].count-1 {
            result += data[i][axis]
        }
        return result/Double(getNumItems(index: axis))
    }
    
    /// Returns the maximum value of the data set
    private func getMax() -> Double {
        var result = [Double]()
        for i in 0...data.count-1 {
			result.append(data[i].max() ?? 0)
        }
        return result.max()!
    }
    
    /// Returns the highest value in the specified index
    private func getMax(index: Int) -> Double {
        return data[index].max()!
        
    }
    
    /// Returns the minimum value in the data
    private func getMin() -> Double {
        var result = [Double]()
        for i in 0...data.count-1 {
			result.append(data[i].min() ?? 0)
        }
        return result.min()!
    }
    
    /// Returns the minimum value in the specified index
    private func getMin(index:Int) -> Double {
        return data[index].min()!
    }
    
    /// Finds the standard deviation of everything in the dataset
    private func getStandardDeviation() -> Double {
        var diffsqrs = 0.0
        for e in data {
            for i in e {
                diffsqrs += pow(i - getSetAverage(), 2)
            }
        }
        return sqrt(diffsqrs - Double(getTotalNumItems()))
    }
    
    /// Finds the standard deviation of the specified axis
    private func getStandardDeviation(index:Int) -> Double {
        var diffsqrs = 0.0
        for e in data[index] {
            diffsqrs += pow(e-getAverage(axis: index), 2)
        }
        return sqrt(diffsqrs - Double(getNumItems(index: index)))
    }
    
    /// Returns the mode(s) of the entire dataset
    private func getModes() -> [Double] {
        var res = [Double]()
        for i in 0...data.count-1 {
            res.append(contentsOf: getModes(arr: data[i]))
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
    private func getMedian(axis: Int) -> Double {
        var copy = data[axis]
        copy.sort()
        
        let i = copy.count/2
        if(i%2 == 0) {
            return (copy[i]+copy[i+1])/2
        }
        return copy[i]
    }
    
    /// Returns the standard error of the entire dataset
    private func getStandardError() -> Double {
        return getStandardDeviation()/sqrt(Double(data.count))
    }
    
    /// Returns the standard error of the specified axis
    private func getStandardError(axis: Int) -> Double {
        return getStandardDeviation(index: axis)/sqrt(Double(data[axis].count))
    }
}

//MARK: EXTENSIONS

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}

extension Collection where Iterator.Element == Double {
	var stringArray : [String] {
		return compactMap{ String($0) }
	}
}

extension Collection where Iterator.Element == String {
	var doubleArray: [Double] {
		return compactMap{ Double($0) }
	}
}


