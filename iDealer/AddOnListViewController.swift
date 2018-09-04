//
//  AddOnListViewController.swift
//  iDealer
//
//  Created by IRS on 03/11/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import SwiftyJSON
import KVLoading
import Alamofire
import XLForm

protocol AddOnListDelegate:class {
    func passBackAddOnInfoData(OldProductKey:String, OldRegisterKey:String)
}

class AddOnListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewAddOn: UITableView!
    var addOnObject = [AnyObject]()
    public var oldProductKey:String = ""
    public var addOnCompanyName:String = ""
    public var addOnCountry:String = ""
    public var addOnPostCode:String = ""
    weak var delegate:AddOnListDelegate?
    var rowDescriptor: XLFormRowDescriptor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewAddOn.delegate = self
        self.tableViewAddOn.dataSource = self
        let backRegisterLicenseBarBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backFromAddOnListView))
        
        self.navigationItem.setLeftBarButton(backRegisterLicenseBarBtn, animated: false)
        
        callGetAddOnInfoWebService()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backFromAddOnListView()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    

    // MARK: - Call Web Service
    func callGetAddOnInfoWebService()
    {
        let loginParameters :Parameters = [
            "CompanyName": addOnCompanyName, "Country":addOnCountry,
            "PostCode": addOnPostCode,
            "PurchaseID": DealerModel.shareInstance.dealerPurchaseID as String!
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/GetHistoryKey.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["TransactionList"] as? [[String:Any]]
                    
                    for i in 0 ..< (results?.count)!
                    {
                        self.addOnObject.append(results?[i] as AnyObject)
                    }
                    
                }
                
                self.tableViewAddOn.reloadData()
                KVLoading.hide()
                //print(self.test1)
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    //MARK:-TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addOnObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = addOnObject[indexPath.row]["ProductKey"] as? String
        cell.detailTextLabel?.text = addOnObject[indexPath.row]["RegistryKey"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.passBackAddOnInfoData(OldProductKey: addOnObject[indexPath.row]["ProductKey"] as! String, OldRegisterKey: addOnObject[indexPath.row]["RegistryKey"] as! String)
            self.navigationController?.dismiss(animated: false, completion: nil)
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
