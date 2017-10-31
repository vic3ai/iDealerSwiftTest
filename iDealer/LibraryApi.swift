//
//  LibraryApi.swift
//  HellowWorldSwift
//
//  Created by IRS on 29/08/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import Foundation

class LibraryApi{
    
    static var shareInstance = LibraryApi()
    
    private init()
    {
        
    }
    
    var myVariable:String?
    var purchaseID:String?
    var loginID:String?
    var lTCode:String?
    var productKey:String?
    
    var myShareArray:[[String:String]] = [[String:String]]()
    
}
