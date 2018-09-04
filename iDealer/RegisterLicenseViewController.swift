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

class RegisterLicenseViewController: XLFormViewController {
    //let selectedViewController = SelectedViewController()
    public var testString:String = ""
    public var viewToRegisterLicense:String = ""
    public var onlineLicenseDtlObject = [AnyObject]()
    public var dealerDealerID:String = ""
    
    struct Location {
        let lat:Double
        let lng:Double
    }
    
    struct DeliveryRange {
        var range:Double
        let center:Location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
        
        let pizzaLoc = Location(lat: 20.000, lng: 30.000)
        let pizzaRange = DeliveryRange(range: 30.00, center: pizzaLoc)
        
        
        print(pizzaRange.range)
        print(pizzaRange.center.lat)
        
        let backRegisterLicenseBarBtn = UIBarButtonItem(title: "< Registration", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToRegistrationView))
        
        let buyLicenseBarBtn = UIBarButtonItem(title: "Buy", style: UIBarButtonItemStyle.plain, target: self, action: #selector(buyLicenseClick))
        
        self.navigationItem.setLeftBarButton(backRegisterLicenseBarBtn, animated: false)
        self.navigationItem.setRightBarButton(buyLicenseBarBtn, animated: false)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let data = LibraryApi.shareInstance.licensePrice {
            if data.characters.count > 0 {
                self.form.formRow(withTag: "Price")?.value = data
                self.tableView.reloadData()
            }
        }
        else
        {
            self.tableView.reloadData()
        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //selectedViewController.delegate = self
        
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
        if viewToRegisterLicense == "ReReg" {
            row.value = dealerDealerID
        }
        else
        {
            row.value = DealerModel.shareInstance.dealerPurchaseID! as String
        }
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
        if viewToRegisterLicense == "Online Register" {
            row.value = onlineLicenseDtlObject[0]["REQ_Comp_Name"] as! String
        }
        else if viewToRegisterLicense == "OrderPoint"
        {
            row.value = onlineLicenseDtlObject[0]["CompanyName1"] as! String
        }
        else
        {
            row.value = ""
        }
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "CustomerRegisterName", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Customer Register Name"
        row.isRequired = true
        if viewToRegisterLicense == "Online Register" {
            if let data = onlineLicenseDtlObject[0]["REQ_Comp_Name1"] as? String {
                if data.characters.count == 0 {
                    row.value = onlineLicenseDtlObject[0]["REQ_Comp_Name"] as! String
                }
                else
                {
                    row.value = onlineLicenseDtlObject[0]["REQ_Comp_Name1"] as! String
                }
            }
            else
            {
                row.value = onlineLicenseDtlObject[0]["REQ_Comp_Name"] as! String
            }
            
        }
        else if viewToRegisterLicense == "OrderPoint"
        {
            row.value = onlineLicenseDtlObject[0]["CompanyName1"] as! String
        }
        //row.addValidator(validator: XLFormValidatorProtocol)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "ProductKey", rowType: XLFormRowDescriptorTypeText)
        row.value = ""
        row.isRequired = true
        row.cellConfig["textField.placeholder"] = "Product Key"
        if viewToRegisterLicense == "Online Register" {
            row.value = onlineLicenseDtlObject[0]["REQ_Prod_Key"] as! String
        }
        else if viewToRegisterLicense == "OrderPoint"
        {
            row.value = onlineLicenseDtlObject[0]["DeviceID"] as! String
        }
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "License", rowType:XLFormRowDescriptorTypeSelectorPush)
        row.title = "License"
        row.isRequired = true
        row.action.viewControllerClass = LicenseCategoryViewController.self
        if viewToRegisterLicense == "Online Register" {
            row.value = onlineLicenseDtlObject[0]["Desc"] as! String
        }
        else if viewToRegisterLicense == "OrderPoint"
        {
            row.value = onlineLicenseDtlObject[0]["LDesc"] as! String
        }
        else
        {
            row.value = ""
        }
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Module", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Module"
        row.disabled = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Price", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Price"
        if viewToRegisterLicense == "OrderPoint"
        {
            row.value = String(onlineLicenseDtlObject[0]["Price"] as! Double)
        }
        row.disabled = true
        //row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)

        
        row = XLFormRowDescriptor(tag: "PostCode", rowType: XLFormRowDescriptorTypeText)
        row.isRequired = true
        row.cellConfig["textField.placeholder"] = "PastCode"
        if viewToRegisterLicense == "Online Register" {
            row.value = onlineLicenseDtlObject[0]["REQ_PostCode"] as! String
        }
        else if viewToRegisterLicense == "OrderPoint"
        {
            row.value = onlineLicenseDtlObject[0]["Postcode"] as! String
        }
        else
        {
            row.value = ""
        }
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Country", rowType:XLFormRowDescriptorTypeSelectorPush)
        row.title = "Country"
        row.action.viewControllerClass = SelectedViewController.self
        if viewToRegisterLicense == "Online Register" {
            row.value = onlineLicenseDtlObject[0]["REQ_Country"] as! String
        }
        else if viewToRegisterLicense == "OrderPoint"
        {
            row.value = onlineLicenseDtlObject[0]["Country"] as! String
        }
        else
        {
            row.value = ""
        }
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Branch", rowType: XLFormRowDescriptorTypeText)
        row.cellConfig["textField.placeholder"] = "Branch"
        if viewToRegisterLicense == "Online Register" {
            row.value = onlineLicenseDtlObject[0]["REQ_BranchID"] as! String
        }
        else
        {
            row.value = ""
        }
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Remark")
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "Remark", rowType:XLFormRowDescriptorTypeTextView)
        row.action.viewControllerClass = CountryViewController.self
        if viewToRegisterLicense == "Online Register" {
            row.value = "Online Request"
        }
        else
        {
            row.value = ""
        }
        section.addFormRow(row)
        
