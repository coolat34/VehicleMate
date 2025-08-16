//
//  Insurance+CoreDataProperties.swift
//  CoreDataCar
//
//  Created by Chris Milne on 12/08/2025.
//
//

import Foundation
import CoreData


extension Insurance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Insurance> {
        return NSFetchRequest<Insurance>(entityName: "Insurance")
    }

    @NSManaged public var claimstel: String?
    @NSManaged public var comment: String?
    @NSManaged public var companyname: String?
    @NSManaged public var comparisonwebsite: String?
    @NSManaged public var contactname: String?
    @NSManaged public var courtecycar: Bool
    @NSManaged public var dateend: Date?
    @NSManaged public var datestart: Date?
    @NSManaged public var excess: Int64
    @NSManaged public var insdate: Date?
    @NSManaged public var insuranceID: UUID?
    @NSManaged public var policyname: String?
    @NSManaged public var policyno: String?
    @NSManaged public var premium: Double
    @NSManaged public var protectedNCB: Bool
    @NSManaged public var windscreencover: Bool
    @NSManaged public var carInsurance: Car?

}

extension Insurance : Identifiable {

}
