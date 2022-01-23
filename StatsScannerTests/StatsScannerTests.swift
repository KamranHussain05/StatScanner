//
//  StatsScannerTests.swift
//  StatsScannerTests
//
//  Created by Kamran on 11/20/21.
//

import XCTest
@testable import StatsScanner

class StatsScannerTests: XCTestCase {
    
    let d = Dataset()
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
    
    func testWriting() throws {
        print("testing")
        
        b.writeData(data: "test string", fileName: "test.csv")
    }
    
    func testRegWriting() throws {
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
        print(b.readCSV(fileName: "test.csv", lineSeparator: "\n", valSeparator: ","))
    }
    
//    func testCSVAppending() throws {
//        print("=== Test Case 1 ===")
//        var url = URL(fileURLWithPath: "/Users/kamranhussain/Desktop/Programming/StatsScanner/StatsScanner/Resources/Awards_R.csv")
//        print(b.readCSV(inputFile: url, lineSeparator: "\r", valSeparator: ","))
//
//        print("=== Test Case 2 ===")
//        url = URL(fileURLWithPath: "/Users/kamranhussain/Desktop/Programming/StatsScanner/StatsScanner/Resources/Awards_R.csv")
//        print(b.readCSV(inputFile: url, lineSeparator: "\r", valSeparator: ","))
//
//        print("=== Test Case 3 ===")
//        url = URL(fileURLWithPath: "/Users/kamranhussain/Desktop/Programming/StatsScanner/StatsScanner/Resources/Awards_R.csv")
//        print(b.readCSV(inputFile: url, lineSeparator: "\r", valSeparator: ","))
//    }
//
//    func testCSVWriting() throws {
//        print("Starting to write")
//        let url = URL(fileURLWithPath: "/Users/kamranhussain/Desktop/Programming/StatsScanner/StatsScanner/Resources/Awards_R.csv")
//        let data = b.readCSV(inputFile: url, lineSeparator: "\n", valSeparator: ",")
//
//        print("writing to csv")
//        print(data)
//        b.writeCSV(fileName: "testingAwards.csv", data: data)
//
//        print("reading for validation")
//        let url2 = b.getDocumentsDirectory().appendingPathComponent("testingAwards.csv")
//        print(b.readCSV(inputFile: url2, lineSeparator: "\n", valSeparator: ","))
//    }
    
    func testDatasetPathway() throws {
       // let h = HomeViewController()
        let arr = [["val 1", "val 2", "val 3"],
                   ["13", "12", "15"],
                   ["15", "18", "32"],
                   ["23", "20", "32"]]
        print(arr.count)
        print(arr[0].count)
        let d = Dataset(name: "Testing Set", appendable: arr)
    }

}
