//
//  DatasetBuilder.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 6/9/22.
//

import Foundation
import UIKit

class DatasetBuilder {
    var dataset : Dataset!
    var name : String
    var icon: UIImage
    
    init() {
        name = "New Dataset"
        icon = UIImage(named: "DataSetIcon1")!
    }
    
    public func reset() {
        dataset = nil
        name = "New Dataset"
        icon = UIImage(named: "DataSetIcon1")!
    }
}
