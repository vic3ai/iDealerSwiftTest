//
//  RegistrationViewController.swift
//  iDealer
//
//  Created by IRS on 28/09/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewRegistration: UITableView!
    var registrationArray:[String] = ["Register","Online Register", "Add On Module","OrderPoint"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRegistration.delegate = self
        tableViewRegistration.dataSource = self
        // Do any additional setup after loading the view.
        
        let backRegistrationBarBtn = UIBarButtonItem(title: "< Main", style: UIBarButtonItemStyle.plain, target: self, action: #selector(fromRegistrationToMain))
        
        self.navigationItem.setLeftBarButton(backRegistrationBarBtn, animated: false)
        
        tableViewRegistration.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - function part
    
    func fromRegistrationToMain()
    {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = registrationArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if registrationArray[indexPath.row] == "Register" {
            
            let registerLicenseViewController = RegisterLicenseViewController()
            let navMainViewController: UINavigationController = UINavigationController(rootViewController: registerLicenseViewController)
            registerLicenseViewController.testString = "fxxk uuuu"
            self.navigationController?.present(navMainViewController, animated: false, completion: nil)
 
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
