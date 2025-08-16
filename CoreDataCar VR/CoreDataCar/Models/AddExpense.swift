//
//  AddExpense.swift
//  CoreDataCar
//
//  Created by Chris Milne on 03/09/2023.
//
//
import SwiftUI
import CoreData

struct AddExpense: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @ObservedObject var car: Car
    
    @State private var expensedetail: String = ""   /// Expense Entity
    @State private var expensecost:Double = 0.0     /// Expense Entity
    @State private var expensedate = Date()         /// Expense Entity
    
    @State var expensetot: Double = 0.0             /// Car Entity
    
    @State private var expensedateString = ""       /// Temp
    @State private var selectedDate = Date()        /// Temp
    @State var detail: String = ""                  /// Temp
    @State var cost: String = ""                    /// Temp

    @State private var isExpense = false            /// Temp
    let columns = [GridItem(.fixed(120)), GridItem(.fixed(175))]
    private var aexView: some View {
       VStack(spacing: 4) {
            Text("\(car.make ?? "") \(car.model ?? "") \(car.regno ?? "")")
                .bold()
                .foregroundColor(.black)
                .font(Font.custom("Avenir Heavy", size: 18))
            
            Text("Add Expense")
                .bold()
                .foregroundColor(.red)
                .font(Font.custom("Avenir Heavy", size: 18))
        }
    }
    var body: some View {
        VStack {
           aexView
               LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 10) {
                   Text("Expense Date")
                   DatePicker("", selection: $selectedDate, displayedComponents: .date)
                   Text("Detail")
                   TextField("Detail", text: $detail)
                       .textFieldStyle(.roundedBorder).gridCellColumns(1)
                   Text("Cost              £")
                   TextField(" Cost", text: $cost)
                       .textFieldStyle(.roundedBorder)
                   
               }   /// LazyGrid
               .font(.system(size: 13, weight: .semibold))
               .padding(.leading, 15)
               .navigationBarBackButtonHidden(true)

            Spacer()
            HStack {
                Spacer()
                Button {
                    updateExpense()
                    dismiss()
                } label: {
                    Text("Submit Changes")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 75, height: 38)
                } /// Button
                .buttonStyle(.borderedProminent)
               
               Spacer()
               
                Button("Exit")
                {
                    dismiss()
                }                                   ///Button
                .buttonStyle(.borderedProminent)
                .font(.system(size: 14, weight: .bold))
                .frame(width: 75, height: 38)
                Spacer()
            } /// HStack

        } /// VStack
        .padding(.bottom, 150)
            
    } /// Body
    
    private func updateExpense() {
        withAnimation {
            let newExpense = Expense(context: managedObjectContext)
            newExpense.expensedetail = detail
            newExpense.expensecost = Double(cost) ?? 0.0  /// Has to be unwrapped as it's converted from String
            newExpense.expensedate = selectedDate
            car.addToCarExpense(newExpense)
            car.expensestot = car.carExpenseArray.reduce(0.0) { $0 + ($1.expensecost ) }
            DataController().save(context: managedObjectContext)
        }
    }
} /// struct







