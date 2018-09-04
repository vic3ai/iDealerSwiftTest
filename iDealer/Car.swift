//
//  Car.swift
//  iDealer
//
//  Created by IRS on 17/01/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import UIKit

class Car: Vehicles {
    let isConvertible:Bool;
    let isHatchback:Bool;
    let hasSunRoof:Bool;
    let numberOfDoors:Int;
    
    var ddd:String
    {
        return "dddd";
    }
    
    init(brandName: String, modelName: String, modelYear: Int, powerSource: String,
                  isConvertible: Bool, isHatchback: Bool, hasSunroof: Bool, numberOfDoors: Int) {
        self.isConvertible = isConvertible;
        self.isHatchback = isHatchback;
        self.hasSunRoof = hasSunroof;
        self.numberOfDoors = numberOfDoors;
        
        super.init(brandName: brandName, modelName: modelName, modelYear: modelYear, powerSource: powerSource, numberOfWheels: 4);
    }
    
    
    
    override var vehicleDetailString: String
    {
        let basicDetail = super.vehicleDetailString;
        
        var carDetailBuilder = "\n\nCar Specific Details:\n\n";
        
        let yes = "Yes\n";
        let no = "No\n";
        
        carDetailBuilder += "Has sunroof: ";
        carDetailBuilder += hasSunRoof ? yes : no;
        
        let carDetails = basicDetail + carDetailBuilder;
        
        return carDetails;
        
    }
    
    // MARK : - Private method implementation
    private func start() -> String
    {
        return String(format:"Start power source %@",powerSource);
    }
    
    // MARK : - Super Class Overrides
    override func goForward() -> String {
        return String(format:"%@ %@ then depress gas pedal.", start(),changeGears(newGearName: "Forward"));
    }
    
    override func goBackWard() -> String {
        return String(format:"%@ %@ Check your rear view mirror. Then depress gas pedal", start(),changeGears(newGearName: "Forward"));
    }
    
    override func stopMoving() -> String {
        return String(format: "Depress brake pedal. %@", changeGears(newGearName:"Park"));
    }
    
    override func makeNoise() -> String {
        return "Beep beep!";
    }
    
    
    
}
