//
//  CoreDataService.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 14.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    //MARK: - Singleton Pattern
    static let defaults = CoreDataService() //Klassenvariable
    
    //MARK: - Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: - Privater Init für Singleton
    private init() {}
    
    
    //MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LifeSaver")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //MARK: - CRUD - Create/Read/(Update)/(Delete)
    
    //Create Information
    func createHospital(_hospitalID: String, _name: String, _longitude: Double, _latitude: Double, _street: String, _postCode: Int64) -> Hospitals {
        let hospitals = Hospitals(context: context)
        hospitals.hospitalID = _hospitalID
        hospitals.name = _name
        hospitals.longitude = _longitude
        hospitals.latitude = _latitude
        hospitals.street = _street
        hospitals.postCode = _postCode
        
        saveContext()
        
        return hospitals
    }
    
    //Read
    func loadData() -> [Hospitals]? {
        let fetchRequest: NSFetchRequest<Hospitals> = Hospitals.fetchRequest() //Nur die Anfrage
        
        do {
            let resultArray = try context.fetch(fetchRequest)
            return resultArray
        } catch {
            print("Fehler beim Laden der Daten ", error.localizedDescription)
        }
        return nil
    }
}
