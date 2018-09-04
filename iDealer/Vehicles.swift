//
//  Vehicles.swift
//  iDealer
//
//  Created by IRS on 16/01/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import UIKit

class Vehicles {
    let brandName:String;
    let modelName:String;
    let modelYear:Int;
    let powerSource:String;
    let numberOfWheels:Int;
    var testVV = "";
    
    init(brandName:String, modelName:String, modelYear:Int, powerSource:String, numberOfWheels:Int) {
        self.brandName=brandName;
        self.modelName = modelName;
        self.modelYear = modelYear;
        self.powerSource = powerSource;
        self.numberOfWheels = numberOfWheels;
    }
    
    var vehicleTitle:String
    {
        return String(format:"%d %@ %@",modelYear, brandName, modelName);
    }
    
    var vehicleDetailString:String
    {
        var details = "Basic vehicle details:\n\n"
        details += "Brand name: \(brandName)\n"
        details += "Model name: \(modelName)\n"
        details += "Model year: \(modelYear)\n"
        details += "Power source: \(powerSource)\n"
        details += "# of wheels: \(numberOfWheels)\n"
        return details
    }
    
    func goForward() -> String
    {
        return "null";
    }
    
    func goBackWard() -> String {
        return "null";
    }
    
    func stopMoving() -> String
    {
        return "null";
    }
    
    func turn(degrees:Int) -> String {
        var normalizedDegrees = degrees;
        let degreesInACircle = 360;
        
        if normalizedDegrees>degreesInACircle || normalizedDegrees < -degreesInACircle {
            normalizedDegrees = normalizedDegrees % degreesInACircle;
        }
        
        return String(format:"Turn %d degrees.",normalizedDegrees);
    }
    
    func changeGears(newGearName:String) -> String {
        return String(format:"Put %@ into %@ gear.", self.modelName, newGearName);
    }
    
    func makeNoise() -> String {
        return "null";
    }
    
}

extension Vehicles{
    var description:String{
        return vehicleTitle + "\n" + vehicleDetailString;
    }
}
