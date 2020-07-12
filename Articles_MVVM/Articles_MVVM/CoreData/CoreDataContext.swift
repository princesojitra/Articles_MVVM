//
//  CoreDataContext.swift
//  MVVM Archiecture
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//

import Foundation
import CoreData

class CoreDataContext {
    static let datamodelName = "UserArticles"
    static let storeType = "sqlite"

    static let persistentContainer = NSPersistentContainer(name: datamodelName)
   
    private static let url: URL = {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("\(datamodelName).\(storeType)")

        assert(FileManager.default.fileExists(atPath: url.path))
        print("Persistant Store:", url)
        return url
    }()

    static func loadStores() {
        persistentContainer.loadPersistentStores(completionHandler: { (nsPersistentStoreDescription, error) in
            guard let error = error else {
                return
            }
            fatalError(error.localizedDescription)
        })
    }

    static func deleteAndRebuild() {
        try! persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: storeType, options: nil)

        loadStores()
    }
    
    static func saveContext() {
        if self.persistentContainer.viewContext.hasChanges {
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
