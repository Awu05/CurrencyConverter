//
//  DataAccessObject.swift
//  CurrencyConverter
//
//  Created by Andy Wu on 2/16/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import Foundation
import CoreData



class DataAccessObject {
    static let sharedManager = DataAccessObject()
    
    var managedObjectContext: NSManagedObjectContext
    
    var currencyArray = [TrackedCurrency]()
    
    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        DispatchQueue.global(qos: .userInitiated).async  {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
             This code uses a file named "DataModel.sqlite" in the application's documents directory.
             */
            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
        
    }
    
    
    func saveData() {
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func addTrackedCurrency(frmCurrency:String, toCurrency:String, currRate:Double, tarRate:Double) {
        
        let currency : TrackedCurrency = NSEntityDescription.insertNewObject(forEntityName: "TrackedCurrency", into: managedObjectContext) as! TrackedCurrency
        currency.currentRate = currRate
        currency.fromCurrency = frmCurrency
        currency.toCurrency = toCurrency
        currency.targetRate = tarRate
        
        currencyArray.append(currency)
        
        saveData()
    }
    
    func deleteTrackedCurrency(trackedCurrencyIndex:Int) {
        self.managedObjectContext .delete(currencyArray[trackedCurrencyIndex])
        currencyArray.remove(at: trackedCurrencyIndex)
        saveData()
    }
    
    func loadData() {
        let moc = managedObjectContext
        let loadCurrency = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackedCurrency")
        
        do {
            let fetchedCurrency = try moc.fetch(loadCurrency) as! [TrackedCurrency]
            currencyArray = fetchedCurrency
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    
}
