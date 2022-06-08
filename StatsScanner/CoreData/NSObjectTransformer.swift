//
//  NSObjectTransformer.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/22/22.
//

import Foundation
import UIKit
import ObjectiveC

class NSDatasetTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let ds = value as? Dataset else {return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: ds, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {return nil }
        
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: Dataset.self, from: data)
            return color
        } catch {
            return nil
        }
    }
}


