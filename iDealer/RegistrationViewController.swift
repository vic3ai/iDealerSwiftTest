//
//  RegistrationViewController.swift
//  iDealer
//
//  Created by IRS on 28/09/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController, DealerListViewDelegate {

    @IBOutlet weak var tableViewRegistration: UITableView!
    let disposeBag = DisposeBag();
    //var registrationArray:[String] = ["Register","Online Register", "Add On Module","OrderPoint","Re-Registration"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewRegistration.delegate = self
        //tableViewRegistration.dataSource = self
        // Do any additional setup after loading the view.
        
        self.tableViewRegistration!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let backRegistrationBarBtn = UIBarButtonItem(title: "< Main", style: UIBarButtonItemStyle.plain, target: self, action: #selector(fromRegistrationToMain));
        
        let objRegTableViewArray = Variable<[RegisterTableModel]>(RegisterMenuList.shareInstance.listData);
        
        objRegTableViewArray.asObservable().bind(to: tableViewRegistration.rx.items(cellIdentifier: "Cell")){
            _, menu , cell in
            if let cellToUse = cell as? UITableViewCell{
                cellToUse.textLabel?.text = menu.title;
            }
            }.disposed(by: disposeBag);
 
        
        tableViewRegistration.rx.modelSelected(RegisterTableModel.self).subscribe(onNext: {
            menu in
            let registerLicenseViewController = RegisterLicenseViewController()
            let navMainViewController: UINavigationController = UINavigationController(rootViewController: registerLicenseViewController)
            registerLicenseViewController.viewToRegisterLicense = "Register"
            registerLicenseViewController.testString = "fxxk uuuu"
            self.navigationController?.present(navMainViewController, animated: false, completion: nil)
        }).disposed(by: disposeBag);
        
        
        
        tableViewRegistration.rx.itemDeleted
            .subscribe(onNext: { indexPath in
                objRegTableViewArray.value.remove(at: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        
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
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get from MainModel.swift
        return RegisterMenuList.shareInstance.listData.count;
        //return registrationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        //----- mvc method------
        let cellData = RegisterMenuList.shareInstance.listData[indexPath.row];
        cell.textLabel?.text = cellData.title;
        
        //----- normal method -----
        //cell.textLabel?.text = registrationArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dataValue = RegisterMenuList.shareInstance.listData[indexPath.row];
        
        if dataValue.title == "Register" {
            
            let registerLicenseViewController = RegisterLicenseViewController()
            let navMainViewController: UINavigationController = UINavigationController(rootViewController: registerLicenseViewController)
            registerLicenseViewController.viewToRegisterLicense = "Register"
            registerLicenseViewController.testString = "fxxk uuuu"
            self.navigationController?.present(navMainViewController, animated: false, completion: nil)
 
        }
        else if dataValue.title == "Online Register"
        {
            let onlineLicenseViewController = OnlineLicenseViewController()
            let nv:UINavigationController = UINavigationController(rootViewController: onlineLicenseViewController)
            self.navigationController?.present(nv, animated: false, completion: nil)
        }
        else if dataValue.title == "OrderPoint"
        {
            let orderPointViewController = OrderPointViewController()
            let nv:UINavigationController = UINavigationController(rootViewController: orderPointViewController)
            self.navigationController?.present(nv, animated: false, completion: nil)
        }
        else if dataValue.title == "Re-Registration"
        {
            let dealerListViewController = DealerListViewController()
            dealerListViewController.delegate = self
            dealerListViewController.viewName = "ReReg"
            let nv:UINavigationController = UINavigationController(rootViewController: dealerListViewController)
            self.navigationController?.present(nv, animated: false, completion: nil)
        }
        else if dataValue.title == "Add On Module"
        {
            let addOnViewController = AddOnViewController()
            let nv:UINavigationController = UINavigationController(rootViewController: addOnViewController)
            self.navigationController?.present(nv, animated: false, completion: nil)
        }
    }
    */
    // MARK: - Delegate
    func passBackDealerInfo(PurchaseID: String, Bal: String) {
        self.navigationController?.dismiss(animated: false, completion: nil)
        let registerLicenseViewController = RegisterLicenseViewController()
        let navMainViewController: UINavigationController = UINavigationController(rootViewController: registerLicenseViewController)
        registerLicenseViewController.viewToRegisterLicense = "ReReg"
        registerLicenseViewController.dealerDealerID = PurchaseID
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

extension ViewController : UITableViewDelegate {
    //设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            return 80;
    }
}
