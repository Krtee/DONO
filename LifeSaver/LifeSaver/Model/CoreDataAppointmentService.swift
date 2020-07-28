//
//  CoreDataAppointmentService.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 27.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import CoreData

class CoreDataAppointmentService{
    //MARK: - Singleton Pattern
    static let defaults = CoreDataAppointmentService() //Klassenvariable
    
    //MARK: - Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let formatter = DateFormatter()
    // initially set the format based on your datepicker date / server String
    
    //MARK: - Privater Init für Singleton
    private init() {
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    
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
    func createAppointment(hospitalID: String, userID: String,donatetype: String, appointmentDate: Date) -> Appointment? {
        print("i am here")
        let appointment = Appointment(context: context)
                    
            let fetchedHospital: Hospitals? = CoreDataService.defaults.loadfromID(id: hospitalID,context: context)
            let fetchedUser: User? = CoreDataUserService.defaults.loadfromID(id: userID,context: context)
             
            if fetchedHospital != nil && fetchedUser != nil {
                
                appointment.donateType = donatetype
                appointment.hospital = fetchedHospital
                appointment.date = appointmentDate
                appointment.appointmentID = "\(formatter.string(from: appointmentDate)) \(String(describing: fetchedUser?.userID))"
                
                fetchedUser?.addToAppointments(appointment)
            } else {
                return appointment
            }
            
            saveContext()
            return appointment

        
    }
    
    //MARK: - Read
    func loadData(userID: String) -> [Appointment]? {

        let fetchedUser: User? = CoreDataUserService.defaults.loadfromID(id: userID,context: context)
        if fetchedUser != nil {
            return fetchedUser?.appointments?.allObjects as? [Appointment]
        }
        return nil
    }
    
    //MARK: - ReadfromId
    func loadfromID(id: String) -> Appointment? {
        let fetchRequest: NSFetchRequest<Appointment> = Appointment.fetchRequest() //Nur die Anfrage
        let userpredicate = NSPredicate(format: " appointmentID == %@", id)
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
    
    //MARK: - ReadlastObject
    func loadlastAppointment(userID: String) -> Appointment? {
        let fetchedUser: User? = CoreDataUserService.defaults.loadfromID(id: userID,context: context)
        if fetchedUser != nil {
            
            let allappointments = fetchedUser?.appointments?.allObjects as? [Appointment]
            return allappointments?[allappointments?.count ?? 0]
        }
        return nil

    }
    
}
