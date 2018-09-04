//
//  AddOnViewController.swift
//  iDealer
//
//  Created by IRS on 03/11/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON
import KVLoading
import Alamofire

class AddOnViewController: XLFormViewController, AddOnListDelegate {
    
    public var addOnDataObject = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backFromAddOnViewController))
        
        //let buyLicenseBarBtn = UIBarButtonItem(title: "Buy", style: UIBarButtonItemStyle.plain, target: self, action: #selector(buyLicenseClick))
        
        self.navigationItem.setLeftBarButton(backBtn, animated: false)
        //self.navigationItem.setRightBarButton(buyLicenseBarBtn, animated: false)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backFromAddOnViewController()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Register")
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Dealer Info")
        form.addFormSection(section)
        
        // NativeEventFormViewController
        row = XLFormRowDescriptor(tag:"PurchaseID", rowType: XLFormRowDescriptorTypeText, title: "Dealer ID")
        row.value = DealerModel.shareInstance.dealerPurchaseID! as String
        row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Bal", rowType: XLFormRowDescriptorTypeText)
        row.value = DealerModel.shareInstance.dealerBal! as String
        row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Customer Info")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "CustomerName", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Customer Name"
        row.isRequired = true
        row.value = "LIPE THAILAND"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "CustomerRegisterName", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Customer Register Name"
        row.isRequired = true
        row.value = ""
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Country", rowType:XLFormRowDescriptorTypeSelectorPush)
        row.title = "Country"
        row.value = "Thailand"
        row.action.viewControllerClass = SelectedViewController.self
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "PostCode", rowType: XLFormRowDescriptorTypeText)
        row.isRequired = true
        row.cellConfig["textField.placeholder"] = "PastCode"
        row.value = "47000"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "OldProductKey", rowType: XLFormRowDescriptorTypeText)
        row.value = ""
        row.isRequired = true
        row.cellConfig["textField.placeholder"] = "Old Product Key"
        row.value = ""
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "OldRegisterKey", rowType:XLFormRowDescriptorTypeText)
        row.isRequired = true
        row.cellConfig["textField.placeholder"] = "Old Register Key"
        row.value = ""
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Module", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Module"
        row.disabled = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "BtnFindAddOnInfo", rowType: XLFormRowDescriptorTypeButton)
        row.title = "Find"
        row.action.formSelector = #selector(findAddOnInfo)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "BtnGoToNewAddOn", rowType: XLFormRowDescriptorTypeButton)
        row.title = "Next"
        row.action.formSelector = #selector(goToNewAddOnView)
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func endEditing(_ rowDescriptor: XLFormRowDescriptor!) {
        if rowDescriptor.tag == "OldProductKey"
        {
            callCheckModuleWithOldKey()
        }
    }
    
    //MARK: method
    func findAddOnInfo()
    {
        let addOnListViewController = AddOnListViewController()
        addOnListViewController.addOnCompanyName = self.form.formRow(withTag: "CustomerName")?.value as! String
        addOnListViewController.addOnCountry = self.form.formRow(withTag: "Country")?.value as! String
        addOnListViewController.addOnPostCode = self.form.formRow(withTag: "PostCode")?.value as! String
        addOnListViewController.delegate = self
        let nv:UINavigationController = UINavigationController(rootViewController: addOnListViewController)
        self.navigationController?.present(nv, animated: false, completion: nil)
    }
    
    func goToNewAddOnView()
    {
        
        let loginParameters :Parameters = [
            "DealerID": DealerModel.shareInstance.dealerLoginID as String!,
            "CompanyName":self.form.formRow(withTag: "CustomerName")?.value as! String,
            "Country":self.form.formRow(withTag: "Country")?.value as! String,
            "ProductKey": self.form.formRow(withTag: "OldProductKey")?.value as! String,
            "PostCode":self.form.formRow(withTag: "PostCode")?.value as! String,
            "PurchaseID": DealerModel.shareInstance.dealerPurchaseID as String!,
            "Old_ProductKey": self.form.formRow(withTag: "OldProductKey")?.value as! String,
            "Old_RegKey":self.form.formRow(withTag: "OldRegisterKey")?.value as! String
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/AddOnModule.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        let key:String = self.form.formRow(withTag: "OldProductKey")?.value as! String
                        let oldProductKeyArray = key.components(separatedBy: "-")
                        
                        let addOnNewViewController = AddOnNewViewController()
                        
                        if oldProductKeyArray[2] == "RD"
                        {
                            addOnNewViewController.addOnLicenseType = "RD"
                        }
                        else
                        {
                            addOnNewViewController.addOnLicenseType = "Other"
                            print(oldProductKeyArray[0])
                            print(oldProductKeyArray[1])
                            print(oldProductKeyArray[2])
                        }
                        
                        addOnNewViewController.preRegisterKey = "\(oldProductKeyArray[0])-\(oldProductKeyArray[1])-\(oldProductKeyArray[2])"
                        addOnNewViewController.addOnCompanyName = self.form.formRow(withTag: "CustomerName")?.value as! String
                        addOnNewViewController.addOnCompanyRegisterName = self.form.formRow(withTag: "CustomerRegisterName")?.value as! String
                        addOnNewViewController.addOnPostCode = self.form.formRow(withTag: "PostCode")?.value as! String
                        addOnNewViewController.addOnCountry = self.form.formRow(withTag: "Country")?.value as! String
                        addOnNewViewController.oldRegKey = self.form.formRow(withTag: "OldProductKey")?.value as! String
                        addOnNewViewController.oldProductKey = self.form.formRow(withTag: "OldRegisterKey")?.value as! String
                        let nv:UINavigationController = UINavigationController(rootViewController: addOnNewViewController)
                        self.navigationController?.present(nv, animated: false, completion: nil)
                        
                    }
                    else
                    {
                        //self.callWebServiceDeductDealerBal(status: "Manual")
                    }
                }
                
            case .failure(let error):
                print(error)
            }
            
            //debugPrint(response.result.value!)
        }
 
    }

    
    //MARK: delegate
    func passBackAddOnInfoData(OldProductKey: String, OldRegisterKey: String) {
        self.form.formRow(withTag: "OldProductKey")?.value = OldProductKey
        self.form.formRow(withTag: "OldRegisterKey")?.value = OldRegisterKey
        self.tableView.reloadData()
    }
    
    //MARK: Web Service
    func callCheckModuleWithOldKey()
    {
        let loginParameters :Parameters = [
            "DealerID": DealerModel.shareInstance.dealerLoginID! as String, "ProductKey": self.form.formRow(withTag: "OldProductKey")?.value as! String,"NewModule_YN": false,"Old_ProductKey": ""
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/GetModuleLicense.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                var moduleList:String = ""
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["ModuleList"] as? [[String:Any]]
                    
                    for i in 0 ..< (results?.count)!
                    {
                        if(i == 0)
                        {
                            moduleList = results?[i]["ModuleName"] as! String
                        }
                        else
                        {
                            moduleList = "\(moduleList),\(results?[i]["ModuleName"] as! String)"
                        }
                    }
                    self.form.formRow(withTag: "Module")?.value = moduleList
                    
                }
                
                self.tableView.reloadData()
                
            case .failure(let error):
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
