//
//  Truck.swift
//  iDealer
//
//  Created by IRS on 12/02/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import Foundation

class Truck:Vehicles
{
    let cargoCapacityCubicFeet:Int;
    
    init(brandName:String, modelName:String, modelYear:Int, powerSource:String, numberOfWheels:Int, cargoCapacityCubicFeet:Int) {
        self.cargoCapacityCubicFeet = cargoCapacityCubicFeet;
        
        super.init(brandName: brandName, modelName: modelName, modelYear: modelYear, powerSource: powerSource, numberOfWheels: numberOfWheels);
        
    }
    
    override func goForward() -> String {
        return String(format:"%@ Depress gas pedal.", changeGears(newGearName: "Drive"));
    }
    
    override func stopMoving() -> String {
        return String(format:"Depress brake pedal. %@", changeGears(newGearName: "park"));
    }
    
    override func goBackWard() -> String {
        if cargoCapacityCubicFeet > 100
        {
            return String(format:"Wait for \"%@\", then %@",soundBackupAlarm(), changeGears(newGearName: "Reverse"));
        }
        else
        {
            return String(format:"%@ depress gas pedal.", changeGears(newGearName: "Reverse"));
        }
    }
    
    override func makeNoise() -> String {
        switch numberOfWheels
        {
        case Int.min...4:
            return "Beep! Beep!";
        case 5...8:
            return "Honk !";
        default:
            return "Hooooooook !";
        }
        
    }
    
    private func soundBackupAlarm()->String
    {
        return "Beep! Beep! Beep!";
    }
    
    override var vehicleDetailString: String
    {
        let basicVehicleDetail = super.vehicleDetailString;
        
        var truckDetailsBuilder = "\n\n Truck-Specific Details: \n\n";
        truckDetailsBuilder += "Cargo Capacity: \(cargoCapacityCubicFeet) cubic feet";
        
        let truckDetails = basicVehicleDetail + truckDetailsBuilder;
        
        return truckDetails;
    }
    
}
