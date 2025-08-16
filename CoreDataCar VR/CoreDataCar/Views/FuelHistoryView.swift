//
//  FuelHistoryView.swift
//  CoreDataCar
//
//  Created by Chris Milne on 11/10/2023.
//

import SwiftUI
import CoreData

struct FuelHistoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    
    @ObservedObject var car: Car
    @ObservedObject var dcm: DataCarModel
    @State private var showingFuelView = false
 
    let columns = [GridItem(.fixed(165)), GridItem(.fixed(160))]
    let rows = [GridItem(.fixed(80)), GridItem(.fixed(50)), GridItem(.fixed(50)),GridItem(.fixed(80))]
    
    var TotFuelCost:Double { FuelFuncs.totFuelCost(car: car) }
    var TotFuel:    Double { FuelFuncs.totFuel(car: car) }
    var FuelUnit:   String { FuelFuncs.fuelUnit(SC: SC) }
    var costperDay: Double { FuelFuncs.costDayMonth(car: car) }
    var average:    Double { FuelFuncs.averageMPG(car: car) }
    var qtyDiff:    Int64  { FuelFuncs.odoDiff3(car: car) }
    var fueldesc:   String { fuelDesc() }
    
    private var fhView: some View {
        VStack(spacing: 4) {
            Text("\(car.make ?? "") \(car.model ?? "") \(car.regno ?? "")")
                .bold()
                .foregroundColor(.black)
                .font(Font.custom("Avenir Heavy", size: 16))
            
            Text("\(car.fueltype ?? "") History")
                .foregroundColor(.red)
                .font(Font.custom("Avenir Heavy", size: 16))
        }
    }
   
    private var fuelListHeader: some View {
        HStack {
            Text("Date")
            .frame(width: 70, alignment: .leading)
            Text(fueldesc)
                .frame(width: 50, alignment: .leading)
            Text("Cost")
                .frame(width: 50, alignment: .leading)
            Text("Odometer")
                .frame(width: 70, alignment: .leading)
        } // HSatck
        .font(.system(size: 14, weight: .semibold))
        .padding(.leading, 50)
    }
    
    private func fuelRow(for fuel: Fuel) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(Dates.aString(date: fuel.fueldate ?? Date(),
                                   format: SC.settings.dates ?? "dd/MMM/yy"))
                .frame(width: 70, alignment: .leading)
                Text(String(format: "%.1f", fuel.qtynow))
                    .frame(width: 50, alignment: .trailing)
                Text("\(SC.currSym)\(String(format: "%.2f", fuel.costperqty * fuel.qtynow))")
                    .frame(width: 50, alignment: .trailing)
                Text("\(fuel.odometernow)")
                    .frame(width: 70, alignment: .trailing)
            } // HSatck
            .font(.system(size: 13, weight: .semibold))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                fhView
                if car.fueltype == "Fuel" {
                    fuelView(dcm: dcm,
                             car: car,
                    TotFuelCost: TotFuelCost,
                    TotFuel: TotFuel,
                    FuelUnit: FuelUnit,
                    costperDay: costperDay,
                             average: average,
                             qtyDiff: qtyDiff)
                    
                    
                } else if car.fueltype == "Electric" {
                    electricView(dcm: dcm,
                                 car: car,
                                 TotFuelCost: TotFuelCost,
                                 TotFuel: TotFuel,
                                 FuelUnit: FuelUnit,
                                 costperDay: costperDay,
                                 average: average,
                                 qtyDiff: qtyDiff)
                } else {
                    Text("Other") }
                VStack(alignment: .leading, spacing: 4) {                    fuelListHeader
                    List {
                        ForEach(car.fuelCostArray) { fuel in
                                fuelRow(for: fuel)
                        } /// For Each
                        .onDelete(perform: deleteFuel)
                    }   /// List
                    
                } /// VStack
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Exit") {
                            dismiss()
                        } ///Button
                        .buttonStyle(.borderedProminent)
                        .bold()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add Fuel") {
                            showingFuelView.toggle()
                        } /// Button
                        .buttonStyle(.borderedProminent)
                        .bold()
                    }  /// ToolbarItem
                    
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()   /// Displays an Edit button
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 13, weight: .semibold))
                    } /// ToolbarItem
                    
                } /// ToolBar
                .buttonStyle(.borderedProminent)
                .fullScreenCover(isPresented: $showingFuelView) {
                    AddFuel(car: car)
                    
                } /// fullScreenCover
            }
    } /// Nav View
        .navigationBarBackButtonHidden(true)
  
  } /// Body
  
    func deleteFuel(offsets: IndexSet) {
        withAnimation {
            offsets.map { car.fuelCostArray[$0] }
                .forEach { fuel in
                    car.removeFromFuelCost(fuel)
                }
            car.fuelcosttot = car.fuelCostArray.reduce(0.0) { $0 + ($1.fuelcostnow ) }
            car.fuelqtytot = car.fuelCostArray.reduce(0.0) { $0 + ($1.qtynow ) }
            car.odometernow = car.fuelCostArray.max(by: { $0.odometernow < $1.odometernow })?.odometernow ?? 0
            DataController().save(context: managedObjectContext)
        }
    } // func delete

    func fuelDesc() -> String {
        var fuelType = "Ltrs"
        if SC.settings.currency == "USD" || SC.settings.currency == "COP" || SC.settings.currency == "DOP" || SC.settings.currency == "BZD" {
            fuelType = "US Galls"
        }  else if car.variant == "EV" {
                        fuelType = "Kwh"
        }
        return fuelType
        
    } // func fuelDesc
}
struct fuelView:  View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @ObservedObject var dcm: DataCarModel
    @ObservedObject var car: Car
    
    var TotFuelCost: Double
    var TotFuel:     Double
    var FuelUnit:    String
    var costperDay:  Double
    var average:     Double
    var qtyDiff:     Int64
    let columns = [GridItem(.fixed(165)), GridItem(.fixed(160))]
    
    var body: some View {
        
        VStack {
          
            List {
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3 )      {
                    Text("Tot Distance travelled").gridCellColumns(1)
                    Text("\(qtyDiff) \(SC.distSym)")
                    Text("Tot FuelCost").gridCellColumns(1);
                    Text("\(SC.currSym)  \(String(format: "%.0f", TotFuelCost))")
                    Text("FuelCost Daily").gridCellColumns(1)
                    Text("\(SC.currSym) " + String(format: "%.2f", costperDay))
                    Text("FuelCost Monthly").gridCellColumns(1)
                    costperDay > 0 ? Text("\(SC.currSym) " + String(format: "%.0f", costperDay * 30)) : Text("\(SC.currSym) 0.00")
                    Text("Miles per Gallon").gridCellColumns(1)
                    Text("\(String(format: "%.1f", (FuelFuncs.FuelRate(car: car, TotFuel: TotFuel, unit: "MPG")))) MPG")
                } /// Lazygrid
                .padding(.leading,50)

                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3 )      {
                    Text("Litres per 100 KM").gridCellColumns(1)
                    Text("\(String(format: "%.1f", (FuelFuncs.FuelRate(car:car, TotFuel: TotFuel, unit: "L/100km")))) L/100km")
                    Text("Litres per 10 KM").gridCellColumns(1)
                    Text("\(String(format: "%.1f", (FuelFuncs.FuelRate(car:car,TotFuel: TotFuel, unit: "L/10km")))) L/10km")
                    Text("KM per Litre").gridCellColumns(1)
                    Text("\(String(format: "%.1f", (FuelFuncs.FuelRate(car:car, TotFuel: TotFuel, unit: "km/L")))) km/L")
                }.padding(.leading,50)
                    
            } /// List or Section
        } /// VStack
        .font(.system(size: 13, weight: .semibold))
    } /// Body
} /// struct
   
