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
                    
                    for i in 0 ..< (results?.count)!
                    {
                        self.licenseCatObject.append(results?[i] as AnyObject)
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
        return licenseCatObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = licenseCatObject[indexPath.row]["Desc"] as? String
        //cell.detailTextLabel?.text = "bbbb 1234"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let finalLicenseViewController = FinalLicenseViewController()
        finalLicenseViewController.delegate = self
        finalLicenseViewController.licenseCat = (licenseCatObject[indexPath.row]["Category"] as? String)!
        self.navigationController?.pushViewController(finalLicenseViewController, animated: false)
    }

    // MArk: - Delegate
    func passBackFinalLicenseWithLicense(license: String, licenseCode: String) {
        if let rowDescriptor = rowDescriptor {
            rowDescriptor.value = license
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
