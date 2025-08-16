//
//  AddCarView.swift


import SwiftUI

struct AddCarDetails: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @StateObject var dcm = DataCarModel()

    @State private var purchasedateString = ""
    @State private var regdateString = ""
    @State private var motdateString = ""
    @State private var taxdateString = ""
    @State private var insurancedateString = ""
    var variantVar = ["Petrol", "Diesel", "EV", "Hybrid", "PHEV"]

    @State private var selectedDate = Date()
    let columns = [GridItem(.fixed(120)), GridItem(.fixed(175))]
    var body: some View {
        Text("Add a Vehicle to your files")
            .bold()
            .foregroundColor(.blue)
            .font(Font.custom("Avenir Heavy", size: 18))
        
        VStack {
            Form {
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 10 )  {
                    Text("Vehicle Make").gridCellColumns(1)
                    TextField("Vehicle  Make", text: $dcm.make)
                    Text("Vehicle  Model").gridCellColumns(1)
                    TextField("Vehicle  Model", text: $dcm.model)
                    Text("Reg Number").gridCellColumns(1)
                    TextField("Number", text: $dcm.regno)
                    Text("Starting Odometer \(SC.distSym)").gridCellColumns(1)
                    TextField("Odometer", value: $dcm.odometerstarting, format: .number)
                    Text("Purchase Cost \(SC.currSym)").gridCellColumns(1)
                    TextField("Purchase Cost", value: $dcm.purchasecost, format: .number )
                }   /// LazyGrid
                .padding(.leading,15)
                
                Text("Variant").padding(.leading,15)
                Picker("Variant", selection: $dcm.variant) {
                    ForEach(variantVar, id: \.self) { Text($0) }
                }/// Picker
                .pickerStyle(.segmented)
                .onChange(of: dcm.variant) {
                    dcm.fueltype = LocaleFormat.fuelType(variant: dcm.variant)
                }
                
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 10 )  {
                    Text("Purchase Date")
                    DatePicker("", selection: $dcm.purchasedate, displayedComponents: .date)
                    Text("MOT/DOT Date")
                    DatePicker("", selection: $dcm.motdate, displayedComponents: .date)
                    Text("Tax Date")
                    DatePicker("", selection: $dcm.taxdate, displayedComponents: .date)

                        }  /// Lazygrid
                .padding(.leading,15)
        } /// Form
    }  // VStack
        .interactiveDismissDisabled(true)
        .navigationBarBackButtonHidden(true)
        .font(.system(size: 13, weight: .semibold))
                HStack {
                    Spacer()
                    Button("Submit") {
  
                        DataController().addCar(make: dcm.make, model: dcm.model, regno: dcm.regno, variant: dcm.variant, fueltype: dcm.fueltype, purchasedate: dcm.purchasedate, odometerstarting: dcm.odometerstarting, purchasecost: dcm.purchasecost, motdate: dcm.motdate, taxdate: dcm.taxdate, context: managedObjectContext)

                        dismiss()
                        
                    } ///Button
                    .buttonStyle(.borderedProminent)
                    Spacer()
                    Button("Exit") {
                        dismiss()
                    } ///Button
                    .buttonStyle(.borderedProminent)
                    Spacer()
                } /// HStack
            }   /// Body
        } /// Struct

