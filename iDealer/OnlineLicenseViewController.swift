//
//  OnlineLicenseViewController.swift
//  iDealer
//
//  Created by IRS on 30/10/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import KVLoading

class OnlineLicenseViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewOnlineLicense: UITableView!
    var onlineLicenseObject = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOnlineLicense.delegate = self
        self.tableViewOnlineLicense.dataSource = self
        
        let backOnlineLicenseBarBtn = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToMainPage))
        
        self.navigationItem.setLeftBarButton(backOnlineLicenseBarBtn, animated: false)
        
        
        print("dddd")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KVLoading.show()
        onlineLicenseObject.removeAll()
        self.callGetOnlineLicenseWebService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToMainPage()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Call web service
    func callGetOnlineLicenseWebService()
    {
        let loginParameters :Parameters = [
            "DealerID":DealerModel.shareInstance.dealerLoginID!,
            "PurchaseID":DealerModel.shareInstance.dealerPurchaseID!,
            "ReqStatus":"NEW"
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/GetRequestList.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["LicenseList"] as? [[String:Any]]
                    
                    for i in 0 ..< (results?.count)!
                    {
                        self.onlineLicenseObject.append(results?[i] as AnyObject)
                    }
                    
                    //print(results?[0]["CountryName"]! as! String)
                    
                }
                self.tableViewOnlineLicense.reloadData()
                KVLoading.hide()
                
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
        return onlineLicenseObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = onlineLicenseObject[indexPath.row]["REQ_Comp_Name"] as? String
        cell.detailTextLabel?.text = onlineLicenseObject[indexPath.row]["Price"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let registerLicenseViewController = RegisterLicenseViewController()
        let navMainViewController: UINavigationController = UINavigationController(rootViewController: registerLicenseViewController)
        registerLicenseViewController.viewToRegisterLicense = "Online Register"
        //print(onlineLicenseObject)
        
        LibraryApi.shareInstance.lTCode = onlineLicenseObject[indexPath.row]["REQ_LT_Code"] as? String
        LibraryApi.shareInstance.onlineRefCode = onlineLicenseObject[indexPath.row]["REQ_RefCode"] as? String
        registerLicenseViewController.onlineLicenseDtlObject.append(onlineLicenseObject[indexPath.row] as AnyObject)
        self.navigationController?.present(navMainViewController, animated: false, completion: nil)
        
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
