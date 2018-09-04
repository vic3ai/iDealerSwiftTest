//
//  OrderPointLicenseListViewController.swift
//  iDealer
//
//  Created by IRS on 01/11/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import KVLoading
import SwiftyJSON

class OrderPointLicenseListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var reqOrderPointListObject = [AnyObject]()
    public var status:String!
    public var dateFrom:String!
    public var dateTo:String!
    
    @IBOutlet weak var tableViewOrderPointLicense: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewOrderPointLicense.delegate = self
        self.tableViewOrderPointLicense.dataSource = self
        let backToRegisterLicenseBarBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backFromOrderPointLicenseListView))
        KVLoading.show()
        self.navigationItem.setLeftBarButton(backToRegisterLicenseBarBtn, animated: false)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reqOrderPointListObject.removeAll()
        self.callGetOrderPointRequestWebService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backFromOrderPointLicenseListView()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    // MARK:- Web service
    
    func callGetOrderPointRequestWebService()
    {
        let loginParameters :Parameters = [
            "DeviceID":"","DealerID":DealerModel.shareInstance.dealerLoginID as String! ,"PurchaseID":DealerModel.shareInstance.dealerPurchaseID as String! ,"Status":status ,"Device_YN":false,"DateFrom":dateFrom, "DateTo":dateTo,"AllDealer_YN":false
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/GetDeviceStatus.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["AppList"] as? [[String:Any]]
                    
                    for i in 0 ..< (results?.count)!
                    {
                        self.reqOrderPointListObject.append(results?[i] as AnyObject)
                    }
                    
                    self.tableViewOrderPointLicense.reloadData()
                    KVLoading.hide()
                    
                }
                
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
        return reqOrderPointListObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = reqOrderPointListObject[indexPath.row]["CompanyName1"] as? String
        cell.detailTextLabel?.text = reqOrderPointListObject[indexPath.row]["DateTime"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let registerLicenseViewController = RegisterLicenseViewController()
        let navMainViewController: UINavigationController = UINavigationController(rootViewController: registerLicenseViewController)
        registerLicenseViewController.viewToRegisterLicense = "OrderPoint"
        //print(onlineLicenseObject)
        
        LibraryApi.shareInstance.lTCode = reqOrderPointListObject[indexPath.row]["REQ_LT_Code"] as? String
        LibraryApi.shareInstance.onlineRefCode = reqOrderPointListObject[indexPath.row]["REQ_RefCode"] as? String
        registerLicenseViewController.onlineLicenseDtlObject.append(reqOrderPointListObject[indexPath.row] as AnyObject)
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
