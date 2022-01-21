//
//  DataSetProject+CoreDataProperties.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/21/22.
//
//

import Foundation
import CoreData

extension DataSetProject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataSetProject> {
        return NSFetchRequest<DataSetProject>(entityName: "DataSetProject")
    }

    @NSManaged public var datasetobject: Dataset?

}

extension DataSetProject : Identifiable {

}
