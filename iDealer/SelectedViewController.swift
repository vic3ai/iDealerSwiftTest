//
//  SelectedViewController.swift
//  iDealer
//
//  Created by IRS on 04/10/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import XLForm

//MARK: adding protocol here
protocol SelectedViewDelegate:class{
    func passBackSelectedCountry()
}

class SelectedViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,XLFormRowDescriptorViewController {
    @IBOutlet weak var tableViewSelectedItem: UITableView!
    var listArray:[[String:String]] = [[String:String]]()
    var countryObject = [AnyObject]()
    weak var delegate: SelectedViewDelegate?
    var rowDescriptor: XLFormRowDescriptor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SelectedViewController.cancelPressed(_:)))
        self.tableViewSelectedItem.delegate = self
        self.tableViewSelectedItem.dataSource = self
        let backToRegisterLicenseBarBtn = UIBarButtonItem(title: "< Registration", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToPreviewViewController))
        
        self.navigationItem.setLeftBarButton(backToRegisterLicenseBarBtn, animated: false)
        self.callCountryWebService()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToPreviewViewController()
    {
        //self.navigationController?.dismiss(animated: false, completion: nil)
        //dismiss(animated: false, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Web service
    
    func callCountryWebService()
    {
        let loginParameters :Parameters = [
            "Version" :"2017.08.16"
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/GetCountryList.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
                
            case .success:
                if let objJson = response.result.value as? [String:Any] {
                    let results = objJson["CountryList"] as? [[String:Any]]
                    
                    for i in 0 ..< (results?.count)!
                    {
                        self.countryObject.append(results?[i] as AnyObject)
                    }
                    
                    //print(results?[0]["CountryName"]! as! String)
                    
                }
                self.tableViewSelectedItem.reloadData()
                
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
        return countryObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         cell = UITableViewCell (style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
         cell.textLabel?.text = "aaa"
         */
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = countryObject[indexPath.row]["CountryName"] as? String
        //cell.detailTextLabel?.text = "bbbb 1234"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(rowDescriptor?.value(forKey: "ProductKey") ?? "sssss")
        if let rowDescriptor = rowDescriptor {
            rowDescriptor.value = countryObject[indexPath.row]["CountryName"] as! String
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

    
    func cancelPressed(_ button: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
    
}