        if viewToRegisterLicense == "OrderPoint" {
            row = XLFormRowDescriptor(tag: "BtnVoid", rowType:XLFormRowDescriptorTypeButton)
            row.action.formSelector = #selector(voidReqOrderPointLicense)
            row.title = "Void"
            section.addFormRow(row)
        }
        
        
        
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
        if viewToRegisterLicense != "OrderPoint"
        {
            let array = formValidationErrors()
            for errorItem in array! {
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                if validationStatus.rowDescriptor!.tag == "CustomerName" || validationStatus.rowDescriptor!.tag == "CustomerRegisterName" || validationStatus.rowDescriptor!.tag == "ProductKey" || validationStatus.rowDescriptor!.tag == "License" || validationStatus.rowDescriptor!.tag == "PostCode" {
                    if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPath(ofFormRow: rowDescriptor), let cell = tableView.cellForRow(at: indexPath) {
                        self.highlightTheEmptyRow(cell: cell)
                    }
                }
                else {
                    //PublicFunc.Testing123(str: "dddd")
                    self.onlineOrManual()
                    
                }
            }
            
            if array?.count == 0 {
                self.onlineOrManual()
            }
        }
        else
        {
            let alert = UIAlertController(title: "Confirm ?", message: "\("Buy ")\(self.form.formRow(withTag: "License")!.value!)\(" at ")\(self.form.formRow(withTag: "Price")!.value as! String)", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: approveOrderPointRequest))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func onlineOrManual()
    {
        if viewToRegisterLicense == "Online Register"
        {
            self.lockOnlineRequestLicense(dataStatus: "Approve")
        }
        else
        {
            self.startProcessLicense()
        }

    }
    
