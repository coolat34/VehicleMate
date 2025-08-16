//
//  DataCarModel.swift
//  CoreDataCar
//
//  Created by Chris Milne on 24/07/2025.
//

import Foundation
class DataCarModel: ObservableObject {
    @Published var make: String = ""
    @Published var model: String = ""
    @Published var regno: String = ""
    @Published var purchasedate: Date = Date()
    @Published var odometerstarting: Int64 = 0
    @Published var purchasecost: Double = 0.0
    @Published var regdate: Date = Date()
    @Published var taxdate: Date = Date()
    @Published var motdate: Date = Date()
    @Published var colour: String = ""
    @Published var costperdistance: Double = 0.0
    @Published var enginesize: String = ""
    @Published var expensestot: Double = 0.0
    @Published var fuelcosttot: Double = 0.0
    @Published var fueltype: String = ""
    @Published var insurancecosttot: Int64 = 0
    @Published var fuelqtytot: Double = 0.0
    @Published var oiltype: String = ""
    @Published var servicedue: Date = Date()
    @Published var tyrepressure: String = ""
    @Published var tyresize: String = ""
    @Published var variant: String = ""
    @Published var version: String = ""
    @Published var vin: String = ""
    
    init(car: Car? = nil) {
        if let car = car {
            self.make = car.make ?? ""
            self.model = car.model ?? ""
            self.regno = car.regno ?? ""
            self.purchasedate = car.purchasedate ?? Date()
            self.odometerstarting = car.odometerstarting
            self.purchasecost = car.purchasecost
            self.regdate = car.regdate ?? Date()
            self.taxdate = car.taxdate ?? Date()
            self.motdate = car.motdate ?? Date()
            self.colour = car.colour ?? ""
            self.costperdistance = car.costperdistance
            self.enginesize = car.enginesize ?? ""
            self.expensestot = car.expensestot
            self.fuelcosttot = car.fuelcosttot
            self.fueltype = car.fueltype ?? ""
            self.insurancecosttot = car.insurancecosttot
            self.fuelqtytot = car.fuelqtytot
            self.oiltype = car.oiltype ?? ""
            self.servicedue = car.servicedue ?? Date()
            self.tyrepressure = car.tyrepressure ?? ""
            self.tyresize = car.tyrepressure ?? ""
            self.variant = car.variant ?? ""
            self.version = car.version ?? ""
            self.vin = car.vin ?? ""
        }
    }
    
    func apply(to car: Car) {
        car.make = make
        car.model = model
        car.regno = regno
        car.purchasedate = purchasedate
        car.odometerstarting = odometerstarting
        car.purchasecost = purchasecost
        car.regdate = regdate
        car.taxdate = taxdate
        car.motdate = motdate
        car.colour = colour
        car.costperdistance = costperdistance
        car.enginesize = enginesize
        car.expensestot = expensestot
        car.fuelcosttot = fuelcosttot
        car.fueltype = fueltype
        car.insurancecosttot = insurancecosttot
        car.fuelqtytot = fuelqtytot
        car.oiltype = oiltype
        car.servicedue = servicedue
        car.tyrepressure = tyrepressure
        car.tyresize = tyresize
        car.variant = variant
        car.version = version
        car.vin = vin
    }
}
