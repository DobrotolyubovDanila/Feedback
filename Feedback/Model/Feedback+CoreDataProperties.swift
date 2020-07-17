//
//  Feedback+CoreDataProperties.swift
//  Feedback
//
//  Created by Данила on 08.06.2020.
//  Copyright © 2020 Данила. All rights reserved.
//
//

import Foundation
import CoreData


extension Feedback {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feedback> {
        return NSFetchRequest<Feedback>(entityName: "Feedback")
    }

    @NSManaged public var name: String?
    @NSManaged public var comment: String?
    @NSManaged public var middleName: String?
    @NSManaged public var region: String?
    @NSManaged public var city: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var email: String?
    @NSManaged public var surname: String?

}
