//
//  DataImporting.swift
//  StatsScanner
//
//  Created by Kamran on 12/22/21.
//


import Foundation

extension String {
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
func readCSV(inputFile: String, separator: String) -> [String] {
    let fileExtension = inputFile.fileExtension()
    let fileName = inputFile.fileName()
    
    let fileURL = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    let inputFile = fileURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    
    //Get Data
    do {
        let savedData = try String(contentsOf: inputFile)
        return savedData.components(separatedBy: separator)
        
    } catch {
        return ["ERROR: File Could Not be Found"]
    }
}

func cleanData(arr: [String]) -> [[Double]] {
    var data: [[Double]] = [[]]
    
    let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var x = arr.removeAll(where: { nums.contains($0)} )
    return data
}

func importData(arr: [String]) {
    let d = Dataset()
    for i in 0...arr.count {
        for j in 0...arr[0].count {
            d.addVal(index_X: i, index_Y: j, val: Double(arr[i][j]))
        }
    }
                
}

var myData = readCSV(inputFile: "Awards_R.csv", separator: ",")
var x = printItems()

func printItems() {
    print(myData)
    print(myData[0])
}
