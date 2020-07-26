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
        
        initStubs()
        sut = Hospitals(context: container.newBackgroundContext())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        flushData()
        super.tearDown()
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

    /*func testCreateHospital() {
        //Given - the parameter of hospitals
        let hospitalID = "Marienhospital1"
        let name = "Marienhospital1"
        let street = "Böheimstraße 371"
        let postCode = 70199
        let longitude = "9.163325"
        let latitude = "48.760981"
        
        //When add hospitals
        let hospitals = sut.insertHospitalItems(hospitalID: "Marienhospital1", name: "Marienhospital1", street: "Böheimstraße 371", postCode: 70199, longitude: 9.163325, latitude: 48.760981)
        
        //Assert: return hospital item
        XCTAssertNotNil(hospitals)
    }
    
    func testFetchAllHospitals() {
        //Given - storage with the hospital item
        //When fetch
        let results = sut.fetchAll()
        
        //Assert return five hospital items
        XCTAssertEqual(results.count, 5)
    }
    
    func testRemoveHospitals() {
        //Given a item in persistent store
        let items = sut.fetchAll()
        let item = items[0]
        
        let numberOfItems = items.count
        
        //When remove an item
        sut.remove(hospitalID: item.hospitalID)
        sut.save()
        
        //Assert number of item - 1
        XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfItems-1)
    }
     
     func textSave() {
         //Given
         let hospitalID = "Marienhospital1"
         let name = "Marienhospital1"
         let street = "Böheimstraße 371"
         let postCode = 70199
         let longitude = "9.163325"
         let latitude = "48.760981"
         
         let expect = expectation(description: "Context Saved")
         
         waitForSavedNotification { (notification) in
             expect.fulfill()
         }
         
         _ = sut.insertHospitalItem(hospitalID: "Marienhospital", name: "Marienhospital", street: "Böheimstraße 37", postCode: 70199, longitude: 9.163325, latitude: 48.760981)
         
         //When save
         sut.save()
         
         //Assert save is called via notification (wait)
         waitForExpectations(timeout: 1, handler nil)
     }
     */

    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Hospitals")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
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
    
    
    //MARK: - Stub - canned responses - Insert Items, putting items into the database as objects
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
        
        insertHospitalItem(hospitalID: "Marienhospital", name: "Marienhospital", street: "Böheimstraße 37", postCode: 70199, longitude: 9.163325, latitude: 48.760981)
        insertHospitalItem(hospitalID: "Kliniken Schmieder Stuttgart", name: "Kliniken Schmieder Stuttgart", street: "Rötestraße 18a", postCode: 70197, longitude: 9.156899, latitude: 48.769740)
        insertHospitalItem(hospitalID: "Diakonie-Klinikum Stuttgart", name: "Diakonie-Klinikum Stuttgart", street: "Rosenbergstraße 38", postCode: 70176, longitude: 9.164053, latitude: 48.781406)

        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
          print("Create fakes error \(error)")
            }
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
