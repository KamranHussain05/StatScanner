//
//  Dataset.swift
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
	private var numericalData : [[Double]] = [[]]
	var calculations : [Double]
	private let db = DataBridge()
	private let h = HomeViewController()
	
// MARK: INIT'S
    
    public func encode(with coder: NSCoder) {
		coder.encode(data, forKey:"data")
		coder.encode(keys, forKey:"keys")
        coder.encode(name, forKey: "name")
        coder.encode(creationDate, forKey: "creationDate")
		//coder.encode(calculations, forKey: "calculations")
		calculations = Calculations(dataset: numericalData).calculate()
    }
    
    public required convenience init?(coder decoder: NSCoder) {
        self.init()
        data = decoder.decodeObject(forKey: "data") as? [[Double]] ?? [[]]
        name = decoder.decodeObject(forKey: "name") as? String ?? "Unnamed Dataset"
        creationDate = decoder.decodeObject(forKey: "creationDate") as? String ?? ""
        keys = decoder.decodeObject(forKey: "keys") as? [String] ?? []
		//calculations = decoder.decodeObject(forKey: "calculations") as? [Double] ?? []
		calculations = Calculations(dataset: numericalData).calculate()
    }
    
    /// Creates a new dataset
    override init() {
		//print(calculations.count)
        name = "Unnamed DataSet"
		data = [[]]
        // get the current date and time
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        creationDate = formatter.string(from: currentDateTime)
		calculations = Calculations(dataset: numericalData).calculate()
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
		
		calculations = Calculations(dataset: numericalData).calculate()
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
		calculations = Calculations(dataset: numericalData).calculate()
    }
	
	// MARK: GETTERS AND MODIFIERS
	
	///Returns the dataset array without keys
	public func getData() -> [[Double]] {
		if(self.isEmpty()) {
			return [[0]]
		}
		return self.data
	}
	
	/// Returns the array containing the data in the specified index
   public func getData(axis:Int) -> [Double] {
	   if(self.isEmpty()) {
		   return [0]
	   }
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
		calculations = Calculations(dataset: numericalData).calculate()
    }
    
    /// Changes a specific value
    func updateVal(indexX: Int, indexY: Int, val: Double) {
        data[indexX][indexY] = val
		calculations = Calculations(dataset: numericalData).calculate()
    }
	
	func updateHeader(index: Int, val: String) {
		keys[index] = val
		calculations = Calculations(dataset: numericalData).calculate()
	}
    
    /// Adds another dataset or 2D array that does not contain the key row
    func appendArray(array: [[String]]) {
        let cleanArr = cleanData(array: array)
        data.append(contentsOf: cleanArr)
		calculations = Calculations(dataset: numericalData).calculate()
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
		if (self.isEmpty()) {
			return
		}
		var result : Array<Array<String>> = [[]]
		result.append(keys)
		
		for e in data {
			result.append(e.stringArray)
		}
		print(result)
		
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



