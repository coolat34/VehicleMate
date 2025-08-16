//
//  LocaleFormat.swift
//  CoreDataCar
//
//  Created by Chris Milne on 22/06/2023.
/*
 MPG  options:
 US/UK                       Miles per gallon            MPG
 US/UK                       Miles per gallon equivalent MPGe
 Europe inc Canada/ROW        Litres per 100 km        Ltr/100km
 Europe & ROW  Exc US/UK/Can Kilometres per litre    km/ltr
 Norway / Sweden             Litres per 10 km        ltr/10km
 US/UK                       Miles per kWh               MkWh
 
 MPGe calculation:
 33.7 kwh = one gallon of US gasoline
 39.6 kwh = one gallon of UK gasoline
 
     if an EV travels 100 miles on 25 kWh of electricity.
      That equates to 100 / 25 =  4 miles per kWh.
                And 100 * 25 / 33.7 = 74.18 MPGe. (US Gall)
                or 100 * 25 / 39.6 = 63.12 MPGe (Imp Gall)
 
   */

import Foundation
import SwiftUI

struct LocaleFormat {
    @EnvironmentObject var SC: SettingsController

    
    func calcTimeSince(date: Date) -> String {
        let minutes = Int(-date.timeIntervalSinceNow)/60
        let hours = minutes/60
        let days = hours/24
        
        if minutes < 120 {
            return "\(minutes) minutes ago"
        } else if minutes >= 120 && hours < 48 {
            return "\(hours) hours ago"
        }  else {
            return "\(days) days ago"
        }
    }
    
    // Use this function if you want to  apply a locale-based date format
    static func aString(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let strDate = formatter.string(from: date)
        return strDate
    }
    
    // Use this function if you want to  apply a fixed UK-based date format
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MMM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func currencyAbr(currencyCode: String) -> String {
        let locale = Locale.current
        let symbol = locale.currencySymbol(for: currencyCode)
        return symbol ?? "£ "
    }
    
    static func distanceAbr(distance: String) -> String {
        if distance == "Miles" {
            return " Miles"
        } else {
            return " Kms"
        }
    }

    func formattedDistance(_ value: Double, using unit: String) -> String {
        switch unit {
        case "Kilometers":
            return String(format: "%.1f km", value * 1.60934)
        default:
            return String(format: "%.1f miles", value)
        }
    }
   
    static func fuelType(variant: String) -> String {
        if variant == "EV" || variant == "PHEV" { return "Electric" }
        else {
            if variant == "Petrol" || variant == "Diesel" || variant == "Hybrid" { return "Fuel" }
            else { return "" }
        }
    }

    static func fuelAbr(volumeGas: String) -> String {
        if volumeGas == "Gallons" { return " Galls" }
        else {
            if volumeGas == "Litres" { return " Ltrs" } else { return "" }
        }
    }
    static func engAbr(enginesize: String) -> String {
        if enginesize == "litres" { return  " Ltrs" }
        else {
            if enginesize == "CC" { return  " CC" }
        }
            return "" }

    
    static func pressureAbr(pressure: String) -> String {
       return pressure
    }
 
}
