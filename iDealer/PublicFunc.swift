//
//  PublicFunc.swift
//  iDealer
//
//  Created by IRS on 10/10/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit

public class PublicFunc: NSObject {
    
    class func Testing123(str:String)
    {
        print("data in used")
    }
    
    class func GetCurrentDateTime() -> NSString
    {
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return("\(year)-\(month)-\(day) \(hour):\(minutes):\(seconds)" as NSString)
    }

}
