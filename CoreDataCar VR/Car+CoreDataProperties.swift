//
//  Car+CoreDataProperties.swift
//  CoreDataCar
//
//  Created by Chris Milne on 12/08/2025.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var colour: String?
    @NSManaged public var costperdistance: Double
    @NSManaged public var enginesize: String?
    @NSManaged public var expensestot: Double
    @NSManaged public var fuelcosttot: Double
    @NSManaged public var fuelqtytot: Double
    @NSManaged public var fueltype: String?
    @NSManaged public var id: UUID?
    @NSManaged public var insurancecosttot: Int64
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var motdate: Date?
    @NSManaged public var odometernow: Int64
    @NSManaged public var odometerstarting: Int64
    @NSManaged public var oiltype: String?
    @NSManaged public var purchasecost: Double
    @NSManaged public var purchasedate: Date?
    @NSManaged public var regdate: Date?
    @NSManaged public var regno: String?
    @NSManaged public var servicedue: Date?
    @NSManaged public var taxdate: Date?
    @NSManaged public var tyrepressure: String?
    @NSManaged public var tyresize: String?
    @NSManaged public var variant: String?
    @NSManaged public var version: String?
    @NSManaged public var vin: String?
    @NSManaged public var carExpense: NSSet?
    @NSManaged public var carInsurance: NSSet?
    @NSManaged public var fuelCost: NSSet?

    public var unwrappedMake: String {
        make ?? "Unknown Make"
    } /// public var1
    
    
    // Typed, sorted array from the raw NSSet
    public var carExpenseArray: [Expense] {
        let set = carExpense as? Set<Expense> ?? []
        return set.sorted {
            // sort by date (you can adjust to your desired order)
            ($0.expensedate ?? Date()) < ($1.expensedate ?? Date())
        }
    }
    
    public var fuelCostArray: [Fuel] {
        let set = fuelCost as? Set<Fuel> ?? []
        return set.sorted {
            ($0.fueldate ?? Date()) < ($1.fueldate ?? Date())
        }
    }
    
    public var carInsuranceArray: [Insurance] {
        let set = carInsurance as? Set<Insurance> ?? []
        return set.sorted {
            ($0.datestart ?? Date()) < ($1.datestart ?? Date())
        }
    }

}

// MARK: Generated accessors for carExpense
extension Car {

    @objc(addCarExpenseObject:)
    @NSManaged public func addToCarExpense(_ value: Expense)

    @objc(removeCarExpenseObject:)
    @NSManaged public func removeFromCarExpense(_ value: Expense)

    @objc(addCarExpense:)
    @NSManaged public func addToCarExpense(_ values: NSSet)

    @objc(removeCarExpense:)
    @NSManaged public func removeFromCarExpense(_ values: NSSet)

}

// MARK: Generated accessors for carInsurance
extension Car {

    @objc(addCarInsuranceObject:)
    @NSManaged public func addToCarInsurance(_ value: Insurance)

    @objc(removeCarInsuranceObject:)
    @NSManaged public func removeFromCarInsurance(_ value: Insurance)

    @objc(addCarInsurance:)
    @NSManaged public func addToCarInsurance(_ values: NSSet)

    @objc(removeCarInsurance:)
    @NSManaged public func removeFromCarInsurance(_ values: NSSet)

}

// MARK: Generated accessors for fuelCost
extension Car {

    @objc(addFuelCostObject:)
    @NSManaged public func addToFuelCost(_ value: Fuel)

    @objc(removeFuelCostObject:)
    @NSManaged public func removeFromFuelCost(_ value: Fuel)

    @objc(addFuelCost:)
    @NSManaged public func addToFuelCost(_ values: NSSet)

    @objc(removeFuelCost:)
    @NSManaged public func removeFromFuelCost(_ values: NSSet)

}

extension Car : Identifiable {

}
