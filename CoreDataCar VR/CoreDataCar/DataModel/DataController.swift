//
//  DataController.swift
//  CoreDataCar
//
//  Created by Chris Milne on 22/06/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CarModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            context.rollback()
            print("Could not save the Data")
        }
    }
    
    func addCar(make: String, model: String, regno: String, variant: String, fueltype: String, purchasedate: Date, odometerstarting: Int64, purchasecost: Double,  motdate: Date, taxdate: Date, context: NSManagedObjectContext) {
        let car = Car(context: context)
        car.id = UUID()
        car.make = make
        car.model = model
        car.regno = regno
        car.variant = variant
        car.fueltype = fueltype
        car.purchasedate = purchasedate
        car.odometerstarting = odometerstarting
        car.purchasecost = purchasecost
        car.motdate = motdate
        car.taxdate = taxdate
        save(context: context)
    }

    func addCarExpense(expensedetail: String, expensecost: Double, expensedate: Date,context: NSManagedObjectContext) {
        let expense = Expense(context: context)
        expense.expenseid = UUID()
        expense.expensedetail = expensedetail
        expense.expensecost = expensecost
        expense.expensedate = expensedate
        save(context: context)
    }
    
    func addExpenseToCar(context: NSManagedObjectContext, car: Car, expense: Expense) {
        car.addToCarExpense(expense)
        save(context: context)
    }
    
    func getExpenses(context: NSManagedObjectContext) -> Array<Expense> {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
        guard let result = result, !result.isEmpty else {
            return []
        }
        return result
    }
    
    func removeCarExpense(context: NSManagedObjectContext, expense: Expense){
        context.delete(expense)
        save(context: context)
    }
    
    func addFuelCost(qtynow: Double, fuelcostnow: Double, mileage: Int64, selectedDate: Date, fuelcost: Double, context: NSManagedObjectContext) {
        let fuel = Fuel(context: context)
       fuel.fuelid = UUID()
        fuel.fueldate = selectedDate
        fuel.odometernow = mileage
        fuel.qtynow = qtynow
        fuel.costperqty = fuelcostnow
        fuel.fuelcostnow = fuelcost
        save(context: context)
    }
/// called by CoreData car.addtoFuelCost
    func addFueltoCar(car: Car,  fuel: Fuel, totlitres: Double, totcost: Double,
                 context: NSManagedObjectContext) {
        car.fuelqtytot = totlitres
        car.fuelcosttot = totcost
        car.addToFuelCost(fuel)
        save(context: context)
    }
    
    func getFuel(context: NSManagedObjectContext) -> Array<Fuel> {
        let fetchRequest: NSFetchRequest<Fuel> = Fuel.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
        guard let result = result, !result.isEmpty else {
            return []
        }
        return result
    }
    
    func removeFuelCost(context: NSManagedObjectContext, fuel: Fuel) {
        context.delete(fuel)
        save(context: context)
    }
    
    func addCarInsurance(
        car: Car,
        dateStart: Date,
        dateEnd: Date,
        excess: Int64,
        comment: String,
        contactName: String,
        claimsTel: String,
        policyNo: String,
        policyName: String,
        companyName: String,
        premium: Double,
        courtecyCar: Bool,
        windscreenCover: Bool,
        protectedNCB: Bool,
        comparisonWebsite: String,
        context: NSManagedObjectContext) {
            let insurance = Insurance(context: context)
            insurance.insuranceID = UUID()
            insurance.comment = comment
            insurance.excess = excess
            insurance.datestart = dateStart
            insurance.dateend = dateEnd
            insurance.contactname = contactName
            insurance.claimstel = claimsTel
            insurance.policyno = policyNo
            insurance.policyname = policyName
            insurance.companyname = companyName
            insurance.premium = premium
            insurance.courtecycar = courtecyCar
            insurance.windscreencover = windscreenCover
            insurance.protectedNCB = protectedNCB
            insurance.comparisonwebsite = comparisonWebsite
            save(context: context)
        }
    
    func extraDetails(car: Car,  regdate: Date, servicedue: Date, enginesize: String, vin: String, version: String, colour: String, tyrepressure: String, tyresize: String, oiltype: String, context: NSManagedObjectContext) {
        car.regdate = regdate
        car.servicedue = servicedue
        car.enginesize = enginesize
        car.vin  = vin
        car.version = version
        car.colour = colour
        car.tyrepressure = tyrepressure
        car.tyresize = tyresize
        car.oiltype = oiltype
        save(context: context)
    }
    
/*
    func addInsurancetoCar(car: Car,  insurance: Insurance, insurername: String, insurerpolicy: String, insurercontact: String, insurancecosttot: Int64,
                 context: NSManagedObjectContext) {
        car.insurername = insurername
        car.insurerpolicy = insurerpolicy
        car.insurercontact = insurercontact
        car.insurancecosttot = insurancecosttot
        car.addToCarInsurance(insurance)
        save(context: context)
    }
*/
    func getInsurance(context: NSManagedObjectContext) -> Array<Insurance> {
        let fetchRequest: NSFetchRequest<Insurance> = Insurance.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
        guard let result = result, !result.isEmpty else {
            return []
        }
        return result
    }
    
    func removeCarInsurance(context: NSManagedObjectContext, insurance: Insurance){
        context.delete(insurance)
        save(context: context)
    }
    
    func editCar(car: Car, make: String, model: String, regno: String, purchasedate: Date, odometerstarting: Int64, variant: String, fueltype: String, purchasecost: Double, regdate: Date, taxdate: Date, motdate: Date, context: NSManagedObjectContext) {
        car.make = make
        car.model = model
        car.regno = regno
        car.purchasedate = purchasedate
        car.odometerstarting = odometerstarting
        car.variant = variant
        car.fueltype = fueltype
        car.purchasecost = purchasecost
        car.regdate = regdate
        car.taxdate = taxdate
        car.motdate = motdate
        
 //       save(context: context)
        do {
               try context.save()
           } catch {
               print("func EditCar ❌ Failed to save updated car: \(error.localizedDescription)")
           }
       }

    
    
    
    func insurance(car: Car,  insurancecosttot: Int64,
                   context: NSManagedObjectContext) {
        car.insurancecosttot = insurancecosttot
        save(context: context)
    }
    
    static func aString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yy"
        let strDate = formatter.string(from: date)
        return strDate
    }
}
/* If CoreDataProperties is re-created, add these 4 public vars to CoreDataProperties just below the last @NSManaged public var carInsurance: NSSet?

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
            ($0.datestart ?? Date()) < ($1.dateStart ?? Date())
        }
    }
}
*/
