//
//  FirstView.swift
//  CoreDataCar
//
//  Created by Chris Milne on 03/01/2024.



 import SwiftUI

 struct TxLabel: ViewModifier {
     func body(content: Content) -> some View {
         content
             .font(.caption2)
             .frame(width: 65)
             .foregroundColor(.black)
     }
 }

 struct ImLabel: ViewModifier {
     func body(content: Content) -> some View {
         content
             .font(.system(size: 20, weight: .bold))
             .padding(.top, 8)
             .frame(width: 65, height: 24, alignment: .center)
     }
 }

 struct FirstView: View {
     @Environment(\.managedObjectContext) var managedObjectContext
     @Environment(\.dismiss) var dismiss
     @EnvironmentObject var SC: SettingsController
     @ObservedObject var dcm: DataCarModel
     @ObservedObject var car: Car
     @State private var tabIndex: Int? = nil
     var engvar: String { car.variant == "EV" ? " Kwh" : SC.fuelSym }
     let tabList = [
         tabBarData(lable: "List", img: "info"),
         tabBarData(lable: "Extra", img: "list.bullet"),
         tabBarData(lable: "Edit", img: "square.and.pencil"),
         tabBarData(lable: "Fuel", img: "fuelpump.circle"),
         tabBarData(lable: "Insure", img: "cross.vial"),
         tabBarData(lable: "Expense", img: "sterlingsign.circle")
     ]
     

     let columns = [GridItem(.fixed(165)), GridItem(.fixed(160))]

     var body: some View {
         let (costperDay, estAnnualDistance) = costDayMonth()
         
         NavigationView {
             VStack {
                 Text("Main View\n")
                     .bold()
                     .foregroundColor(.blue)
                     .font(.title2)
                 
                 //       MARK: Work out Cost per Day and Month
                 
                 VStack (alignment: .leading, spacing: 35) {
                     List {
                         LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3 )      {
                             
                             Text("Make/Model").gridCellColumns(2)
                             Text("\(car.make!) \(car.model!)")
                             Text("Reg Number: ").gridCellColumns(2)
                             Text("\(car.regno ?? "")")
                             Text("Starting Odometer").gridCellColumns(2)
                             Text("\(car.odometerstarting) \(SC.distSym)")
                             Text("Purchase Cost").gridCellColumns(2)
                             Text("\(SC.currSym) " + String(format: "%.0f", car.purchasecost))
                             Text("Variant").gridCellColumns(2)
                             Text("\(car.variant ?? "")")
                         }  /// LazyGrid
                         .padding(.leading,50)
                         
                         LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3)      {
                             Text("Purchase Date").gridCellColumns(2)
                             Text(LocaleFormat.aString(date: car.purchasedate ?? Date(), format: SC.settings.dates ?? "dd/MMM/yy"))
                             Text("Registered Date").gridCellColumns(2)
                             Text(LocaleFormat.aString(date: car.regdate ?? Date(), format: SC.settings.dates ?? "dd/MMM/yy"))
                             Text("MOT/DOT Date").gridCellColumns(2)
                             Text(LocaleFormat.aString(date: car.motdate ?? Date(), format: SC.settings.dates ?? "dd/MMM/yy"))
                             Text("Tax Date").gridCellColumns(2)
                             Text(LocaleFormat.aString(date: car.taxdate ?? Date(), format: SC.settings.dates ?? "dd/MMM/yy"))
                             Text("Service due Date").gridCellColumns(2)
                             Text(LocaleFormat.aString(date: car.servicedue ?? Date(), format: SC.settings.dates ?? "dd/MMM/yy"))
                             
                         }/// LazyGrid
                         .padding(.leading,50)
                         
                         LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3 )      {
                             Text("Tot Fuel/Kwh Used").gridCellColumns(2);
                             Text(" \(String(format: "%.0f", car.fuelqtytot)) \(engvar)")
                             Text("Tot Fuel/Kwh Cost").gridCellColumns(2);
                             Text("\(SC.currSym)   \(String(format: "%.0f", car.fuelcosttot))")
                             Text("Tot Insurance").gridCellColumns(2);
                             Text("\(SC.currSym)  \( car.insurancecosttot)")
                             Text("Tot Expenses").gridCellColumns(2)
                             Text("\(SC.currSym) " + String(format: "%.0f", car.expensestot))
                         }/// LazyGrid
                         .padding(.leading,50)
                         
                         LazyVGrid(columns: columns, alignment: HorizontalAlignment.leading, spacing: 3 )      {
                             Text("Fuel/Kwh Cost Daily").gridCellColumns(2)
                             Text("\(SC.currSym) " + String(format: "%.2f", costperDay))
                             Text("Fuel/Kwh Cost Monthly").gridCellColumns(2)
                             costperDay > 0 ? Text("\(SC.currSym) " + String(format: "%.0f", costperDay * 30)) : Text("\(SC.currSym) 0.00")
                             Text("Est Annual \(SC.distSym)").gridCellColumns(2);
                             Text(" \(String(format: "%.0f", estAnnualDistance)) \(SC.distSym)")
                             
                         } /// LazyGrid
                  .padding(.leading,50)
                     } // List
                   //  .font(.title3)
                     .font(.system(size: 13, weight: .semibold))
                     
                     Text("Click an Icon to View/Update Info")
                         .multilineTextAlignment(.center)
                         .frame(maxWidth: .infinity)
                         .foregroundColor(.blue)
                         .font(.body)
                         .bold()
                 } /// VStack spacing 8
                 
                 
                 HStack(spacing: -10.0) {
                     ForEach(0..<tabList.count, id: \.self) { idx in
                         NavigationLink(
                             destination: destinationView(idx),
                             label:  {
                                 VStack {
                                     Image(systemName: tabList[idx].img)
                                         .modifier(ImLabel())
                                     
                                     Text(tabList[idx].lable)
                                         .modifier(TxLabel())
                                 } /// VStack
                                 .foregroundColor(.purple)
                                 .padding(.bottom, -5)
                             } /// label
                         ) /// NavLink
                     } /// ForEach
                     
                 } /// HStack
                 .background(.thinMaterial)
                 .ignoresSafeArea(.all)
                 
                 
             } /// VStack first
             
         } /// NavView
         .navigationBarBackButtonHidden(true)
     } /// Body
    
     func destinationView(_ idx: Int ) -> some View {
             switch idx {
             case 0: return AnyView(ContentView())
             case 1: return AnyView(ExtraDetails(car: car, dcm: DataCarModel()))
             case 2: return AnyView(EditCarDetails(car: car, dcm: DataCarModel()))
             case 3: return AnyView(FuelHistoryView(car: car, dcm: dcm))
             case 4: return AnyView(InsuranceHistoryView(dcm: dcm, car: car))
             case 5: return AnyView(ExpenseHistoryView(car: car, dcm: dcm))
             default: return AnyView(EmptyView())
             }  //// Switch
     } /// func
     
     func costDayMonth() -> (costperDay:Double, estAnnualDistance: Double) {
         let (daysDiff) = Dates.dateDiff(firstdate: car.purchasedate ?? Date())
         let costperDay = car.fuelcosttot == 0.0 || daysDiff == 0 ? 0.0 : (car.fuelcosttot) / Double(daysDiff )
         let estAnnualDistance =  (Double(car.odometernow - car.odometerstarting)) / Double(daysDiff) * 365
         return (costperDay,  estAnnualDistance)
     }

 } /// Struct

 // Add this extension to erase the type of the view
 extension View {
     func eraseToAnyView() -> AnyView {
     return AnyView(self)
 }
 }

 struct tabBarData: Identifiable {
     var id = UUID()
     var lable: String
     var img: String
 }
 //


