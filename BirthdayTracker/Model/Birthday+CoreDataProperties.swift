//
//  Birthday+CoreDataProperties.swift
//  BirthdayTracker
//
//  Created by Антон Титов on 13.01.2022.
//
//

import Foundation
import CoreData


extension Birthday {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Birthday> {
        return NSFetchRequest<Birthday>(entityName: "Birthday")
    }

    @NSManaged public var birthdayID: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?

}

extension Birthday : Identifiable {

}
