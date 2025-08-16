//
//  ExtraDetailsView.swift
//  CoreDataCar

import SwiftUI
import CoreData

struct ExtraDetails: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @ObservedObject var car: Car
    @ObservedObject var dcm: DataCarModel
    
    let columns = [GridItem(.fixed(120)), GridItem(.fixed(150))]
  var engvar: String { car.variant == "EV" ? " KW" : SC.engSym }
    private var exView: some View {
        VStack(spacing: 4) {
            Text("\(car.make ?? "") \(car.model ?? "") \(car.regno ?? "")")
                .bold()
                .foregroundColor(.black)
                .font(Font.custom("Avenir Heavy", size: 18))
            
            Text("Extra Details")
                .bold()
                .foregroundColor(.red)
                .font(Font.custom("Avenir Heavy", size: 18))
        }
    }
    var body: some View {
      exView
            Form {
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 10 )  {
      
                    Text("Engine Size \(engvar)").gridCellColumns(1)
                    TextField("Engine Size", text: $dcm.enginesize)
                    Text("VIN No").gridCellColumns(1)
                    TextField("VIN No", text: $dcm.vin)
                    Text("Engine version").gridCellColumns(1)
                    TextField("Engine version", text: $dcm.version)
                    Text("Service due Date").gridCellColumns(1)
                    DatePicker("", selection: $dcm.servicedue, displayedComponents: .date)
                } /// LazyGrid
                .padding(.leading,15)
                
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 10 )  {
                    Text("Registered Date").gridCellColumns(1)
                    DatePicker("", selection: $dcm.regdate, displayedComponents: .date)
                    Text("Body Colour").gridCellColumns(1)
                    TextField("Body Colour", text: $dcm.colour)
                    Text("Tyre Pressure \(SC.pressSym)").gridCellColumns(1)
                    TextField("Tyre Pressure", text: $dcm.tyrepressure)
                    Text("Tyre Size").gridCellColumns(1)
                    TextField("Tyre Size", text: $dcm.tyresize)
                    Text("Oil Type").gridCellColumns(1)
                    TextField("Oil Type", text: $dcm.oiltype)
                }   /// LazyGrid
                .padding(.leading,15)
            } /// Form
            .font(.system(size: 13, weight: .semibold))

                .onAppear {
                    dcm.enginesize   = car.enginesize ?? " "
                    dcm.vin          = car.vin ?? " "
                    dcm.version      = car.version ?? " "
                    dcm.regdate      = car.regdate ?? Date()
                    dcm.servicedue   = car.servicedue ?? Date()
                    dcm.colour       = car.colour ?? " "
                    dcm.tyrepressure = car.tyrepressure ?? " "
                    dcm.tyresize     = car.tyresize ?? " "
                    dcm.oiltype      = car.oiltype ?? " "
                    
                } /// onAppear

                .navigationBarBackButtonHidden(true)

            HStack {
                Spacer()
                Button("Submit") {
                    DataController().extraDetails(car: car,  regdate: dcm.regdate, servicedue: dcm.servicedue, enginesize: dcm.enginesize, vin: dcm.vin, version: dcm.version,  colour: dcm.colour, tyrepressure: dcm.tyrepressure, tyresize: dcm.tyresize, oiltype: dcm.oiltype,
                                                  context: managedObjectContext)
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

        .padding(.bottom, 90)
    } /// Body
} /// struct
      
