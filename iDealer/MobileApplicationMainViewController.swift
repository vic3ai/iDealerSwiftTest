//
//  MobileApplicationMainViewController.swift
//  iDealer
//
//  Created by IRS on 20/12/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit

class MobileApplicationMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewMobileAppMain: UITableView!;
    var mobileAppMainViewArray:[String] = ["Sign Up","Demo","Activate","Renew","Edit Info"];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "Mobile Application";
        self.tableViewMobileAppMain.delegate = self;
        self.tableViewMobileAppMain.dataSource = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mobileAppMainViewArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "Cell");
        
        cell.textLabel?.text = mobileAppMainViewArray[indexPath.row];
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mobileAppMainViewArray[indexPath.row] == "Sign Up" {
            let signUpMobileAppViewController = SignUpMobileAppViewController(nibName: "SignUpMobileAppViewController", bundle: Bundle.main);
            self.navigationController?.pushViewController(signUpMobileAppViewController!, animated: false);
            
        }
        else if mobileAppMainViewArray[indexPath.row] == "Demo"
        {
            let alert = UIAlertController(title: "Get", message: "Demo license", preferredStyle: UIAlertControllerStyle.alert)
            let vc = MobileApplicationCustomerViewController(nibName: "MobileApplicationCustomerViewController", bundle: Bundle.main);
            // add an action (button)
            alert.addAction(UIAlertAction(title: "eMenu-Demo", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction!) in
                
                vc.licenseSelected = "eMenuDemo";
                vc.licenseCode = "1752";
                vc.licenseStatus = "DEMO";
                vc.filterLicenseStatus = "SIGN UP";
                vc.licenseDesc = "eMenu - Demo";
                vc.productName = "eMenu";
                self.navigationController?.pushViewController(vc, animated: false);
                
            }))
            
            alert.addAction(UIAlertAction(title: "MobileReport-Demo", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction!) in
                
                vc.licenseSelected = "MobileReportDemo";
                vc.licenseCode = "1637";
                vc.licenseStatus = "DEMO";
                vc.filterLicenseStatus = "SIGN UP";
                vc.licenseDesc = "Mobile Report - Demo";
                vc.productName = "MobileReport";
                self.navigationController?.pushViewController(vc, animated: false);
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else if mobileAppMainViewArray[indexPath.row] == "Activate"
        {
            let alert = UIAlertController(title: "Activate", message: "License", preferredStyle: UIAlertControllerStyle.alert)
            let vc = MobileApplicationCustomerViewController(nibName: "MobileApplicationCustomerViewController", bundle: Bundle.main);
            // add an action (button)
            alert.addAction(UIAlertAction(title: "eMenu", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction!) in
                
                vc.licenseSelected = "eMenu";
                vc.licenseCode = "1749";
                vc.licenseStatus = "ACTIVE";
                vc.filterLicenseStatus = "DEMO";
                vc.licenseDesc = "eMenu";
                vc.productName = "eMenu";
                self.navigationController?.pushViewController(vc, animated: false);
                
            }));
            
            alert.addAction(UIAlertAction(title: "MobileReport", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction!) in
                
                vc.licenseSelected = "MobileReport";
                vc.licenseCode = "1635";
                vc.licenseStatus = "ACTIVE";
                vc.filterLicenseStatus = "DEMO";
                vc.licenseDesc = "Mobile Report";
                vc.productName = "MR";
                self.navigationController?.pushViewController(vc, animated: false);
                
            }));
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else if mobileAppMainViewArray[indexPath.row] == "Renew"
        {
            let alert = UIAlertController(title: "Renew", message: "License", preferredStyle: UIAlertControllerStyle.alert)
            let vc = MobileApplicationCustomerViewController(nibName: "MobileApplicationCustomerViewController", bundle: Bundle.main);
            // add an action (button)
            alert.addAction(UIAlertAction(title: "eMenu", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction!) in
                
                vc.licenseSelected = "eMenu";
                vc.licenseCode = "1751";
                vc.licenseStatus = "Renew";
                vc.filterLicenseStatus = "ACTIVE";
                vc.licenseDesc = "eMenu - Renewal";
                vc.productName = "eMenu";
                self.navigationController?.pushViewController(vc, animated: false);
                
            }));
            
            alert.addAction(UIAlertAction(title: "MobileReport", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction!) in
                
                vc.licenseSelected = "MobileReport";
                vc.licenseCode = "1638";
                vc.licenseStatus = "Renew";
                vc.filterLicenseStatus = "ACTIVE";
                vc.licenseDesc = "Mobile Report - Renewal";
                vc.productName = "MR";
                self.navigationController?.pushViewController(vc, animated: false);
                
            }));
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        
        /*
        let registrationViewController = RegistrationViewController()
        
        let navViewController: UINavigationController = UINavigationController(rootViewController: registrationViewController)
        
        self.navigationController?.present(navViewController, animated: false, completion: nil)
         */
        
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
