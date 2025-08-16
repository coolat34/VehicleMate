//  EditCarView.swift


import SwiftUI

struct EditCarDetails: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @ObservedObject var car: Car
    @ObservedObject var dcm: DataCarModel

    @State private var purchasedateString = ""
    @State private var regdateString = ""
    @State private var motdateString = ""
    @State private var taxdateString = ""
    @State private var insurancedateString = ""
    var variantVar = ["Petrol", "Diesel", "EV", "Hybrid", "PHEV"]
    let columns = [GridItem(.fixed(120)), GridItem(.fixed(150))]

    var body: some View {
        
        VStack   {
                Text("Edit Main Details")
                    .bold()
                    .foregroundColor(.blue)
                    .font(Font.custom("Avenir Heavy", size: 18))
            Form {
                    LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 10 )  {
                        Text("Car Make").gridCellColumns(1)
                        TextField("Car Make", text: $dcm.make)
                        Text("Car Model").gridCellColumns(1)
                        TextField("Car Model", text: $dcm.model)
                        Text("Reg Number").gridCellColumns(1)
                        TextField("Reg No", text: $dcm.regno)
                        Text("Starting Odometer \(SC.distSym)").gridCellColumns(1)
                        TextField("Starting Odometer", value: $dcm.odometerstarting, format: .number)
                        Text("Purchase Cost \(SC.currSym)").gridCellColumns(1)
                        TextField("Purchase Cost", value: $dcm.purchasecost, format: .number)
                    }   /// LazyGrid
                    .padding(.leading,1)
                
            Text("Variant").padding(.leading,20)
            Picker("Variant", selection: $dcm.variant) {
                ForEach(variantVar, id: \.self) { Text($0) }
            }/// Picker
            .pickerStyle(.segmented)
            .font(.caption)
            .padding(.leading,1)
            .onChange(of: dcm.variant) {
                dcm.fueltype = LocaleFormat.fuelType(variant: dcm.variant)
            }
                    
                    LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 10 )  {
                        
                        Text("Purchase Date").gridCellColumns(1)
            DatePicker("", selection: $dcm.purchasedate, displayedComponents: .date)
 
                        Text("Registration Date").gridCellColumns(1)
                    DatePicker("", selection: $dcm.regdate, displayedComponents: .date)
       
                        Text("TAX Date").gridCellColumns(1)
                    DatePicker("", selection: $dcm.taxdate, displayedComponents: .date)
          
                        Text("MOT/DOT Date").gridCellColumns(1)
                    DatePicker("", selection: $dcm.motdate, displayedComponents: .date)
    
                    }  /// LazyGrid
                    .padding(.leading,1)
                } /// Form
            .font(.system(size: 13, weight: .semibold))
      .onAppear {
          dcm.make = car.make ?? ""
          dcm.model = car.model ?? ""
          dcm.regno = car.regno ?? ""
          dcm.odometerstarting = car.odometerstarting
          dcm.variant = car.variant ?? ""
          dcm.purchasecost = car.purchasecost
          dcm.purchasedate = car.purchasedate ?? Date()
          dcm.regdate = car.regdate ?? Date()
          dcm.motdate = car.motdate ?? Date()
          dcm.taxdate = car.taxdate ?? Date()
          
      } /// onAppear

        }  /// VStack
        .navigationBarBackButtonHidden(true)
        HStack {
            Spacer()
            Button("Submit") {
                DataController().editCar(car: car, make: dcm.make, model: dcm.model, regno: dcm.regno, purchasedate: dcm.purchasedate, odometerstarting: dcm.odometerstarting, variant: dcm.variant, fueltype: dcm.fueltype, purchasecost: dcm.purchasecost, regdate: dcm.regdate,  taxdate: dcm.taxdate, motdate: dcm.motdate, context: managedObjectContext)
                dismiss()
            } ///Button
              .buttonStyle(.borderedProminent)
            Spacer()
            Button("Exit") {
                dismiss()
            } ///Button
            .buttonStyle(.borderedProminent)
            Spacer()
            
        } /// Hstack
    } /// Body
} /// struct