// MARK:
struct electricView:  View {
        @Environment(\.managedObjectContext) var managedObjectContext
        @Environment(\.dismiss) var dismiss
        @EnvironmentObject var SC: SettingsController
        @ObservedObject var dcm: DataCarModel
        @ObservedObject var car: Car
    
        var TotFuelCost: Double
        var TotFuel:     Double
        var FuelUnit:    String
        var costperDay:  Double
        var average:     Double
        var qtyDiff:     Int64
        
        let columns = [GridItem(.fixed(165)), GridItem(.fixed(160))]
    
        var body: some View {
            VStack {
                List {
                    LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3 )      {
                        Text("Tot Distance travelled").gridCellColumns(1)
                        Text("\(qtyDiff) \(SC.distSym)")
                        Text("Tot Kwh Cost").gridCellColumns(1);
                        Text("\(SC.currSym)   \(String(format: "%.0f", TotFuelCost))")
                        Text("Kwh Cost Daily").gridCellColumns(1)
                        Text("\(SC.currSym) " + String(format: "%.2f", costperDay))
                        Text("Kwh Cost Monthly").gridCellColumns(1)
                        costperDay > 0 ? Text("\(SC.currSym) " + String(format: "%.0f", costperDay * 30)) : Text("\(SC.currSym) 0.00")
                        Text("Total Kwh").gridCellColumns(1)
                        Text("\(String(format: "%.0f", TotFuel)) kWh")
                    } /// Lazygrid
                    .padding(.leading,50)

                    LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3 )      {
                        Text("MPG equivalent").gridCellColumns(1)
                        Text("\(String(format: "%.1f", (FuelFuncs.FuelRate(car:car,TotFuel: TotFuel, unit: "MPGe")))) MPGe")
                        Text("Miles per kWh").gridCellColumns(1)
                        Text("\(String(format: "%.1f", (FuelFuncs.FuelRate(car:car,TotFuel: TotFuel, unit: "MkWh")))) MkWh")
                        Text("KM per kWh").gridCellColumns(1)
                        Text("\(String(format: "%.1f", (FuelFuncs.FuelRate(car:car,TotFuel: TotFuel, unit: "km/kWh")))) km/kWh")
                    }.padding(.leading,50)
                } // list
            } /// VStack
            .font(.system(size: 13, weight: .semibold))
        } /// Body electricView
} // electricView Struct

