//
//  Test.swift
//  iDealer
//
//  Created by Lim Ai Zhi on 13/08/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import Foundation

class MainList {
    let listData : [MainModel];
    
    static var shareInstance = MainList();
    
    private init()
    {
        //var mainViewArray:[String] = ["Registration","Mobile Application","History","Scan Qr Code","Edit Password"];
        let list1 = MainModel(title: "Registration", no: "1");
        let list2 = MainModel(title: "Mobile Application", no: "2");
        let list3 = MainModel(title: "History", no: "3");
        let list4 = MainModel(title: "Scan Qr Code", no: "4");
        let list5 = MainModel(title: "Edit Password", no: "5");
        let listCollector = [list1, list2,list3,list4,list5];
        listData = listCollector;
    }
    
}
