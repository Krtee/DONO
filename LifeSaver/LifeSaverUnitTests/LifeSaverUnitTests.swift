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
    var sut: Hospitals!
    var testklasse: CoreDataService!
    
    

    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "LifeSaver")
        sut = Hospitals(context: container.newBackgroundContext())
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    //MARK: - Mock up container: NSInMemeoryStoreType - in-memory data store (fake)
    lazy var mockPersistantContainer: NSPersistentContainer = {
        //initialize the container with a customized managedObjectModel
        let container = NSPersistentContainer(name: "PersistentHospitalList", managedObjectModel: self.managedObjectModel)
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
    
    
    //MARK: - Putting items into the database as objects
    func initStubs() {
        func insertHospitalItem(hospitalID: String, name: String, street: String, postCode: Int64, longitude: Double, latitude: Double) -> Hospitals {
            let hospitalObject = NSEntityDescription.insertNewObject(forEntityName: "Hospitals", into: mockPersistantContainer.viewContext)
            
            hospitalObject.setValue(hospitalID, forKey: "hospitalID")
            hospitalObject.setValue(name, forKey: "Name")
            hospitalObject.setValue(street, forKey: "Address")
            hospitalObject.setValue(postCode, forKey: "PostCode")
            hospitalObject.setValue(longitude, forKey: "Longitutde")
            hospitalObject.setValue(latitude, forKey: "Latitude")
            
            return hospitalObject as? Hospitals ?? <#default value#>
        }
       /* insertHospitals(hospitalID: "Marienhospital", name: "Marienhospital", street: "Adresse", postCode: 70569, longitude: 9.084441, latitude: 48.786617)
        
        do {
            try mockPersistantContainer.viewContainer.save()
        } catch {
            print("Create fakes error \(error)")
        }*/
    }

}
