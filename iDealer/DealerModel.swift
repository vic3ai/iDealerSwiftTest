//
//  DealerModel.swift
//  iDealer
//
//  Created by Lim Ai Zhi on 10/08/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import Foundation
import Alamofire

class DealerModel {
    static var shareInstance = DealerModel();
    
    var dealerPurchaseID:String?
    var dealerBal:String?
    var dealerCountry:String?
    var dealerLoginID:String?
    
    private init()
    {
        
    };
    
    class func callLoginApiWith(loginID:String, password:String, completion:@escaping (_ value:String)->Void) {
        let loginParameters :Parameters = [
            "DealerID":loginID,
            "Password":password,
            "Version" :LibraryApi.shareInstance.webServiceVersion
        ]
        
        
        
        Alamofire.request(GlobalConstants.apiURL + "DealerWebRequest/DealerLogin.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let dict = response.result.value as? NSDictionary
                {
                    
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        
                        DealerModel.shareInstance.dealerBal = String(dict.object(forKey: "Balance") as! Double)
                        DealerModel.shareInstance.dealerLoginID = dict.object(forKey: "UserName") as? String
                        DealerModel.shareInstance.dealerPurchaseID = dict.object(forKey: "PurchaseID") as? String
                        DealerModel.shareInstance.dealerCountry = dict.object(forKey: "Country") as? String
                        
                        //compl("Success");
                        completion("Success");
                        
                    }
                    else
                    {
                        
                        completion("Fail");
                        
                        
                    }
                    
                }
                
                
            case .failure(let error):
                print(error)
                completion("Fail with error : " + error.localizedDescription.description);
            }
            
            //debugPrint(response.result.value!)
        }
    }
    
    
    class func getCountryThroughWebService(version:String, completion:@escaping (_ anyObject:[CountryModel])->Void)
    {
        let loginParameters :Parameters = [
            "Version" :"2017.08.16"
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/GetCountryList.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            //var countryObject = [AnyObject]();
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["CountryList"] as? [[String:Any]]
                    var objectReturn:[CountryModel] = [];
                    for i in 0 ..< (results?.count)!
                    {
                        let data = CountryModel(countryName: results![i]["CountryName"]! as! String, no: "1");
                        //print(results![i]["CountryName"]!);
                        //countryObject.append(results?[i] as AnyObject)
                        objectReturn.append(data);
                    }
                    
                    completion(objectReturn);
                    
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    class func signIn(withUserName username:String, withPassword password:String, completion:@escaping (String)->Void){
        let delay = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            let success = String((username == "azlim") && (password == "1234"));
            
            completion(success)
        }
    }
    
}
