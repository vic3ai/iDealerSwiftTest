//
//  MainViewController.swift
//  iDealer
//
//  Created by IRS on 28/09/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewMain: UITableView!
    var mainViewArray:[String] = ["Registration","Mobile Application","History","Scan Qr Code","Edit Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        let logOutBarBtn:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnLogoutClick))
        //let navigationItem = UINavigationItem(title: "Main")
        //navigationItem.leftBarButtonItem = logOutBarBtn
        
        self.navigationItem.title = "Main"
        self.navigationItem.setLeftBarButton(logOutBarBtn, animated: false)
        tableViewMain.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = mainViewArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let registrationViewController = RegistrationViewController()
        
        let navViewController: UINavigationController = UINavigationController(rootViewController: registrationViewController)
        
        self.navigationController?.present(navViewController, animated: false, completion: nil)
        
    }
    
    // MARK: - function
    func btnLogoutClick()
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
