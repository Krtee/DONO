//
//  HospitalStoreManager.swift
//  LifeSaverUnitTests
//
//  Created by Dung Nguyen on 25.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit

class HospitalStoreManager {
    let persistenContainer: NSPersistenContainer!
    
    //MARK: - Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistenContainer)
    }
    
    lazy var backgroundContext: NSMangagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
}
