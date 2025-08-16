//
//  InsuranceHistoryView.swift
//  CoreDataCar
//
//  Created by Chris Milne on 12/10/2023.
//
import SwiftUI
import CoreData

struct InsuranceHistoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @ObservedObject var dcm: DataCarModel
    @ObservedObject var car: Car

    @State private var showingInsView = false
    var TotInsCost: Double{
        car.carInsuranceArray.reduce(0.0) { $0 + $1.premium }
    }
    let rows = [GridItem(.fixed(30)), GridItem(.fixed(30)),GridItem(.fixed(30))]
    private var ihView: some View {
        VStack(spacing: 4) {
            Text("\(car.make!) \(car.model!) \(car.regno!)")
                .bold()
                .foregroundColor(.black)
                .font(Font.custom("Avenir Heavy", size: 16))
            Text("     Insurance History")
                .bold()
                .foregroundColor(.red)
                .font(Font.custom("Avenir Heavy", size: 16))
        }
    }
    private var insuranceListHeader: some View {
        VStack {
            Text("          Date-Start      Premium    Policy No")
        }
        .font(.system(size: 13, weight: .semibold))
    }

    private func insuranceRow(for record: Insurance) -> some View {
        VStack(alignment: .leading, spacing: 6) {
           
        Text(Dates.aString(date: record.datestart ?? Date(), format: SC.settings.dates ?? "dd/MMMM/yy"))  +
                Text("        \(SC.currSym) \(String(format: "%.2f", (record.premium)))") +
                Text("    \(record.policyno ?? "")")
        }.font(.system(size: 13, weight: .semibold))
    }
    
    private var totalCostView: some View {
        Text("      Total Premiums: \(SC.currSym) \(String(format: "%.2f", TotInsCost))")
            .font(.system(size: 13, weight: .semibold))
    }

    var body: some View {
        NavigationView {  /// Needs to be at the top to prevent parts of this vew appearing in the next view
        VStack(spacing: 8) {
            ihView

                VStack(alignment: .leading, spacing: 4) {
                    insuranceListHeader
                    List {
                        ForEach(car.carInsuranceArray) { record in
                            NavigationLink (destination:
            EditInsurance(car: car, insurance: record)
                                .environmentObject(SC)
                                .navigationBarBackButtonHidden(true)
                            ) {
                                insuranceRow(for: record)
                            }
                        } /// For Each
                        .onDelete(perform: deleteInsurance)
                    }   /// List
                    
                    totalCostView
                    
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
                        Button("Add Insurance") {
                            showingInsView.toggle()
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
                .fullScreenCover(isPresented: $showingInsView) {
                    AddInsurance(car: car)
                    
                } /// fullScreenCover
            } /// 1
            ///
        } /// Nav View
        .navigationBarBackButtonHidden(true)
    } /// Body

    private func deleteInsurance(offsets: IndexSet) {
        withAnimation {
            offsets.map { car.carInsuranceArray[$0] }
                .forEach { insuranceRecord in
                    car.removeFromCarInsurance(insuranceRecord)
                } /// ForEach
            car.insurancecosttot = Int64(car.carInsuranceArray.reduce(0) { $0 + ($1.premium ) })
            DataController().save(context: managedObjectContext)
        } /// Animation
    } /// func
} /// struct

