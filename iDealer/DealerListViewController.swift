//
//  DealerListViewController.swift
//  iDealer
//
//  Created by IRS on 01/11/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import XLForm
import KVLoading
import RxDataSources

protocol DealerListViewDelegate:class {
    func passBackDealerInfo(PurchaseID:String, Bal:String)
}

class DealerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,XLFormRowDescriptorViewController {

    weak var delegate:DealerListViewDelegate?
    @IBOutlet weak var tableViewDealerList: UITableView!
    var dealerObject = [AnyObject]()
    var rowDescriptor: XLFormRowDescriptor?
    public var viewName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewDealerList.delegate = self
        self.tableViewDealerList.dataSource = self
        let backToRegisterLicenseBarBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backFromDealerListView))
        KVLoading.show()
        self.navigationItem.setLeftBarButton(backToRegisterLicenseBarBtn, animated: false)
        self.callDealerWebService()
        SectionModel(model: "", items: self.dealerObject);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backFromDealerListView()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
    // MARK:- Web service
    
    func callDealerWebService()
    {
        let loginParameters :Parameters = [
            "Version":"Nothing" // no need to pass parameter
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/GetAllDealerDetails.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["DealerList"] as? [[String:Any]]
                    // for loop
                    for i in 0 ..< (results?.count)!
                    {
                        self.dealerObject.append(results?[i] as AnyObject)
                    }
                    
                    //bigArray.append(sectionmodel(model, dealerObject))
                    
                }
                
                self.tableViewDealerList.reloadData()
                KVLoading.hide()
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
        return dealerObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = dealerObject[indexPath.row]["DealerName"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewName == "" {
            if let rowDescriptor = rowDescriptor {
                DealerModel.shareInstance.dealerPurchaseID = dealerObject[indexPath.row]["PurchaseID"] as? String
                rowDescriptor.value = dealerObject[indexPath.row]["DealerName"] as! String
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        else if viewName == "ReReg"
        {
            if delegate != nil {
                delegate?.passBackDealerInfo(PurchaseID: dealerObject[indexPath.row]["PurchaseID"] as! String, Bal: "0.00")
                
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