    func startProcessLicense()
    {
        let alert = UIAlertController(title: "Confirm ?", message: "\("Buy ")\(self.form.formRow(withTag: "License")!.value!)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: webServiceCheckLicenseDtl))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        //print(self.form.formRow(withTag: "Register")!.value!)
        //print("Country : " + self.form.formRow(withTag: "Country")!.title!)
        //self.form.formRow(withTag: "PostCode")?.value = "83500"
        //self.tableView.reloadData()
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
    
    /*
    override func didSelectFormRow(_ formRow: XLFormRowDescriptor!) {
        super.didSelectFormRow(formRow)
        
        if formRow.tag == "CustomerRegisterName" {
            if (self.form.formRow(withTag: "CustomerName")?.value) != nil {
                self.form.formRow(withTag: "CustomerRegisterName")?.value = self.form.formRow(withTag: "CustomerName")?.value
            }
        }
        
        
    }
    */
    
    override func endEditing(_ rowDescriptor: XLFormRowDescriptor!) {
        if rowDescriptor.tag == "CustomerName"
        {
            self.form.formRow(withTag: "CustomerRegisterName")?.value = rowDescriptor.value
            self.tableView.reloadData()
        }
    }
 
    
    // MARK: - call web service
    func webServiceCheckLicenseDtl(action:UIAlertAction)
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
                            self.callWebServiceDeductDealerBal(status: "Manual")
                        }))
                        
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.callWebServiceDeductDealerBal(status: "Manual")
                    }
                }
                //self.tableViewFinalLicense.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callWebServiceDeductDealerBal(status:String)
    {
        
        let parameters :Parameters = [
            "DealerID" :DealerModel.shareInstance.dealerLoginID!,
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
                        LibraryApi.shareInstance.licensePrice = ""
                        if status == "Manual"
                        {
                            self.navigationController?.dismiss(animated: false, completion: nil)
                        }
                        else
                        {
                            self.changeOnlineRequestStatus(status: "COMFIRMED", approvalCode: dict.object(forKey: "strApprovalCode") as! String, regKey: dict.object(forKey: "strRegKey") as! String)
                        }
                        
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func lockOnlineRequestLicense(dataStatus:String)
    {
        let parameters :Parameters = [
            "REQ_RefCode" :LibraryApi.shareInstance.onlineRefCode! as String,
            "LoginID":DealerModel.shareInstance.dealerLoginID as String!,
            "Version":LibraryApi.shareInstance.webServiceVersion as String!
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/UpdateRequestUserLock.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        if dict.object(forKey: "Status") as? String == "DENY"
                        {
                            self.showAlertMsgBox(msg: "\("This request belong to")\(DealerModel.shareInstance.dealerLoginID))", title: "Key duplicate")
                        }
                        else
                        {
                            if dataStatus == "Approve"
                            {
                                self.callWebServiceDeductDealerBal(status: "Online")
                            }
                            else
                            {
                                self.changeOnlineRequestStatus(status: "VOID", approvalCode: "", regKey: "")
                            }
                        }
                        
                    }
                    else
                    {
                        //self.callWebServiceDeductDealerBal()
                    }
                }
                //self.tableViewFinalLicense.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func changeOnlineRequestStatus(status:String, approvalCode:String, regKey:String)
    {
        let parameters :Parameters = [
            
            "REQ_RefCode" :LibraryApi.shareInstance.onlineRefCode! as String,
            "REQ_Status" :status,
            "REQ_UserName":DealerModel.shareInstance.dealerLoginID as String!,
            "REQ_AppDateTime":PublicFunc.GetCurrentDateTime(),
            "REQ_RegKey":regKey,
            "REQ_Approval_Code":approvalCode
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/UpdateRequestStatus.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        self.navigationController?.dismiss(animated: false, completion: nil)
                    }
                    else
                    {
                        self.showAlertMsgBox(msg: dict.object(forKey: "Message") as! String, title: "Warning")
                    }
                }
                //self.tableViewFinalLicense.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func appOnlinerequest()
    {
        let parameters :Parameters = [
            
            "REQ_RefCode" :LibraryApi.shareInstance.onlineRefCode! as String,
            "REQ_Status" :"VOID",
            "REQ_UserName":DealerModel.shareInstance.dealerLoginID as String!,
            "REQ_AppDateTime":PublicFunc.GetCurrentDateTime(),
            "REQ_RegKey":"",
            "REQ_Approval_Code":""
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/UpdateRequestStatus.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        self.navigationController?.dismiss(animated: false, completion: nil)
                    }
                    else
                    {
                        self.showAlertMsgBox(msg: dict.object(forKey: "Message") as! String, title: "Warning")
                    }
                }
                //self.tableViewFinalLicense.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func approveOrderPointRequest(UIAlertAction:UIAlertAction)
    {
        let parameters :Parameters = [
            "DeviceID" :self.form.formRow(withTag: "ProductKey")!.value!,
            "OldDeviceID":"",
            "DealerID":DealerModel.shareInstance.dealerLoginID!,
            "PhoneNO":"",
            "DateTime":PublicFunc.GetCurrentDateTime(),
            "Status":"REQ",
            "LogDesc":"Approve FnB App",
            "LogStatus":"Complete Transaction",
            "AdminID":"","AdminAmt":"0"
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/RegisterDeviceLicense.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        LibraryApi.shareInstance.licensePrice = ""
                        self.navigationController?.dismiss(animated: false, completion: nil)
                        
                    }
                    else
                    {
                        self.showAlertMsgBox(msg: dict.object(forKey: "Message") as! String, title: "Warning")
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }

    }
    
    func voidReqOrderPointLicense()
    {
        let parameters :Parameters = [
            
            "DealerID":DealerModel.shareInstance.dealerLoginID!,
            "LinkID":onlineLicenseDtlObject[0]["Link_ID"] as! String,
            "Status":"VOID"
            
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/UpdateDeviceStatus.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let dict = response.result.value as? NSDictionary
                {
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        LibraryApi.shareInstance.licensePrice = ""
                        self.navigationController?.dismiss(animated: false, completion: nil)
                        
                    }
                    else
                    {
                        self.showAlertMsgBox(msg: dict.object(forKey: "Message") as! String, title: "Warning")
                    }
                }
                
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
