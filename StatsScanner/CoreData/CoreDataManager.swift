//
//  CoreDataManager.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 1/21/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    private init() {
        
        ValueTransformer.setValueTransformer(NSDatasetTransformer(), forName: NSValueTransformerName("NSDatasetTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "DataSetProject")
        persistentContainer.loadPersistentStores { descriptionn, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
}

