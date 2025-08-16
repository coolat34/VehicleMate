//
//  ExpenseHistoryView.swift
//  CoreDataCar
//
//  Created by Chris Milne on 15/10/2023.
//

import SwiftUI
import CoreData

struct ExpenseHistoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    @ObservedObject var car: Car
    @ObservedObject var dcm: DataCarModel
    @State private var expensecost:Double = 0.0       /// Expense Entity
    @State private var expensedate = Date()           /// Expense Entity
    @State private var expensedetail: String = ""     /// Expense Entity
    @State var expensetot: Double = 0.0
    @State private var showingExpView = false
    @State private var isEditing = false
    var TotExpCost: Double {
        car.carExpenseArray.reduce(0.0) { $0 + $1.expensecost }
    }
    let rows = [GridItem(.fixed(100)), GridItem(.fixed(70)),GridItem(.fixed(80))]
 
    private var expHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(car.make!) \(car.model!) \(car.regno!)")
                .foregroundColor(.black)
            Text("Expense History").foregroundColor(.red)
            Text("Total Expenses: ").foregroundColor(.black) +
            Text("\(SC.currSym) \(String(format: "%.2f", TotExpCost))\n")
                .foregroundColor(.red)
        }
        .padding(.leading,50)
        .font(.system(size: 16, weight: .semibold))
    }
            
    private var detailLine: some View {
        LazyVGrid(columns: rows, alignment: HorizontalAlignment.leading) {
                Text("Date-Start").gridCellColumns(1)
                Text("Cost").gridCellColumns(2)
                Text("Odometer").gridCellColumns(3)
            }
        .padding(.leading,50)
        .font(.system(size: 14, weight: .semibold))
        }

    
    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                expHeader
                detailLine
                List {
                    ForEach(car.carExpenseArray) { expense in
                        HStack {
                            
                    
                            Text(Dates.aString(date: expense.expensedate ?? Date(), format: SC.settings.dates ?? "dd/MMM/yy"))
                               .frame(width: 80, alignment: .leading)
                            Text("\(SC.currSym) \(String(format: "%.2f", expense.expensecost))")
                                .frame(width: 80, alignment: .trailing)
                            Text(expense.expensedetail ?? "Unknown")
                                .frame(width: 70, alignment: .leading)
                        }   /// HStack
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal)
                    } /// ForEach
                    .onDelete(perform: deleteExpense)
                }/// List

                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Exit") {
                                dismiss()
                            } ///Button
                            .buttonStyle(.borderedProminent)
                           .bold()
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add Expense") {
                                showingExpView.toggle()
                            } /// Button
                           .buttonStyle(.borderedProminent)
                           .bold()
                        }  /// ToolbarItem
                        
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()   /// Displays an Edit button
                               .bold()
                               .foregroundColor(.white)
                               .buttonStyle(.borderedProminent)
                               .font(Font.custom("Avenir Heavy", size: 16))
                        } /// ToolbarItem
                        
                    } /// ToolBar
                    .fullScreenCover(isPresented: $showingExpView) {
                        AddExpense(car: car)
                        
                    } /// fullScreenCover
            } /// VStack
    } /// Nav View
        .navigationBarBackButtonHidden(true)
  
  } /// Body
    
    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { car.carExpenseArray[$0] }
                .forEach { expense in
                    car.removeFromCarExpense(expense)
                }
            car.expensestot = car.carExpenseArray.reduce(0.0) { $0 + ($1.expensecost ) }
            DataController().save(context: managedObjectContext)
    } /// Animation
    } /// func
} /// struct

