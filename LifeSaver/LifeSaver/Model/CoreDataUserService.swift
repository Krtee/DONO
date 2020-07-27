//
//  CoreDataUserService.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 27.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import CoreData

class CoreDataUserService{
    //MARK: - Singleton Pattern
    static let defaults = CoreDataUserService() //Klassenvariable
    
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
    
    //MARK: - CRUD - Create/Read/Update/Delete
    
    //MARK: - Create Information
    func createUser(_email: String, _password: String) -> User {
        let user = User(context: context)
        
        user.email=_email
        user.password=_password
        user.userID=_email

        saveContext()
        
        return user
    }
    
    
    //MARK: - ReadfromId
    func loadfromID(id: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest() //Nur die Anfrage
        let userpredicate = NSPredicate(format: " userID == %@", id)
        fetchRequest.predicate = userpredicate
        
        do {
            let resultArray = try context.fetch(fetchRequest)
            for r in resultArray {
                return r
            }
        } catch {
            print("Fehler beim Laden der Daten ", error.localizedDescription)
        }
        return nil

    }
    
}
