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

class SelectedViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,XLFormRowDescriptorViewController, UISearchResultsUpdating, UISearchBarDelegate
{
    @IBOutlet weak var tableViewSelectedItem: UITableView!
    
    //@IBOutlet weak var searchBarCountry: UISearchBar!
    var listArray:[[String:String]] = [[String:String]]()
    var countryObject = [AnyObject]()
    var countryFilterObject = [AnyObject]()
    weak var delegate: SelectedViewDelegate?
    var rowDescriptor: XLFormRowDescriptor?
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var countryDM:[CountryModel] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ttt:[CountryModel] = [];
        
        let gg = CountryModel(countryName: "aa", no:"1");
        let bb = CountryModel(countryName: "bb", no: "1");
        
        ttt.append(gg);
        ttt.append(bb);
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SelectedViewController.cancelPressed(_:)))
        self.tableViewSelectedItem.delegate = self
        self.tableViewSelectedItem.dataSource = self
        let backToRegisterLicenseBarBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToPreviewViewController))
        
        self.navigationItem.setLeftBarButton(backToRegisterLicenseBarBtn, animated: false)
        self.callCountryWebService()
        self.configureSearchController()
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
        
        DealerModel.getCountryThroughWebService(version: "2018-03-10") { data in
            self.countryDM = data;
            self.tableViewSelectedItem.reloadData();
        }
        
        
        /*
        DealerModel .getCountryThroughWebService(version: "2018-03-10") { (anyObject:[AnyObject]) in
            for i in 0 ..< anyObject.count
            {
                self.countryObject.append(anyObject[i] as AnyObject)
                let data = CountryModel(countryName: anyObject[i]["CountryName"], no: "1");
            }
            self.tableViewSelectedItem.reloadData()
        }
 */
        
        
        
        /*
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
         */
        
    }
    
    //MARK: - Search bar
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.definesPresentationContext = true
        // Place the search bar view to the tableview headerview.
        tableViewSelectedItem.tableHeaderView = searchController.searchBar
    }
 
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableViewSelectedItem.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableViewSelectedItem.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableViewSelectedItem.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        
        countryFilterObject = countryObject.filter({ (country) -> Bool in
            let countryText:NSString = country["CountryName"] as! NSString
            return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            
        })
        
        //print(countryFilterObject)
        
        // Reload the tableview.
        tableViewSelectedItem.reloadData()
    }
    
    //MARK:-TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults == true {
            return countryFilterObject.count
        }
        else
        {
            return countryDM.count;
            //return countryObject.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        if shouldShowSearchResults == true
        {
            cell.textLabel?.text = countryFilterObject[indexPath.row]["CountryName"] as? String
        }
        else
        {
            //cell.textLabel?.text = countryObject[indexPath.row]["CountryName"] as? String
            cell.textLabel?.text = countryDM[indexPath.row].countryName;
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let rowDescriptor = rowDescriptor {
            
            if shouldShowSearchResults == true {
                rowDescriptor.value = countryFilterObject[indexPath.row]["CountryName"] as! String
            }
            else
            {
                //rowDescriptor.value = countryObject[indexPath.row]["CountryName"] as! String
                rowDescriptor.value = countryDM[indexPath.row].countryName;
            }
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
