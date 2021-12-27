//
//  StatsScannerTests.swift
//  StatsScannerTests
//
//  Created by Kamran on 11/20/21.
//

import XCTest
@testable import StatsScanner
import CoreData

class StatsScannerTests: XCTestCase {
    
    let d = DataSet()
    let b = DataBridge()
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("==== STARTING TEST ====")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testData() throws {
        print("testing")
        
        b.writeData(data: "test string")
    }
    
    func testWriting() throws {
        let str =
        """
        id,num_awards,prog,math
        45,1,3,41
        108,1,1,41
        15,1,3,44
        67,1,3,42
        """
        let url = b.getDocumentsDirectory().appendingPathComponent("test.csv")
        
        do {
            try str.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testReading() throws {
        let url = b.getDocumentsDirectory().appendingPathComponent("test.csv")
        print(b.readCSV(inputFile: url, lineSeparator: "\n", valSeparator: ","))
    }
    
    func testDataSet() throws {
        print("=== Test Case 1 ===")
        var url = URL(fileURLWithPath: "/Users/kamran/Desktop/Programming/StatsScanner/StatsScanner/Resources/Awards_R.csv")
        print(b.readCSV(inputFile: url, lineSeparator: "\r", valSeparator: ","))
        
        print("=== Test Case 2 ===")
        url = URL(fileURLWithPath: "/Users/kamran/Desktop/Programming/StatsScanner/StatsScanner/Resources/Video_R.csv")
        print(b.readCSV(inputFile: url, lineSeparator: "\r", valSeparator: ","))
        
        print("=== Test Case 3 ===")
        url = URL(fileURLWithPath: "/Users/kamran/Desktop/Programming/StatsScanner/StatsScanner/Resources/Diet_R.csv")
        print(b.readCSV(inputFile: url, lineSeparator: "\r", valSeparator: ","))
    }

}