struct FuelFuncs   {
    /// Must not include any observed objects. Just pass car:Car  and/or SC as a parameter
    
    static func totFuelCost(car: Car) -> Double {
        return car.fuelCostArray.reduce(0.0) { $0 + $1.fuelcostnow }
    }
    
    static func totFuel(car: Car) -> Double {
        return car.fuelCostArray.reduce(0.0) { $0 + $1.qtynow }
    }
    
    static func fuelUnit(SC: SettingsController) -> String {
        if SC.currency == "USD" || SC.currency == "COP" || SC.currency == "DOP", SC.currency == "BZD" {
            return "us" }
        else {
            return "imperial"
        } }
    
    static func costDayMonth(car: Car) -> Double {
        let daysDiff = Dates.dateDiff(firstdate: car.purchasedate ?? Date())
        let costperDay = car.fuelcosttot == 0.0 || daysDiff == 0 ? 0.0 : (car.fuelcosttot) / Double(daysDiff )
        return costperDay
    } /// func cost
    
    static func averageMPG(car: Car) -> Double {
        return Double(car.odometernow - car.odometerstarting) / (car.fuelqtytot / 4.536)
    } /// func average
    
    static func odoDiff3(car: Car) -> Int64 {
        return car.odometernow - car.odometerstarting
    }
    
    static func FuelRate(car: Car, TotFuel: Double, unit: String) -> Double {
        guard TotFuel > 0 else { return 0.0}
        let dist = odoDiff3(car: car)
        let FUnit = fuelUnit(SC: SettingsController())
        let rage: Double =  averageMPG(car: car)
        switch unit {
            
        case "MPG":
            if FUnit == "us" {
                return Double(dist) / (TotFuel)
            } else if FUnit == "imperial" {
                return Double(dist) / rage }
            return 0.0
        
        case "L/100km":
            return TotFuel / Double(dist) * 100
        case "km/L":
            return Double(dist) / TotFuel
        case "L/10km":
            return TotFuel / Double(dist) * 10
        case "MPGe":
            if FUnit == "us" {
                return Double(dist) / (TotFuel / 33.7)
            } else if FUnit == "imperial" {
                return Double(dist) / (TotFuel / 39.6) }
            return 0.0
        case "MkWh":  // 1m = 1.6093 km
            if FUnit == "us" || FUnit == "imperial" {
                return Double(dist) / (TotFuel) }
            return Double(dist) * 1.6093 / (TotFuel)
            
        case "km/kWh":
            if FUnit == "us" || FUnit == "imperial" {
                return Double(dist) * 1.6093 / (TotFuel)}
            return Double(dist) / TotFuel
            
        default:
            return 0.0
        } ///
    } /// func
    
}
