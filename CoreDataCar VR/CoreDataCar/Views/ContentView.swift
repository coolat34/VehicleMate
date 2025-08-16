//
//  ContentView.swift
//  CoreDataCar
//
//  Created by Chris Milne on 26/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State var spin1 = false
    var animation: Animation {
        Animation.linear(duration: 4)
            .repeatForever(autoreverses: false) 
    }
    @State private var isSettings = false
    @EnvironmentObject var SC: SettingsController
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Vehicle Efficiency")
                    .foregroundColor(Color.teal)
                    .font(.system(size: 36, weight: .bold))
                    .padding()
                let interval: TimeInterval = 0.5 // seconds
                TimelineView(.periodic(from: .now, by: interval)) { context in
                    ZStack {
                        Image("80")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(spin1 ? 360 : 0))
                    }  // 1
                } // 2
                .onAppear {
                    withAnimation(animation) {
                        spin1.toggle()
                    }  // with animation
                } // on appear
                ZStack {
                    HStack {
                        Text("Build up details of your vehicle. \nIt shows all relevant dates for: \n Tax renewal \n MOT / DOT renewal \n Insurance renewal \n  Plus details of all your expenses. \n And all fuel expenditure \n See your MPG and Daily/Monthly fuel costs.")
                            .font(.system(size: 16, weight: .bold))
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 0, maxWidth: 380, minHeight: 0, maxHeight: 300)
                    } /// HStack
                } /// ZStack
           
       
                
        Button {
            isSettings.toggle()
        } label: {
            
            Image(systemName: "gear")
                .resizable()
                .frame(width: 38, height: 38)
                Text("Settings: Currency, Dates Format").font(.system(size: 14, weight: .bold))
                .frame(width: 260, height: 38)
        } /// Label
        .buttonStyle(.borderedProminent)
        
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        } /// sheet
  
             NavigationLink(destination: ListView(dcm: DataCarModel())
                .environmentObject(SC)
                   .navigationBarHidden(true)
              ) {
                 CustomButton(label: "View,Setup vehicles\n Add Fuel, Expenses, Insurance", width: 300, height: 72, isDisabled: true)
                       .padding()
              }  /// CustomButton

  
                
         }  // VStack
      } /// NavigationView
    } /// Body
}  /// Struct

#Preview {
    ContentView()
    
}
