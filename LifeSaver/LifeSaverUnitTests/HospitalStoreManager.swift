//
//  HospitalStoreManager.swift
//  LifeSaverUnitTests
//
//  Created by Dung Nguyen on 25.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit
import CoreData

class HospitalStoreManager {
    let persistentContainer: NSPersistentContainer!
    
    //MARK: - Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.init(container: appDelegate.persistentContainer)
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
}
