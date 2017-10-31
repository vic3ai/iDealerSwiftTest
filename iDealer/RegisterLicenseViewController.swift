//
//  RegisterLicenseViewController.swift
//  iDealer
//
//  Created by IRS on 28/09/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import XLForm
import Alamofire

class RegisterLicenseViewController: XLFormViewController, SelectedViewDelegate {
    //let selectedViewController = SelectedViewController()
    public var testString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(testString)
        let backRegisterLicenseBarBtn = UIBarButtonItem(title: "< Registration", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToRegistrationView))
        
        let buyLicenseBarBtn = UIBarButtonItem(title: "Buy", style: UIBarButtonItemStyle.plain, target: self, action: #selector(buyLicenseClick))
        
        self.navigationItem.setLeftBarButton(backRegisterLicenseBarBtn, animated: false)
        self.navigationItem.setRightBarButton(buyLicenseBarBtn, animated: false)
        
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate struct Tags {
        static let RealExample = "RealExamples"
        static let TextFieldAndTextView = "TextFieldAndTextView"
        static let Selectors = "Selectors"
        static let Othes = "Others"
        static let Dates = "Dates"
        static let Predicates = "BasicPredicates"
        static let BlogExample = "BlogPredicates"
        static let Multivalued = "Multivalued"
        static let MultivaluedOnlyReorder = "MultivaluedOnlyReorder"
        static let MultivaluedOnlyInsert = "MultivaluedOnlyInsert"
        static let MultivaluedOnlyDelete = "MultivaluedOnlyDelete"
        static let Validations = "Validations"
        static let UICusomization = "Customization"
        static let Custom = "Custom"
        static let AccessoryView = "Accessory View"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //selectedViewController.delegate = self
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    
    // MARK: Helpers
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Register")
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Dealer Info")
        form.addFormSection(section)
        
        // NativeEventFormViewController
        row = XLFormRowDescriptor(tag:"PurchaseID", rowType: XLFormRowDescriptorTypeText, title: "Dealer ID")
        row.value = "QOXJX"
        row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Bal", rowType: XLFormRowDescriptorTypeText)
        row.value = "1000"
        row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Customer Info")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "CustomerName", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Customer Name"
        row.isRequired = true
        //row.addValidator(validator: XLFormValidatorProtocol)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "CustomerRegisterName", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Customer Register Name"
        row.isRequired = true
        //row.addValidator(validator: XLFormValidatorProtocol)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "ProductKey", rowType: XLFormRowDescriptorTypeText)
        row.value = ""
        row.isRequired = true
        row.cellConfig["textField.placeholder"] = "Product Key"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "License", rowType:XLFormRowDescriptorTypeSelectorPush)
        row.title = "Select License"
        row.isRequired = true
        row.action.viewControllerClass = LicenseCategoryViewController.self
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Module", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Module"
        row.disabled = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "PostCode", rowType: XLFormRowDescriptorTypeText)
        row.isRequired = true
        row.cellConfig["textField.placeholder"] = "PastCode"
        row.value = ""
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Country", rowType:XLFormRowDescriptorTypeSelectorPush)
        row.title = "Country"
        row.value = "Malaysia"
        
        row.action.viewControllerClass = SelectedViewController.self
        //row.action.formSelector = #selector(markViewFlagWithViewName(stringValue:))
        
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Branch", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Branch"
        row.value = ""
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Remark")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "Remark", rowType:XLFormRowDescriptorTypeTextView)
        row.action.viewControllerClass = CountryViewController.self
        section.addFormRow(row)
        
        
        self.form = form
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - function
    
    func backToRegistrationView()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
    func buyLicenseClick()
    {
        //var results = [String:String]()
        
        let alert = UIAlertController(title: "Confirm ?", message: "\("Buy ")\(self.form.formRow(withTag: "License")!.value!)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: startProcessLicense))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
 
        //print(self.form.formRow(withTag: "Register")!.value!)
        //print("Country : " + self.form.formRow(withTag: "Country")!.title!)
        //self.form.formRow(withTag: "PostCode")?.value = "83500"
        //self.tableView.reloadData()
    }
    
    func startProcessLicense(action: UIAlertAction)
    {
        let array = formValidationErrors()
        for errorItem in array! {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
            if validationStatus.rowDescriptor!.tag == "CustomerName" || validationStatus.rowDescriptor!.tag == "ProductKey" || validationStatus.rowDescriptor!.tag == "License" || validationStatus.rowDescriptor!.tag == "PostCode" {
                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPath(ofFormRow: rowDescriptor), let cell = tableView.cellForRow(at: indexPath) {
                    self.highlightTheEmptyRow(cell: cell)
                }
            }
            else {
                //PublicFunc.Testing123(str: "dddd")
                self.webServiceCheckLicenseDtl()
                
                
            }
        }
        
        if array?.count == 0 {
            self.webServiceCheckLicenseDtl()
        }
    }
    
    func highlightTheEmptyRow(cell:UITableViewCell)
    {
        cell.backgroundColor = .red
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            cell.backgroundColor = .white
        })
    }
    
    func testtt() {
        
        let licenseCategoryViewController = LicenseCategoryViewController()
        self.navigationController?.pushViewController(licenseCategoryViewController, animated: false)
    }
    
    // MARK: - Delegate function
    
    func passBackSelectedCountry() {
        print("sssss")
    }
    
    // MARK: - call web service
    func webServiceCheckLicenseDtl()
    {
        
        if let data = self.form.formRow(withTag: "ProductKey")?.value as! String! {
            if data.characters.count != 16 {
                if (LibraryApi.shareInstance.lTCode == "1008" || LibraryApi.shareInstance.lTCode == "1066" || LibraryApi.shareInstance.lTCode == "1678" || LibraryApi.shareInstance.lTCode == "1679" || LibraryApi.shareInstance.lTCode == "1747")
                {
                    // do nothing if multi store license, xxx fnb plus standard n IRS F&B PLUS - BASIC n remote desktop
                }
                else
                {
                    self.showAlertMsgBox(msg: "Invalid product key", title: "Warning")
                    return;
                }
            }
        }
        
        if (LibraryApi.shareInstance.lTCode == "1008" || LibraryApi.shareInstance.lTCode == "1066") {
            if let data = self.form.formRow(withTag: "Branch")?.value as! String! {
                if data.characters.count == 0 {
                    self.showAlertMsgBox(msg: "Branch ID cannot empty", title: "Warning")
                    return
                }
            }
            else if let data = self.form.formRow(withTag: "ProductKey")?.value as! String! {
                if data.characters.count < 18 {
                    self.showAlertMsgBox(msg: "Invalid product key", title: "Warning")
                    return
                }
                
            }
            else if let data = self.form.formRow(withTag: "Remark")?.value as! String! {
                if data.characters.count == 0 {
                    self.showAlertMsgBox(msg: "Invalid product key", title: "Warning")
                    return
                }
                
            }
            else if self.form.formRow(withTag: "CustomerName")?.value as! String! == self.form.formRow(withTag: "Branch")?.value as! String!  {
                self.showAlertMsgBox(msg: "Company name and Branch ID cannot be same", title: "Warning")
                return
            }
            
            
        }
        
        let parameters :Parameters = [
            "DealerID" :"AZLIM",
            "LCode":LibraryApi.shareInstance.lTCode as String!,
            "ProductKey":self.form.formRow(withTag: "ProductKey")!.value!
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/GetLicenseDTL.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        self.webServiceCheckExistingRegKey()
                    }
                    else
                    {
                        self.showAlertMsgBox(msg: dict.object(forKey: "Message") as! String!, title: "Error")
                    }
                }
                //self.tableViewFinalLicense.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
 
    }
    
    func webServiceCheckExistingRegKey()
    {
        
        let parameters :Parameters = [
            "DealerID" :"AZLIM",
            "LTCode":LibraryApi.shareInstance.lTCode as String!,
            "CompanyName":self.form.formRow(withTag: "CustomerName")!.value!,
            "ProductKey":self.form.formRow(withTag: "ProductKey")!.value!,
            "PurchaseID":self.form.formRow(withTag: "PurchaseID")!.value!
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/CheckExistingRegKey.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        
                        let alert = UIAlertController(title: "Duplicate", message: "Continue ?", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                            self.callWebServiceDeductDealerBal()
                        }))
                        
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.callWebServiceDeductDealerBal()
                    }
                }
                //self.tableViewFinalLicense.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callWebServiceDeductDealerBal()
    {
        
        let parameters :Parameters = [
            "DealerID" :LibraryApi.shareInstance.loginID!,
            "LTCode":LibraryApi.shareInstance.lTCode as String!,
            "PhoneNO":"Phone No",
            "DateTime":PublicFunc.GetCurrentDateTime(),
            "CompanyName":self.form.formRow(withTag: "CustomerName")!.value!,
            "ProductKey":self.form.formRow(withTag: "ProductKey")!.value!,
            "LogDesc":"Complete Transaction",
            "LogStatus":"Complete Transaction",
            "Country":self.form.formRow(withTag: "Country")!.value!,
            "PostCode":self.form.formRow(withTag: "PostCode")!.value!,
            "PurchaseID":self.form.formRow(withTag: "PurchaseID")!.value!,
            "BranchID":self.form.formRow(withTag: "Branch")!.value ?? "",
            "AdminID":"","AdminAmt":"0","ReqRefCode":"",
            "Remark":self.form.formRow(withTag: "Remark")!.value ?? "",
            "Module_YN":false,
            "Old_ProductKey":"","Old_RegKey":"",
            "BizRegisterName":self.form.formRow(withTag: "CustomerRegisterName")!.value!
             
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
                //self.tableViewFinalLicense.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = self.form.formRow(atIndex: indexPath);
        if (row?.tag == "License") {
            print(self.form.formRow(withTag: "ProductKey")!.value!)
            //let licenseCategoryViewController = LicenseCategoryViewController()
            //self.navigationController?.pushViewController(licenseCategoryViewController, animated: false)
        }
        else {
            //tableView(tableView, didSelectRowAtIndexPath: indexPath);
        }
        //tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
