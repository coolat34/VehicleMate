//
//  Expense+CoreDataProperties.swift
//  CoreDataCar
//
//  Created by Chris Milne on 12/08/2025.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var expensecost: Double
    @NSManaged public var expensedate: Date?
    @NSManaged public var expensedetail: String?
    @NSManaged public var expenseid: UUID?
    @NSManaged public var carExpense: Car?

}

extension Expense : Identifiable {

}
