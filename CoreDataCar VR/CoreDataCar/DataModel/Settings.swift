//
//  UserSettings.swift
//  CoreDataCar
//
//  Created by Chris Milne on 15/07/2025.
//
/*
 Currency: £ / $ etc
 Distance: Miles / Kilometers
 Volume Gas: Litres / Gallons
 Volume liquids: Pints / litres
 Pressure: psi
 Dates: DD/MMM/YY MMM/DD/YY
 EngineSize: CC / litres
*/
import CoreData
import Foundation

class SettingsController: ObservableObject {
    let container: NSPersistentContainer
    @Published var settings: UserSettings
    @Published var refreshID = UUID()  // 👈 Use this to force view update
    @Published var currSym: String = ""
    @Published var currency: String = ""
    @Published var distSym: String = ""
    @Published var fuelSym: String = ""
    @Published var liquidSym: String = ""
    @Published var pressSym: String = ""
    @Published var engSym: String = ""
    
    init() {
        container = NSPersistentContainer(name: "UserSettings")
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Core Data failed: \(error.localizedDescription)")
            }
        }
        
        // Fetch existing or create new
        let context = container.viewContext
        let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        
        if let existing = try? context.fetch(request).first {
            self.settings = existing
        } else {
            let newSettings = UserSettings(context: context)
            newSettings.currency = "GBP"
            newSettings.distance = "Miles"
            newSettings.volumeGas = "Litres"
            newSettings.volumeLiquids = "Pints"
            newSettings.pressure = "psi"
            newSettings.dates = "dd/MMM/yy"
            newSettings.enginesize = "CC"
            
            try? context.save()
            self.settings = newSettings
        }
        updateSymbols()
    }
    func updateSymbols() {
        currSym = LocaleFormat.currencyAbr(currencyCode: settings.currency ?? "£ ")
        distSym = LocaleFormat.distanceAbr(distance: settings.distance ?? " Miles")
        fuelSym = LocaleFormat.fuelAbr(volumeGas: settings.volumeGas ?? " Litrs")
        engSym = LocaleFormat.engAbr(enginesize: settings.enginesize ?? " CC")
        pressSym = LocaleFormat.pressureAbr(pressure: settings.pressure ?? " psi")
    }
    
    func save() {
        try? container.viewContext.save()
    }
}
import SwiftUI

struct SettingsOptions: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController

    // Pre-fill the state from controller.settings
       @State private var currency: String = ""
       @State private var distance: String = ""
       @State private var volumeGas: String = ""
       @State private var volumeLiquids: String = ""
       @State private var pressure: String = ""
       @State private var dates: String = ""
       @State private var enginesize: String = ""
    
    @State private var currencyAbr  = "£"
    @State private var distanceVar = ["Miles", "Kms"]
    @State private var distanceAbr  = "M"
    @State private var volumeGasVar = ["Litres", "Gallons"]
    @State private var volumeGasAbr = "Ltrs"
    @State private var volumeLiquidsVar = ["Pints", "Litres"]
    @State private var volumeLiquidsAbr = "Pints"
    @State private var pressureVar = ["psi", "bar"]
    @State private var datesVar = ["dd/MMM/yy", "MMM/dd/yy"]
    @State private var enginesizeVar = ["CC", "litres"]
    @State private var enginesizeAbr = "CC"
    @State private var showSettingsView = false
    
  
    
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Form {
                    Picker("Currency", selection: $currency) {
                        ForEach(Locale.commonISOCurrencyCodes.sorted(), id: \.self) { code in
                            Text(currencyDisplayName(code: code)).tag(code).font(.title2)
                        } /// ForEach
                    } /// Picker
                    
                    
                  Group {
                        Text("Preferred Distance Unit")
                        Picker("", selection: $distance) {
                            ForEach(distanceVar, id: \.self) { Text($0) }
                        }/// Picker
                        .pickerStyle(.segmented)
                        .frame(width: 200, height: 40)
                        
                        Text("Gas/Petrol/Diesel Unit")
                        Picker("VolumeGas", selection: $volumeGas) {
                            ForEach(volumeGasVar, id: \.self) { Text($0) }
                        }/// Picker
                        .pickerStyle(.segmented)
                        
                        Text("Date Format")
                        Picker("Dates", selection: $dates) {
                            ForEach(datesVar, id: \.self) { Text($0) }
                        }/// Picker
                        .pickerStyle(.segmented)
                        
                        Text("Tyre Pressure Unit")
                        Picker("Pressure", selection: $pressure) {
                            ForEach(pressureVar, id: \.self) { Text($0) }
                        }/// Picker
                        .pickerStyle(.segmented)
                        
                        Text("Engine Size Unit")
                        Picker("EngineSize", selection: $enginesize) {
                            ForEach(enginesizeVar, id: \.self) { Text($0) }
                        }/// Picker
                        .pickerStyle(.segmented)
                        
                 } /// Group
                 .font(.caption)
                } /// Form
                HStack {
                    Spacer()
                    Button {
                        updateSettings()
                        dismiss()
                    }   label: {
                            Text("Submit Settings")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 150, height: 30)
                             } /// Button
                    .buttonStyle(.borderedProminent)
                    Spacer()
                    Button {
                        dismiss()
                    }   label: {
                            Text("Exit")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 80, height: 30)
                             } /// Button
                    .buttonStyle(.borderedProminent)
                    Spacer()
                } /// HStack
            } /// VStack
            .font(.caption)
        } /// NavView
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let set = SC.settings
                    currency = set.currency ?? "GBP"
                    distance = set.distance ?? "Miles"
                    volumeGas = set.volumeGas ?? "Litres"
                    volumeLiquids = set.volumeLiquids ?? "Pints"
                    pressure = set.pressure ?? "psi"
                    dates = set.dates ?? "dd/MMM/yy"
                    enginesize = set.enginesize ?? "CC"
                }
        
    } /// Body
   
