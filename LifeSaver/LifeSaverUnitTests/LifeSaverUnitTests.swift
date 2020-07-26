//
//  LifeSaverUnitTests.swift
//  LifeSaverUnitTests
//
//  Created by Dung Nguyen on 25.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import XCTest
import CoreData
@testable import LifeSaver
//1. Given
//2. When
//3. Then

class LifeSaverUnitTests: XCTestCase {
    var testklasse: CoreDataService!
    
    override func setUp() {
        super.setUp()
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        initStubs()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        flushData()
        super.tearDown()
    }

    func testCreateHospital() {
        //Given - the parameter of hospitals
        let hospitalID = "Marienhospital1"
        let name = "Marienhospital1"
        let street = "Böheimstraße 371"
        let postCode = 70199
        let longitude = 9.163325
        let latitude = 48.760981
        
        //When add hospitals
        let hospitals = insertHospitalItem(hospitalID: hospitalID, name: name, street: street, postCode: Int64(postCode), longitude: longitude, latitude: latitude)
        
        //Assert: return hospital item
        XCTAssertNotNil(hospitals)
    }
    
    func testFetchAllHospitals() {
        //Given - storage with the hospital item
        //When fetch
        let results = loadData()
        
        //Assert return five hospital items
        XCTAssertEqual(results.count, 3)
    }
    
    private func loadData() -> [Hospitals] {
        let fetchRequest: NSFetchRequest<Hospitals> = Hospitals.fetchRequest() //Nur die Anfrage
        
        do {
            let resultArray = try mockPersistantContainer.viewContext.fetch(fetchRequest)
            return resultArray
        } catch {
            print("Fehler beim Laden der Daten", error.localizedDescription)
        }
        
        return []
    }
    
    //MARK: - Mock up container: NSInMemeoryStoreType - in-memory data store (fake)
    lazy var mockPersistantContainer: NSPersistentContainer = {
        //initialize the container with a customized managedObjectModel
        let container = NSPersistentContainer(name: "PersistentHospitalTest", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores {
            (description, error) in
            //check if the data store is in memory
            precondition(description.type == NSInMemoryStoreType)
            
            //check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        
        return container
    }()
    
    //MARK: - Customized managed object model
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
        return managedObjectModel
    }()
    
    
    //MARK: - Stub - canned responses - Insert Items, putting items into the database as objects
    func initStubs() {
        insertHospitalItem(hospitalID: "Marienhospital", name: "Marienhospital", street: "Böheimstraße 37", postCode: 70199, longitude: 9.163325, latitude: 48.760981)
        insertHospitalItem(hospitalID: "Kliniken Schmieder Stuttgart", name: "Kliniken Schmieder Stuttgart", street: "Rötestraße 18a", postCode: 70197, longitude: 9.156899, latitude: 48.769740)
        insertHospitalItem(hospitalID: "Diakonie-Klinikum Stuttgart", name: "Diakonie-Klinikum Stuttgart", street: "Rosenbergstraße 38", postCode: 70176, longitude: 9.164053, latitude: 48.781406)

        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
          print("Create fakes error \(error)")
            }
        }
    
    func insertHospitalItem(hospitalID: String, name: String, street: String, postCode: Int64, longitude: Double, latitude: Double) {
        let hospitalObject = NSEntityDescription.insertNewObject(forEntityName: "Hospitals", into: mockPersistantContainer.viewContext)
        
        hospitalObject.setValue(hospitalID, forKey: "hospitalID")
        hospitalObject.setValue(name, forKey: "Name")
        hospitalObject.setValue(street, forKey: "street")
        hospitalObject.setValue(postCode, forKey: "postCode")
        hospitalObject.setValue(longitude, forKey: "longitude")
        hospitalObject.setValue(latitude, forKey: "latitude")
    }
    
    //MARK: - Fetch Request - makes sure that every test case starts end ends with the same environment and condition. Removes all stubs from it after each test
    func flushData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospitals")
        let hospitalObject = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let hospitalObject as NSManagedObject in hospitalObject {
            mockPersistantContainer.viewContext.delete(hospitalObject)
        }
        try! mockPersistantContainer.viewContext.save()
    }

}
