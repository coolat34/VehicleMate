//  ListView.swift


import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dcm: DataCarModel
    @EnvironmentObject var SC: SettingsController
    /// Get the car data for the main file. Use the date variable as an array and list in reverse order. Don't repeat for minor files as FetchRequest gets data for all records, not the specific record
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.purchasedate, order: .reverse)]) var car:
    FetchedResults<Car>
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {            /// WE have an UUID so do not need an initial value in the For Next Loop
                    ForEach(car) { vehicle in
                        NavigationLink (destination:
                                            
  ///  dcm: DataCarModel is passed from ContentView to FirstView with car: vehicle as the argument
                            FirstView(dcm: DataCarModel(car:vehicle), car: vehicle)
                                .environmentObject(SC)
                                .navigationBarBackButtonHidden(true)
                        ) {
                            CarRowView(car: vehicle)
                        } //3
                    } //ForEach
                    .onDelete(perform: deleteCar)
                } // List
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Exit") {
                            dismiss()
                        } ///Button
                        .buttonStyle(.borderedProminent)
                        .bold()
                    }
                        ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add Vehicle") {
                            showingAddView.toggle()
                        } /// Button
                        .buttonStyle(.borderedProminent)
                        .bold()
                    }  /// ToolbarItem
                    
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()   /// Displays an Edit button
                            .bold()
                            .foregroundColor(.white)
                            .font(Font.custom("Avenir Heavy", size: 16))
                    } /// ToolbarItem
                    
                } /// ToolBar
                .buttonStyle(.borderedProminent)
                .fullScreenCover(isPresented: $showingAddView) {
                    AddCarDetails()
                    
                } /// sheet
            } /// VStack
        } /// Nav View
    } /// Body View
    
    private func deleteCar(offsets: IndexSet)  {
        withAnimation {                          /// Need to map the Database to the current position with [$0]
            offsets.map { car[$0] }
                .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(dcm: DataCarModel())
    }
}

struct CarRowView: View {
    let car: Car
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let make = car.make {
                Text("\(make) \(car.model ?? "") \(car.regno ?? "")")
                    .bold()
                    .foregroundColor(.red)
            } else {
                Text("Empty Record")
            }
        }
    }
} /// struct

