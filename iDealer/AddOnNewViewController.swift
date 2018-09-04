//
//  AddOnNewViewController.swift
//  iDealer
//
//  Created by IRS on 07/11/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import XLForm
import KVLoading

class AddOnNewViewController: XLFormViewController {

    public var addOnCompanyName:String = ""
    public var addOnCompanyRegisterName:String = ""
    public var addOnPostCode:String = ""
    public var addOnCountry:String = ""
    public var oldProductKey:String = ""
    public var oldRegKey:String = ""
    public var addOnLicenseType:String = ""
    public var preRegisterKey:String = ""
    var newProductKey:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backFromAddOnNewView))
        self.navigationItem.setLeftBarButton(backBtn, animated: false)
        
        initializeForm()
        // Do any additional setup after loading the view.
    }
    
    func backFromAddOnNewView()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "New Key")
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Product Key")
        form.addFormSection(section)
        
        // NativeEventFormViewController
        if addOnLicenseType == "RD"
        {
            row = XLFormRowDescriptor(tag:"NewProductKey", rowType: XLFormRowDescriptorTypeText)
            row.cellConfig["textField.placeholder"] = "New product key"
            row.isRequired = true
            row.value = ""
            row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
            section.addFormRow(row)
        }
        else
        {
            row = XLFormRowDescriptor(tag:"NewProductKey", rowType: XLFormRowDescriptorTypeText)
            row.cellConfig["textField.placeholder"] = "New product key"
            row.isRequired = true
            row.disabled = true
            row.value = preRegisterKey
            row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
            section.addFormRow(row)
            
            row = XLFormRowDescriptor(tag:"NewProductKey2", rowType: XLFormRowDescriptorTypeText)
            row.isRequired = true
            row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
            section.addFormRow(row)
        }
        
        row = XLFormRowDescriptor(tag: "Price", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Price"
        row.isRequired = true
        row.disabled = true
        row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Module", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Module"
        row.disabled = true
        row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "BtnConfirmAddOn", rowType: XLFormRowDescriptorTypeButton)
        row.title = "Confirm"
        row.action.formSelector = #selector(confirmAddOn)
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func endEditing(_ rowDescriptor: XLFormRowDescriptor!) {
        if rowDescriptor.tag == "NewProductKey2"
        {
            callCheckModuleWithOldKey()
        }
        else if rowDescriptor.tag == "NewProductKey"
        {
            callCheckModuleWithOldKey()
        }
    }

    
    func confirmAddOn()
    {
        
        if addOnLicenseType == "RD"
        {
            newProductKey = self.form.formRow(withTag: "NewProductKey")?.value as! String
        }
        else
        {
            newProductKey = "\(self.form.formRow(withTag: "NewProductKey")?.value as! String)-\(newProductKey = self.form.formRow(withTag: "NewProductKey2")?.value as! String)"
        }
        
        if newProductKey == "" {
            self.showAlertMsgBox(msg: "Product key cannot empty", title: "Warning")
            return
        }
        else if let data = self.form.formRow(withTag: "Price")?.value as! String!
        {
            if data.characters.count == 0 || data == ""  {
                self.showAlertMsgBox(msg: "Price cannot empty", title: "Warning")
                return
            }
        }
        
        let alert = UIAlertController(title: "Confirm Add On ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: callDeductDealerBalWebService))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func callDeductDealerBalWebService(uiAlert:UIAlertAction)
    {
        let parameters :Parameters = [
            "DealerID" :DealerModel.shareInstance.dealerLoginID!,
            "LTCode":"",
            "PhoneNO":"Phone No",
            "DateTime":PublicFunc.GetCurrentDateTime(),
            "CompanyName":addOnCompanyName,
            "ProductKey":newProductKey,
            "LogDesc":"Complete Transaction",
            "LogStatus":"Complete Transaction",
            "Country":addOnCountry,
            "PostCode":addOnPostCode,
            "PurchaseID":DealerModel.shareInstance.dealerPurchaseID! as  String,
            "BranchID":"",
            "AdminID":"","AdminAmt":"0","ReqRefCode":"",
            "Remark":"Add on module",
            "Module_YN":true,
            "Old_ProductKey":oldProductKey,"Old_RegKey":oldRegKey,
            "BizRegisterName":addOnCompanyRegisterName
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/DeductDealerBalance.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        self.navigationController?.dismiss(animated: false, completion: nil)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    
    //MARK: Web Service
    func callCheckModuleWithOldKey()
    {
        
        if addOnLicenseType == "RD"
        {
            newProductKey = self.form.formRow(withTag: "NewProductKey")?.value as! String
        }
        else
        {
            newProductKey = "\(self.form.formRow(withTag: "NewProductKey")?.value as! String)-\(newProductKey = self.form.formRow(withTag: "NewProductKey2")?.value as! String)"
        }
        
        let loginParameters :Parameters = [
            "DealerID": DealerModel.shareInstance.dealerLoginID! as String, "ProductKey": newProductKey,"NewModule_YN": true,"Old_ProductKey": oldProductKey
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
    
    func showAlertMsgBox(msg:String, title:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
