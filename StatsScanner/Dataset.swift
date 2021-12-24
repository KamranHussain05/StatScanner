//
//  BasicCalculations.swift
//  StatsScanner
//
//  Created by Kamran on 12/20/21.
//

import Foundation

class Dataset {
    var data: [[Double]] = [[]]
    
    func addVal(index_X: Int, index_Y: Int, val:Double){
        data[index_X][index_Y] = val
    }
    
}
