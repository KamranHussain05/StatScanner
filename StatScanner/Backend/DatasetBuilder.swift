//
//  DatasetBuilder.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 6/9/22.
//

import Foundation
import UIKit

/// Assistant class that captures and creates a copy of the new dataset while its in memory (or being imported) to build into a proper dataset. This class is essential for building new datasets without clogging memory. Objects of this class should be used globally to ensure the CoreData saving pipelines, home view loading, and info view loading properly work. Notification Center also uses this class to share datasets between different runtime objects.
///
/// - Parameters:
///     - dataset: A Dataset object either default or filled that should be built.
///     - name:
class DatasetBuilder {
    var dataset : Dataset!
    var name : String
    var icon: UIImage
    
    init() {
        name = "New Dataset"
        icon = UIImage(named: "DataSetIcon1")!
    }
    
    /// Function that resets the dataset being built. The name is set to the default name string, icon is set to the first default icon, and the dataset object is deleted from memory with its reference removed.
    ///
    /// - Note: This is the default abort action when a dataset creation is aborted.
    /// - Warning: This cannot be reversed or undone, permanence should be made clear to the user where this function is called.
    public func reset() {
        dataset = nil
        name = "New Dataset"
        icon = UIImage(named: "DataSetIcon1")!
    }
}
