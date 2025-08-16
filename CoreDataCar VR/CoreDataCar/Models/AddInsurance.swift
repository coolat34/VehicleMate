//
//  AddInsurance.swift
//  CoreDataCar
//
//  Created by Chris Milne on 04/10/2023.
//

import SwiftUI
import CoreData

struct AddInsurance: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @ObservedObject var car: Car
    
    
    @State private var dateStartString = ""
    @State private var dateEndString = ""
    var YesNoVar = ["Yes", "No"]
    
    
    /// Temp Input variables
    @State var policyName: String = ""
    @State var policyNo: String = ""
    @State var dateStart: Date = Date()
    @State var dateStartStr: String = ""
    @State var dateEnd: Date = Date()
    @State var dateEndStr: String = ""
    @State var premium: Double = 0.0
    @State var excess: Int64 = 0
    @State var claimsTel: String = ""
    @State var contactName: String = ""
    @State var companyName: String = ""
    @State var comparisonwebsite: String = ""
    @State var comment: String = ""
    @State var courtecyCar: Bool = false
    @State var protectedNCB: Bool = false
    @State var windscreenCover: Bool = false
    
    @State private var isInsurance = false
    let columns = [GridItem(.fixed(120)), GridItem(.fixed(150))]
    private var adiView: some View {
        VStack  {
        Text("\(car.make!) \(car.model!) \(car.regno!)\n")
            .bold()
            .foregroundColor(.black)
            .font(.system(size: 13, weight: .semibold))
   
        Text("Add Insurance")
                .bold()
                .foregroundColor(.blue)
                .font(.system(size: 16, weight: .semibold))
    }
}
    var body: some View {
 //       NavigationView {
       adiView

            Form {
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 5) {
                    
                    Text("Policy Name").gridCellColumns(1)
                    TextField("Policy Name", text: $policyName)
                    Text("Policy No").gridCellColumns(1)
                    TextField("Policy No", text: $policyNo)
                    Text("Date Start").gridCellColumns(1)
                    DatePicker("", selection: $dateStart, displayedComponents: .date)

                    Text("Date End").gridCellColumns(1)
                    DatePicker("", selection: $dateEnd, displayedComponents: .date)

                    Text("Premium \(SC.currSym)").gridCellColumns(1)
                    TextField("Premium", value: $premium, format: .number)
                }   /// LazyGrid
                .padding(.leading,15)
                
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 5)  {
                    Text("Claims Tel").gridCellColumns(1)
                    TextField("Claims tel", text: $claimsTel)
                    Text("Contact Name").gridCellColumns(1)
                    TextField("Contact Name", text: $contactName)
                    Text("Company Name").gridCellColumns(1)
                    TextField("Company Name", text: $companyName)
                    Text("Comparison Website").gridCellColumns(1)
                    TextField("Comparison Website", text: $comparisonwebsite)
                    Text("Comment").gridCellColumns(1)
                    TextField("Comment", text: $comment)
                }.padding(.leading,15)
                
                LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 5)  {
                    Text("Excess \(SC.currSym)").gridCellColumns(1)
                    TextField("Excess", value: $excess, format: .number)
                    Text("Courtecy Car")
                    Toggle("", isOn: $courtecyCar)
                    Text("Protected NCB")
                    Toggle("", isOn: $protectedNCB)
                    Text("Windscreen Cover")
                    Toggle("", isOn: $windscreenCover)
                } /// LazyGrid
                .padding(.leading,15)
            } /// Form
            .font(.system(size: 13, weight: .semibold))
            .interactiveDismissDisabled(true)
            .navigationBarBackButtonHidden(true)

            HStack {
                Spacer()
                Button {
                    updateInsurance()
                    dismiss()
                } label: {
                    Text("Submit Changes")
                    
                        
                        .frame(width: 120, height: 38)
                } /// Button
                .buttonStyle(.borderedProminent)

               Spacer()

                Button("Exit")
                {
                    dismiss()
                }                                   ///Button
                .buttonStyle(.borderedProminent)
                Spacer()
            } /// HStack
            .font(.system(size: 13, weight: .semibold))
    } /// Body

    private func updateInsurance() {
        withAnimation {
            let newPolicy = Insurance(context: managedObjectContext)
            newPolicy.policyname = policyName
            newPolicy.policyno = policyNo
            newPolicy.datestart = dateStart
            newPolicy.dateend = dateEnd
            newPolicy.premium = Double(premium)
            newPolicy.claimstel = claimsTel
            newPolicy.contactname = contactName
            newPolicy.companyname = companyName
            newPolicy.comparisonwebsite = comparisonwebsite
            newPolicy.comment = comment
            newPolicy.courtecycar = courtecyCar
            newPolicy.protectedNCB = protectedNCB
            newPolicy.windscreencover = windscreenCover
            
            car.addToCarInsurance(newPolicy)

            DataController().save(context: managedObjectContext)
            updateTotInsurance()
        }
    }

    private func updateTotInsurance() {
        car.insurancecosttot = Int64(car.carInsuranceArray.reduce(0) { $0 + ($1.premium ) })
        DataController().save(context: managedObjectContext)
    }
}
