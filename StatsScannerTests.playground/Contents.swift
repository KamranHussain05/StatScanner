//: A UIKit based Playground for presenting user interface
  
print("Reading CSV file")
print(readCSV(inputFile: "Awards_R.csv", separator: ","))
print("CSV read, importing to dataset")


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
    print(fileExtension)
    print(fileName)
    
    let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
    
    let inputFile = fileURL?.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    
    print(inputFile ?? "none")
    
    //Get Data
    do {
        let savedData = try String(contentsOf: inputFile!)
        return savedData.components(separatedBy: separator)
    } catch {
        return ["ERROR: File Could Not be Found"]
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

//func importData(arr: [String]) {
//    let d = Dataset()
//    for i in 0...arr.count {
//        for j in 0...arr[0].count {
//            if(Character(arr[i]).isNumber) {
//                let value = Double(arr[i]) ?? 0
//                d.addVal(index_X: i, index_Y: j, val: value)
//            }
//        }
//    }
//}

class Dataset {
    var data: [[Double]] = [[]]
    
    func addVal(index_X: Int, index_Y: Int, val:Double){
        data[index_X][index_Y] = val
    }
}

