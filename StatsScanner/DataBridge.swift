//
//  DataImporter.swift
//  StatsScanner
//
//  Created by Kamran on 12/27/21.
//

import Foundation

class DataBridge {
    func writeData(data:String) {
        let str = data
        let url = getDocumentsDirectory().appendingPathComponent("message.txt")
        
        do {
            try str.write(to: url, atomically: true, encoding: .utf8)
            
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
