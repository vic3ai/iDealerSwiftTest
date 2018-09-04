//
//  SignUpMobileAppViewController.swift
//  iDealer
//
//  Created by IRS on 20/12/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import XLForm
import Alamofire

class SignUpMobileAppViewController: XLFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm();
        
        let btnSignUpMobileApp = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.plain, target: self, action: #selector(signUpMobileApp));
        self.navigationItem.setRightBarButton(btnSignUpMobileApp, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Sign Up")
        //section = XLFormSectionDescriptor.formSection()
        section = XLFormSectionDescriptor.formSection(withTitle: "Dealer Info")
        form.addFormSection(section)
        
        // NativeEventFormViewController
        row = XLFormRowDescriptor(tag:"PurchaseID", rowType: XLFormRowDescriptorTypeText, title: "Dealer ID");
        row.value = DealerModel.shareInstance.dealerPurchaseID! as String;
        row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue;
        section.addFormRow(row);
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Company Info")
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "CompanyName", rowType: XLFormRowDescriptorTypeText);
        row.cellConfig["textField.placeholder"] = "Company Name"
        row.value = "";
        row.isRequired = true;
        section.addFormRow(row);
        
        row = XLFormRowDescriptor(tag: "CompanyID", rowType: XLFormRowDescriptorTypeText);
        row.cellConfig["textField.placeholder"] = "Company ID"
        row.value = "";
        row.isRequired = true;
        section.addFormRow(row);
        
        row = XLFormRowDescriptor(tag: "CompanyPassword", rowType: XLFormRowDescriptorTypeText);
        row.cellConfig["textField.placeholder"] = "Company Password"
        row.value = "";
        row.isRequired = true;
        section.addFormRow(row);
        self.form = form
    }

    
    func signUpMobileApp()
    {
        
        let array = formValidationErrors()
        for errorItem in array! {
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
            if validationStatus.rowDescriptor!.tag == "CompanyName" || validationStatus.rowDescriptor!.tag == "CompanyPassword" || validationStatus.rowDescriptor!.tag == "CompanyID"
            {
                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPath(ofFormRow: rowDescriptor), let cell = tableView.cellForRow(at: indexPath) {
                    self.highlightTheEmptyRow(cell: cell)
                }
            }
            else {
                
                self.confirmAlertOnSignUp()
            }
        }
        
        if array?.count == 0 {
            self.confirmAlertOnSignUp()
        }
        
    }
    
    func confirmAlertOnSignUp()
    {
        let alert = UIAlertController(title: "Confirm ?", message: "Sign Up IRS account ?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: subscribeIRSProduct))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func highlightTheEmptyRow(cell:UITableViewCell)
    {
        cell.backgroundColor = .red
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            cell.backgroundColor = .white
        })
    }
    
    
    func subscribeIRSProduct(UIAlertAction:UIAlertAction)
    {
        
        let parameters :Parameters = [
            "DealerID": DealerModel.shareInstance.dealerLoginID!,"PurchaseID":self.form.formRow(withTag: "PurchaseID")!.value!,"LTCode":"", "PhoneNO":"PhoneNo","DateTime":PublicFunc.GetCurrentDateTime(),"CompanyName":self.form.formRow(withTag: "CompanyName")!.value!,"Comp_ID":self.form.formRow(withTag: "CompanyID")!.value! ,"Comp_PW":self.form.formRow(withTag: "CompanyPassword")!.value!, "LogDesc":"Complete Transaction","LogStatus":"Complete Transaction","NewCompany_YN":true,"AdminID":"","AdminAmt":"0","Status":"SIGN UP"
        ];

        
        Alamofire.request("http://idealerapsx.azurewebsites.net/IRS_Subscribe/SubscribeIRSProduct.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
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
                        //self.showAlertMsgBox(msg: dict.object(forKey: "Message") as! String!, title: "Error")
                    }
                }
                //self.tableViewFinalLicense.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
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
