//
//  AddFuel.swift
//  CoreDataCar
//
//  Created by Chris Milne on 01/10/2023.
//

import SwiftUI
import CoreData

struct AddFuel: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @ObservedObject var car: Car
    
    @State private var costperqty:Double = 0.0 /// Fuel Entity. Use for Galls or Litres
    @State private var fuelcostnow: Double = 0.0 /// Fuel Entity
    @State private var fueldate = Date()         /// Fuel Entity
    @State private var qtynow:Double = 0.0    /// Fuel Entity. Use for Galls or Litres
    @State private var odometernow:Int64 = 0      /// Fuel Entity
    
    @State private var fuelcosttot:Double = 0.0 /// Car Entity
    
    @State private var fueldateString = ""    /// Temp variables
    @State private var selectedDate = Date()  /// Temp variables
    @State var fuelcost:String = ""               /// Temp variables
    @State var fuelQty:String = ""             /// Temp variables
    @State var mileage:String = ""            /// Temp variables. Use for KM or Miles
    
    let columns = [GridItem(.fixed(120)), GridItem(.fixed(150))]

  @State private var isFuel: Bool = false
   @State private var isElectric: Bool = false
    private var adfView: some View {
        VStack(spacing: 4) {
            Text("\(car.make!) \(car.model!) \(car.regno!)")
                .bold()
                .foregroundColor(.black)
                .font(Font.custom("Avenir Heavy", size: 18))
            
            Text("Add \(car.fueltype ?? "Fuel") Fuel")
                .bold()
                .foregroundColor(.red)
                .font(Font.custom("Avenir Heavy", size: 18))
                .padding(.leading,20)
        }
    }
    var body: some View {
//        NavigationView {
                adfView
        if car.fueltype == "Fuel" {
            fuelInput
        } else if car.fueltype == "Electric" {
            electricInput
        } else {
            Text("Can't find Fuel Type input screen \(car.fueltype!)")
        }
                Spacer()
                HStack {
                    
                    Spacer()
                    Button {
                        updateFuel()
                        dismiss()
                    } label: {
                        Text("Submit Changes")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 75, height: 38)
                    } /// Button
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                   
                    Button("Exit")
                    {
                        dismiss()
                    }                                   ///Button
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .semibold))
                    .frame(width: 75, height: 38)
                    Spacer()
                } /// HStack
                
            .padding(.bottom, 150)
            .bold()
             .foregroundColor(.black)
             .font(.system(size: 13, weight: .semibold))
            .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
        
    } /// Body
                
 // MARK
        var fuelInput: some View {
            VStack {
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 10) {
                    
                    Text("Fuel Date")
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)

                    
                    Text("Fuel Qty \(SC.fuelSym)")
                    TextField("Fuel Qty", text: $fuelQty)
                        .textFieldStyle(.roundedBorder).gridCellColumns(1)
                    Text("Price per  \(SC.currSym) ")
                    TextField("Price per", text: $fuelcost)
                        .textFieldStyle(.roundedBorder)
                    Text("Odometer \(SC.distSym)")
                    TextField("Odometer", text: $mileage)
                        .textFieldStyle(.roundedBorder).gridCellColumns(1)
                        .navigationViewStyle(.stack)
                    
                }   /// LazyGrid
                .font(.system(size: 14, weight: .bold))
                .padding(.leading, 15)
            } /// VStack

        } // fuelInput
        
        var electricInput: some View {
            VStack {
            
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    Text("Charge Date")
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    Text("Kwh Used")
                    TextField("Kwh", text: $fuelQty)
                    Text("Price per Kwh \(SC.currSym) ")
                    TextField("Price per", text: $fuelcost)
                    Text("Odometer \(SC.distSym)")
                    TextField("Odometer", text: $mileage)
                } /// lazyGrid
                .font(.system(size: 14, weight: .bold))
                .padding(.leading, 15)
            } /// VStack
        }///electricInput
        

    private func updateFuel() {
        withAnimation {
            guard !fuelQty.isEmpty, !fuelcost.isEmpty, !mileage.isEmpty else { return }
            let newFuel = Fuel(context: managedObjectContext)
            newFuel.qtynow = Double(fuelQty) ?? 0.0
            newFuel.costperqty = Double(fuelcost) ?? 0.0
            newFuel.odometernow = Int64(mileage) ?? 0
            newFuel.fueldate = selectedDate
            newFuel.fuelcostnow = Double(fuelQty)! * Double(fuelcost)!
            car.addToFuelCost(newFuel)
            DataController().save(context: managedObjectContext)
            updateTotFuel()
        }
    }

    private func updateTotFuel() {
        car.fuelcosttot = car.fuelCostArray.reduce(0.0) { $0 + ($1.fuelcostnow ) }
        car.fuelqtytot = car.fuelCostArray.reduce(0.0) { $0 + ($1.qtynow ) }
        car.odometernow = Int64(mileage) ?? 0
        DataController().save(context: managedObjectContext)
    }
    
    
}
