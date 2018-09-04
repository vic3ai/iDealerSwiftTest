//
//  RegisterMenuList.swift
//  iDealer
//
//  Created by Lim Ai Zhi on 13/08/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import Foundation

class RegisterMenuList {
    var listData = [RegisterTableModel]();
    
    static var shareInstance = RegisterMenuList();
    
    private init()
    {
        //var registrationArray:[String] = ["Register","Online Register"
        //, "Add On Module","OrderPoint","Re-Registration"]
        let list1 = RegisterTableModel(title: "Register", no: "1");
        let list2 = RegisterTableModel(title: "Online Register", no: "2");
        let list3 = RegisterTableModel(title: "Add On Module", no: "3");
        let list4 = RegisterTableModel(title: "OrderPoint", no: "4");
        let list5 = RegisterTableModel(title: "Re-Registration", no: "5");
        let listCollector = [list1,list2,list3,list4,list5];
        listData = listCollector;
        
        /*
        let list1 = RegisterMenuModel(title2: "Register", no: "1");
        let list2 = RegisterMenuModel(title2: "Online Register", no: "2");
        let list3 = RegisterMenuModel(title2: "Add On Module", no: "3");
        let list4 = RegisterMenuModel(title2: "OrderPoint", no: "4");
        let list5 = RegisterMenuModel(title2: "Re-Registration", no: "5");
        let listCollector = [list1, list2,list3,list4,list5];
        listData = listCollector;
         */
    }
    
}
