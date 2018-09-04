//
//  Motorcycle.swift
//  iDealer
//
//  Created by IRS on 02/02/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import Foundation

class Motorcycle: Vehicles {
    let engineNoise:String;
    
    init(brandName:String, modelName:String, modelYear:Int, engineNoise:String)
    {
        self.engineNoise = engineNoise;
        
        super.init(brandName: brandName, modelName: modelName, modelYear: modelYear, powerSource: "Gas", numberOfWheels: 2);
        
    }
    
    override func goForward() -> String {
        return String(format: "%@ Open throttle.", changeGears(newGearName: "Forward"));
    }
    
    override func goBackWard() -> String {
        return String(format: "%@ Walk %@ backward using feet.", changeGears(newGearName: "Neutral"), modelName);
    }
    
    override func stopMoving() -> String {
        return "Squeeze brakes";
    }
    
    override func makeNoise() -> String {
        return self.engineNoise;
    }
    
    override var vehicleDetailString: String
    {
        let basicDetails = super.vehicleDetailString;
        
        var motorcycleBuilder = "\n\nMotorcycle-Specific\n\n";
        motorcycleBuilder += "Engine noise \(engineNoise)";
        
        let motorcycleDetails = basicDetails + motorcycleBuilder;
        
        return motorcycleDetails;
        
    }
    
}
