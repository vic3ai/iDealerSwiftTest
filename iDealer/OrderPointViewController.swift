//
//  OrderPointViewController.swift
//  iDealer
//
//  Created by IRS on 01/11/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import XLForm

class OrderPointViewController: XLFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeForm()
        // Do any additional setup after loading the view.
        
        let btnBack = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(fromOrderPointToRegistrationView))
        
        let nextFilterOrderPointStatus = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToOrderPointRequestView))
        
        self.navigationItem.setLeftBarButton(btnBack, animated: false)
        self.navigationItem.setRightBarButton(nextFilterOrderPointStatus, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fromOrderPointToRegistrationView()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "OrderPoint")
        section = XLFormSectionDescriptor.formSection(withTitle: "")
        form.addFormSection(section)
        
        // NativeEventFormViewController
        row = XLFormRowDescriptor(tag:"OrderPointDateFrom", rowType: XLFormRowDescriptorTypeDate, title: "Date From")
        row.value = Date()
        row.isRequired = true
        //row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag:"OrderPointDateTo", rowType: XLFormRowDescriptorTypeDate, title: "Date To")
        row.value = Date()
        row.isRequired = true
        //row.cellConfig["textField.textAlignment"] =  NSTextAlignment.right.rawValue
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "OrderPointStatus", rowType:XLFormRowDescriptorTypeSelectorAlertView, title:"Status")
        row.selectorOptions = ["REQ", "PENDING", "VOID"]
        row.value = "REQ"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "OrderPointPurchaseID", rowType:XLFormRowDescriptorTypeSelectorPush)
        row.title = "Dealer ID"
        row.value = DealerModel.shareInstance.dealerPurchaseID as String!
        row.action.viewControllerClass = DealerListViewController.self
        section.addFormRow(row)
        
        self.form = form
    }
    
    func goToOrderPointRequestView()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        print(dateFormatter.string(from: self.form.formRow(withTag: "OrderPointDateTo")?.value as! Date) )
        let orderPointLicenseListViewController = OrderPointLicenseListViewController()
        let nv:UINavigationController = UINavigationController(rootViewController: orderPointLicenseListViewController)
        orderPointLicenseListViewController.status = self.form.formRow(withTag: "OrderPointStatus")?.value as! String!
        orderPointLicenseListViewController.dateTo = dateFormatter.string(from: self.form.formRow(withTag: "OrderPointDateTo")?.value as! Date)
        orderPointLicenseListViewController.dateFrom = dateFormatter.string(from: self.form.formRow(withTag: "OrderPointDateFrom")?.value as! Date)
        self.navigationController?.present(nv, animated: false, completion: nil)
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
