//
//  LicenseCategoryViewController.swift
//  iDealer
//
//  Created by IRS on 25/10/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import XLForm
import KVLoading

class LicenseCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FinalLicenseDelegate, XLFormRowDescriptorViewController {

    @IBOutlet weak var tableViewLicenseCategory: UITableView!
    var licenseCatObject = [AnyObject]()
    var rowDescriptor: XLFormRowDescriptor?
    var formDescriptor:XLFormDescriptor?
    var licenseCatDM:[LicenseCategoryModel] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewLicenseCategory.delegate = self
        self.tableViewLicenseCategory.dataSource = self
        let backToRegisterLicenseBarBtn = UIBarButtonItem(title: "< Registration", style: UIBarButtonItemStyle.plain, target: self, action: #selector(licenseCatgBackBtnClick))
        KVLoading.show()
        self.callGetLicenseCatWebService()
        self.navigationItem.setLeftBarButton(backToRegisterLicenseBarBtn, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func licenseCatgBackBtnClick()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Web service
    
    func callGetLicenseCatWebService()
    {
        let parameters :Parameters = [
            "DealerID" :"AZLIM",
            "LicenseType":"License"
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/LicenseCategory.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["LicenseCategoryList"] as? [[String:Any]]
                    //print(results);
                    // Category, Desc, Type, Result, Price, LTCode
                    
                    for i in 0 ..< (results?.count)!
                    {
                        print(results![i]["Result"]!);
                        
                        //self.licenseCatObject.append(results?[i] as AnyObject)
                        
                        //self.licenseCatObject.append(LicenseCategoryModel(category: results![i]["Category"] as! String, desc: results![i]["Desc"] as! String, licenseType: results![i]["Type"] as! String, result: results![i]["Result"]! as! String, price: results![i]["Price"]! as! Double, ltCode: "11111"));
                        self.licenseCatDM.append(LicenseCategoryModel(category: results![i]["Category"] as! String, desc: results![i]["Desc"] as! String, licenseType: results![i]["Type"] as! String, result: results![i]["Result"]! as! String, price: results![i]["Price"]! as! Double, ltCode: "11111"))
                        print(self.licenseCatDM[i].desc);
                    }
                    
                }
                KVLoading.hide()
                self.tableViewLicenseCategory.reloadData()
                
                //print(self.test1)
                
            case .failure(let error):
                print(error)
            }
            
            //debugPrint(response.result.value!)
        }
        
    }

    //MARK:-TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return licenseCatObject.count
        return licenseCatDM.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        //cell.textLabel?.text = licenseCatObject[indexPath.row]["Desc"] as? String
        cell.textLabel?.text = licenseCatDM[indexPath.row].desc;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let finalLicenseViewController = FinalLicenseViewController()
        finalLicenseViewController.delegate = self
        finalLicenseViewController.licenseCat = licenseCatDM[indexPath.row].category;
        self.navigationController?.pushViewController(finalLicenseViewController, animated: false)
    }
    

    // Mark: - Delegate
    func passBackFinalLicenseWithLicense(license: String, licenseCode: String, licensePrice: String) {
        if let rowDescriptor = rowDescriptor {
            rowDescriptor.value = license
            LibraryApi.shareInstance.licensePrice = licensePrice
            LibraryApi.shareInstance.lTCode = licenseCode
            _ = self.navigationController?.popViewController(animated: true)
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
