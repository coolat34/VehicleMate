//
//  Fuel+CoreDataProperties.swift
//  CoreDataCar
//
//  Created by Chris Milne on 12/08/2025.
//
//

import Foundation
import CoreData


extension Fuel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fuel> {
        return NSFetchRequest<Fuel>(entityName: "Fuel")
    }

    @NSManaged public var costperqty: Double
    @NSManaged public var fuelcostnow: Double
    @NSManaged public var fuelcosttot: Double
    @NSManaged public var fueldate: Date?
    @NSManaged public var fuelid: UUID?
    @NSManaged public var odometernow: Int64
    @NSManaged public var qtynow: Double
    @NSManaged public var fuelCost: Car?

}

extension Fuel : Identifiable {

}