func updateSettings() {
    SC.settings.currency = currency
    SC.settings.distance = distance
    SC.settings.volumeGas = volumeGas
    SC.settings.volumeLiquids = volumeLiquids
    SC.settings.pressure = pressure
    SC.settings.dates = dates
    SC.settings.enginesize = enginesize;
    SC.save()
    SC.refreshID = UUID()  // 👈 Force update
    SC.updateSymbols()
    }
    func currencyDisplayName(code: String) -> String {
        let locale = Locale.current
        if let symbol = locale.currencySymbol(for: code),
           let name = locale.localizedString(forCurrencyCode: code) {
            return "\(symbol) \(name) (\(code))"
        }
        return code
    } ///func currency
    
func save(context: NSManagedObjectContext) {
    do {
        try context.save()
    } catch {
        context.rollback()
        print("Could not save Settings \(error.localizedDescription)")
    } /// func save
} /// func

} /// struct
extension Locale {
        func currencySymbol(for code: String) -> String? {
            let locale = Locale(identifier: self.identifier + "@currency=\(code)")
            return locale.currencySymbol
        }
    }


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var SC: SettingsController
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Settings View")
                    .font(.title2.bold())
                    .padding(.top)
                Form {
                    Section { Text("Settings").font(.title)
                        Text("Currency: \(SC.settings.currency ?? "")")
                        Text("Distance: \(SC.settings.distance ?? "")")
                        Text("Volume Fuel: \(SC.settings.volumeGas ?? "")")
                        Text("Volume Liquids: \(SC.settings.volumeLiquids ?? "")")
                        Text("Pressure: \(SC.settings.pressure ?? "")")
                        Text("Dates: \(SC.settings.dates ?? "")")
                        Text("Engine Size: \(SC.settings.enginesize ?? "")")
                    }

                    NavigationLink(
                        destination: SettingsOptions()

                            .navigationBarHidden(true)
                    ) {
                        CustomButton(label: "Amend Settings", width: 250, height: 30)
                    }  /// CustomButton
                    ///
                    Button(action: {
                        dismiss()
                    }) {
                        CustomButton(label: "Exit", width: 250, height: 30)
                        
                    }
                    .padding(.bottom, 20)
                }
            }
        }
                 .id(SC.refreshID)  // 👈 This causes the view to reload when updated
    }
}
#Preview {
    SettingsView()
}
