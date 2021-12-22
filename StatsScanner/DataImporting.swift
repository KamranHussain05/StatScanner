//
//  DataImporting.swift
//  StatsScanner
//
//  Created by Kamran on 12/22/21.
//

func readCSV(file:String) -> Array<String> {
    do {
        let content = try String(contentsOfFile: file)
        let parsedCSV: [String] = content.components(
            separatedBy: "\n"
        ).map{ $0.components(separatedBy: ",")[0] }
        return parsedCSV
    }
    catch {
        return []
    }
}

func main() {
    print("starting run")
    print(readCSV(file: "SampleData/Awards_R.csv"))
}

