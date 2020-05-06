//
//  User+CoreDataProperties.swift
//  Lighting Control App Prototype 1.5
//
//  Created by Cornelius Yap on 12/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userID: String

}
