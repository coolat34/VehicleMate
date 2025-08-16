#  CoreDataCar
 ///   Initial Details
    
    @State private var make = ""
    @State private var model = ""
    @State private var regno = ""
    @State private var mileagestarting:Int64 = 0
    @State private var purchasecost:Double = 0.0
    @State private var purchasedate = Date()
    
    /// Fuel Details input

    @State private var fueldate = Date()
    @State private var mileagenow:Int64  = 0
    @State private var litresnow:Double = 0.0
    @State private var costperlitre:Double = 0.0
    
    /// Insurance Details
    @State private var insurancedate = Date()
    @State private var insurername = ""
    @State private var insurercontact = ""
    @State private var insurerpolicy = ""
    @State private var insurancecost:Int64 = 0
    
    /// Extra Costs
    @State private var extracosts:Double  = 0.0
    @State private var maintenancecost:Double  = 0.0
    
    /// Dates
    @State private var taxdate = Date()
    @State private var motdate = Date()
    @State private var servicedue  = ""
    @State private var regdate = Date()
    
    /// Fuel Details calculated
    @State private var gallonslast:Double = 0.0
    @State private var gallonstot:Double = 0.0
    @State private var averagempg:Double = 0.0
    @State private var costpergallon:Double = 0.0
    @State private var mileagelast:Int64 = 0
    @State private var costpermile:Double = 0.0
    @State private var dailycost:Double = 0.0
    @State private var monthlycost:Double = 0.0
    @State private var totlitres:Double = 0.0
    
    /// Extra Details
    @State private var fueltype = ""
    @State private var enginesize = ""
    @State private var vin = ""
    @State private var version = ""
    @State private var colour = ""
    @State private var tyrepressure = ""
    @State private var oiltype = ""

