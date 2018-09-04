//
//  CountryModel.swift
//  iDealer
//
//  Created by Lim Ai Zhi on 23/08/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import Foundation
/*
struct CountryModel {
    var title:String?;
    var no:String?;
}
*/
class CountryModel {
    //let listData : [CountryModel];
    var countryName:String = "";
    var number:String = "";
    //static var shareInstance = CountryList();
    
    
    init(countryName:String, no:String)
    {
        self.countryName = countryName;
        self.number = no;
    }
    
}
