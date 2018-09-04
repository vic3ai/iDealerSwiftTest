//
//  LicenseCategoryModel.swift
//  iDealer
//
//  Created by Lim Ai Zhi on 03/09/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import Foundation

class LicenseCategoryModel {
    //Category, Desc, Type, Result, Price, LTCode
    var category:String = "";
    var desc:String = "";
    var licenseType:String = "";
    var result:String = "";
    var price:Double = 0.00;
    var ltCode:String = "";
    
    init(category:String, desc:String, licenseType:String, result:String, price:Double, ltCode:String) {
        self.category = category;
        self.desc = desc;
        self.licenseType = licenseType;
        self.result = result;
        self.price = price;
        self.ltCode = ltCode;
    }
    
}
