//
//  HospitalCell.swift
//  LifeSaver
//
//  Created by Dung Nguyen on 13.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
import CoreData

class HospitalsCell: NSManagedObject, Identifiable {
    @NSManaged public var hospitalID: String?
    @NSManaged public var name: String?
    @NSManaged public var street: String?
    //@NSManaged public var postCode: Integer64?
    //@NSManaged public var distance: Double?
}



extension HospitalsCell {
    static func getAllData() -> NSFetchRequest<HospitalsCell> {
        let request: NSFetchRequest<HospitalsCell> = HospitalsCell.fetchRequest() as! NSFetchRequest<HospitalsCell>
        
        let sortDesriptor = NSSortDescriptor(key: "hospitalID", ascending: true)
        request.sortDescriptors = [sortDesriptor]
        
        return request
    }
}
