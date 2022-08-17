//
//  DatasetBuilder.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 6/9/22.
//

import Foundation

class DatasetBuilder {
    var dataset : Dataset!
    var name : String
    
    init() {
        name = "New Dataset"
    }
    
    public func reset() {
        dataset = nil
        name = "New Dataset"
    }
}
