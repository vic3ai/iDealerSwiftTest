//
//  MobileApplicationCustomerViewController.swift
//  iDealer
//
//  Created by IRS on 21/12/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import KVLoading

class MobileApplicationCustomerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewMobileAppCustomer: UITableView!
    var mobileAppCustomerObject = [AnyObject]();
    public var licenseSelected:String = "";
    public var licenseCode:String = "";
    public var licenseStatus:String = "";
    public var licenseDesc:String = "";
    public var productName:String = "";
    public var filterLicenseStatus:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableViewMobileAppCustomer.delegate = self;
        self.tableViewMobileAppCustomer.dataSource = self;
        KVLoading.show();
        
        self.getMobileApplicationCustomerWithLicenseType(licenseStatus: filterLicenseStatus, licenseCode: licenseCode, licenseDesc: licenseDesc, productName: productName);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mobileAppCustomerObject.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell");
        
        cell.detailTextLabel?.numberOfLines = 2;
        cell.textLabel?.text = mobileAppCustomerObject[indexPath.row]["CompanyName"] as? String;
        if filterLicenseStatus == "SIGN UP" {
            cell.detailTextLabel?.text = "Verify ID: \( mobileAppCustomerObject[indexPath.row]["CompanyID"] as! String)";
        }
        else
        {
            
            cell.detailTextLabel?.text = "Verify ID: \( mobileAppCustomerObject[indexPath.row]["CompanyID"] as! String) \n Expire Date: \(mobileAppCustomerObject[indexPath.row]["CompanyExpiryDate"] as! String)";
        }
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if filterLicenseStatus == "SIGN UP" {
            
            let alert = UIAlertController(title: "Get Demo", message: "Sure to proceed ?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                action in self.getMobileApplicationLicense(companyName: (self.mobileAppCustomerObject[indexPath.row]["CompanyName"] as? String)!, companyId: (self.mobileAppCustomerObject[indexPath.row]["CompanyID"] as? String)!);
                
            }));
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil));
            
            self.present(alert, animated: true, completion: nil)
        }
        else if filterLicenseStatus == "DEMO"
        {
            let alert = UIAlertController(title: "Activate License", message: "Sure to proceed ?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                action in self.getMobileApplicationLicense(companyName: (self.mobileAppCustomerObject[indexPath.row]["CompanyName"] as? String)!, companyId: (self.mobileAppCustomerObject[indexPath.row]["CompanyID"] as? String)!);
                
            }));
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil));
            
            self.present(alert, animated: true, completion: nil)
        }
        else if filterLicenseStatus == "ACTIVE"
        {
            let alert = UIAlertController(title: "Renew License", message: "Sure to proceed ?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                action in self.getMobileApplicationLicense(companyName: (self.mobileAppCustomerObject[indexPath.row]["CompanyName"] as? String)!, companyId: (self.mobileAppCustomerObject[indexPath.row]["CompanyID"] as? String)!);
                
            }));
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil));
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Alert
    func showAlertMsgBox(msg:String, title:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Call Web Service
    func getMobileApplicationCustomerWithLicenseType(licenseStatus:String, licenseCode:String, licenseDesc:String, productName:String)
    {
        let getMobileAppCustomerListParameters :Parameters = [
            "DealerID" :DealerModel.shareInstance.dealerLoginID!,
            "LT_Code":licenseCode,
            "Status":licenseStatus
        ]
        
        Alamofire.request("http://idealerapsx.azurewebsites.net/IRS_Subscribe/GetCompanyList.aspx", method:.post, parameters: getMobileAppCustomerListParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["CompanyList"] as? [[String:Any]]
                    
                    for i in 0 ..< (results?.count)!
                    {
                        self.mobileAppCustomerObject.append(results?[i] as AnyObject)
                    }
                    //print(results?[0]["CountryName"]! as! String)
                    
                }
                KVLoading.hide();
                self.tableViewMobileAppCustomer.reloadData()
                
                //print(self.test1)
                
            case .failure(let error):
                KVLoading.hide();
                print(error)
            }
            
            //debugPrint(response.result.value!)
        }
        
    }
    
    func getMobileApplicationLicense(companyName:String, companyId:String)
    {
        let custParameters :Parameters = [
            "DealerID" :DealerModel.shareInstance.dealerLoginID!,
            "PurchaseID":DealerModel.shareInstance.dealerPurchaseID!,
            "LTCode":licenseCode,"PhoneNO":"PhoneNo","DateTime":PublicFunc.GetCurrentDateTime(),"CompanyName":companyName,"Comp_ID":companyId ,"Comp_PW":"", "LogDesc":"Complete Transaction","LogStatus":"Complete Transaction","AdminID":"","AdminAmt":"0","Status":licenseStatus
        ]
        
        Alamofire.request("http://idealerapsx.azurewebsites.net/IRS_Subscribe/SubscribeIRSProduct.aspx", method:.post, parameters: custParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        let _ = self.navigationController?.popViewController(animated: false);
                    }
                    else
                    {
                        self.showAlertMsgBox(msg: (dict.object(forKey: "Message") as? String)!, title: "Warning");
                    }
                }
                
            case .failure(let error):
                KVLoading.hide();
                print(error)
            }
            
            //debugPrint(response.result.value!)
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
