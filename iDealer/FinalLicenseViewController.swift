//
//  FinalLicenseViewController.swift
//  iDealer
//
//  Created by IRS on 25/10/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import KVLoading

protocol FinalLicenseDelegate:class {
    func passBackFinalLicenseWithLicense(license:String, licenseCode:String)
}

class FinalLicenseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    public var licenseCat:String = ""
    var finalLicenseObject = [AnyObject]()
    weak var delegate: FinalLicenseDelegate?
    @IBOutlet weak var tableViewFinalLicense: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableViewFinalLicense.delegate = self
        self.tableViewFinalLicense.dataSource = self
        // Do any additional setup after loading the view.
        KVLoading.show()
        self.callGetFinalLicenseCatWebService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:-TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalLicenseObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = finalLicenseObject[indexPath.row]["Desc"] as? String
        //cell.detailTextLabel?.text = "bbbb 1234"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.callCheckLicenseDtl(ltCode: finalLicenseObject[indexPath.row]["LTCode"] as! String, productKey: LibraryApi.shareInstance.productKey!)
        
        if delegate != nil {
            delegate?.passBackFinalLicenseWithLicense(license: finalLicenseObject[indexPath.row]["Desc"] as! String, licenseCode: finalLicenseObject[indexPath.row]["LTCode"] as! String)
        }
        
        _ = self.navigationController?.popViewController(animated: false)
        
    }
    
    
    // MARK:- Web service
    
    func callGetFinalLicenseCatWebService()
    {
        let parameters :Parameters = [
            "DealerID" :"AZLIM",
            "LicenseType":"License",
            "LicenseCategory":licenseCat
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/LicenseSelected.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["LicenseSelectedList"] as? [[String:Any]]
                    
                    for i in 0 ..< (results?.count)!
                    {
                        self.finalLicenseObject.append(results?[i] as AnyObject)
                    }
                    
                }
                self.tableViewFinalLicense.reloadData()
                KVLoading.hide()
                //print(self.test1)
                
            case .failure(let error):
                print(error)
            }
            
            //debugPrint(response.result.value!)
        }
        
    }
    
    func callCheckLicenseDtl(ltCode:String, productKey:String)
    {
        let parameters :Parameters = [
            "DealerID" :"AZLIM",
            "LCode":ltCode,
            "ProductKey":productKey
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/LicenseSelected.aspx", method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                /*
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["LicenseSelectedList"] as? [[String:Any]]
                    
                    for i in 0 ..< (results?.count)!
                    {
                        self.finalLicenseObject.append(results?[i] as AnyObject)
                    }
                    
                }
                self.tableViewFinalLicense.reloadData()
                */
                print(response.result.value as! String)
                
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
