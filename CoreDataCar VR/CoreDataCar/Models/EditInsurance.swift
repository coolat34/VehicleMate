//
//  EditInsurance.swift
//  CoreDataCar
//
//  Created by Chris Milne on 04/10/2023.
//
// A class is not required. Already using Core Data entities, and Insurance is an NSManagedObject.

import CoreData
import SwiftUI

struct EditInsurance: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    
    @ObservedObject var car: Car
    @ObservedObject var insurance: Insurance  // <-- the record to edit
    /// Declare the input variables before use
    @State private var policyname: String = ""
    @State private var policyno: String = ""
    @State private var datestart: Date = Date()
    @State private var dateend: Date = Date()
    @State private var premium: Double = 0.0
    @State private var excess: Int64 = 0
    @State private var claimstel: String = ""
    @State private var contactname: String = ""
    @State private var companyname: String = ""
    @State private var comparisonwebsite: String = ""
    @State private var comment: String = ""
    @State private var courtecycar: Bool = false
    @State private var protectedNCB: Bool = false
    @State private var windscreencover: Bool = false
    
    let columns = [GridItem(.fixed(120)), GridItem(.fixed(150))]
    private var ediView: some View {
        VStack {
            Text("\(car.make!) \(car.model!) \(car.regno!)")
                .bold()
                .foregroundColor(.black)
                .font(Font.custom("Avenir Heavy", size: 16))

            Text("Edit Insurance")
                .foregroundColor(.blue)
                .font(Font.custom("Avenir Heavy", size: 16))
    }
}
    var body: some View {
       ediView

            Form {
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3 )  {
                    Text("Policy Name").gridCellColumns(1)
                    TextField("Policy Name", text: $policyname)
                    
                    Text("Policy No").gridCellColumns(1)
                    TextField("Policy No", text: $policyno)
                    
                    Text("Date Start").gridCellColumns(1)
                    DatePicker("", selection: $datestart, displayedComponents: .date)
                    
                    Text("Date End").gridCellColumns(1)
                    DatePicker("", selection: $dateend, displayedComponents: .date)
                    
                    Text("Premium \(SC.currSym)").gridCellColumns(1)
                    TextField("Premium", value: $premium, format: .number)
                }.padding(.leading,15)
                
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3)  {
                    Text("Claims Tel").gridCellColumns(1)
                    TextField("Claims Tel", text: $claimstel)

                    Text("Contact Name").gridCellColumns(1)
                    TextField("Contact Name", text: $contactname)

                    Text("Company Name").gridCellColumns(1)
                    TextField("Company Name", text: $companyname)

                    Text("Comparison Website").gridCellColumns(1)
                    TextField("Comparison Website", text: $comparisonwebsite)

                    Text("Comment").gridCellColumns(1)
                    TextField("Comment", text: $comment)
                }.padding(.leading,15)

                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3)  {
                    Text("Excess \(SC.currSym)").gridCellColumns(1)
                    TextField("Excess", value: $excess, format: .number)

                    Text("Courtecy Car")
                    Toggle("", isOn: $courtecycar)

                    Text("No Claims Bonus Protection")
                    Toggle("", isOn: $protectedNCB)

                    Text("Windscreen Cover")
                    Toggle("", isOn: $windscreencover)
                }.padding(.leading,15)
            }
            .font(.system(size: 13, weight: .semibold))
            HStack {
                Spacer()
                Button("Submit Changes") {
                    updateInsurance()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Button("Exit") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }

        .onAppear(perform: loadInsuranceData)
        .interactiveDismissDisabled(true)
        .navigationBarBackButtonHidden(true)
    }

    private func loadInsuranceData() {
        // Populate state variables from existing insurance object
        policyname = insurance.policyname ?? ""
        policyno = insurance.policyno ?? ""
        datestart = insurance.datestart ?? Date()
        dateend = insurance.dateend ?? Date()
        premium = insurance.premium
        excess = insurance.excess
        claimstel = insurance.claimstel ?? ""
        contactname = insurance.contactname ?? ""
        companyname = insurance.companyname ?? ""
        comparisonwebsite = insurance.comparisonwebsite ?? ""
        comment = insurance.comment ?? ""
        courtecycar = insurance.courtecycar
        protectedNCB = insurance.protectedNCB
        windscreencover = insurance.windscreencover
    }

    private func updateInsurance() {
        insurance.policyname = policyname
        insurance.policyno = policyno
        insurance.datestart = datestart
        insurance.dateend = dateend
        insurance.premium = premium
        insurance.excess = excess
        insurance.claimstel = claimstel
        insurance.contactname = contactname
        insurance.companyname = companyname
        insurance.comparisonwebsite = comparisonwebsite
        insurance.comment = comment
        insurance.courtecycar = courtecycar
        insurance.protectedNCB = protectedNCB
        insurance.windscreencover = windscreencover

        try? managedObjectContext.save()
        updateTotInsurance()
    }

    private func updateTotInsurance() {
        car.insurancecosttot = Int64(car.carInsuranceArray.reduce(0) { $0 + $1.premium })
        try? managedObjectContext.save()
    }
}
