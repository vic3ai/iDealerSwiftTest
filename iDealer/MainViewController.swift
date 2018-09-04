//
//  MainViewController.swift
//  iDealer
//
//  Created by IRS on 28/09/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

// decalre a return closure
// format is closure's name = (return value)->void
typealias EditReturn = (_ value:String, _ value2:String)-> Void;
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let didFinishEditingPipe = Signal<String,NoError>.pipe();
    
    @IBOutlet weak var tableViewMain: UITableView!;
    var mainViewArray:[String] = ["Registration","Mobile Application","History","Scan Qr Code","Edit Password"];
    private var mainTableArray = [MainModel]();

    var name:String!;
    var number:String!;
    
    var resultReturn:EditReturn?;
    
    var didFinishEditingSignal:Signal<String,NoError>{
        return didFinishEditingPipe.output;
    }
    
    deinit {
        didFinishEditingPipe.input.sendCompleted();
    }
    
    func doneClickEvent() {
        didFinishEditingPipe.input.send(value:"from reactive cocoa");
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.doneClickEvent();
        /*
        let mainArr1 = MainModel(title: "Registration", no: "1");
        let mainArr2 = MainModel(title: "Mobile Application", no: "2");
        let mainArr3 = MainModel(title: "History", no: "2");
        let mainArr4 = MainModel(title: "Scan Qr Code", no: "2");
        let mainArr5 = MainModel(title: "Edit Password", no: "2");
        mainTableArray = [mainArr1,mainArr2,mainArr3,mainArr4,mainArr5];
        let vv = mainTableArray[0];
        print(vv.title);
         */
        mainViewArray.removeAll(keepingCapacity: true);
        
        tableViewMain.delegate = self;
        tableViewMain.dataSource = self;
        let logOutBarBtn:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnLogoutClick));
        //let navigationItem = UINavigationItem(title: "Main")
        //navigationItem.leftBarButtonItem = logOutBarBtn
        
        self.navigationItem.title = "Main";
        self.navigationItem.setLeftBarButton(logOutBarBtn, animated: false);
        tableViewMain.reloadData();
        // Do any additional setup after loading the view.
    }
    
    func setupMainTableViewArra () {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // MVC mrthod (model)
        return MainList.shareInstance.listData.count;
        
        //=---Normal method ----
        //return mainViewArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "Cell");
        
        // get data through model
        let cellData = MainList.shareInstance.listData[indexPath.row];
        cell.textLabel?.text = cellData.title;
        
        //--- Normal method ---
        //cell.textLabel?.text = mainViewArray[indexPath.row];
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //MVC method
        let dataValue = MainList.shareInstance.listData[indexPath.row];
        if dataValue.title == "Registration" {
            let registrationViewController = RegistrationViewController();
            
            let navViewController: UINavigationController = UINavigationController(rootViewController: registrationViewController);
            
            self.navigationController?.present(navViewController, animated: false, completion: nil);
        }
        else if dataValue.title == "Mobile Application"
        {
            let mobileApplicationMainViewController = MobileApplicationMainViewController(nibName:"MobileApplicationMainViewController",bundle:Bundle.main);
            self.navigationController?.pushViewController(mobileApplicationMainViewController, animated: false);
        }
        
        // mormal method
        /*
        if mainViewArray[indexPath.row] == "Registration" {
            let registrationViewController = RegistrationViewController();
            
            let navViewController: UINavigationController = UINavigationController(rootViewController: registrationViewController);
            
            self.navigationController?.present(navViewController, animated: false, completion: nil);
        }
        else if mainViewArray[indexPath.row] == "Mobile Application"
        {
            let mobileApplicationMainViewController = MobileApplicationMainViewController(nibName:"MobileApplicationMainViewController",bundle:Bundle.main);
            self.navigationController?.pushViewController(mobileApplicationMainViewController, animated: false);
        }
        */
        
        
        
    }
    
    // MARK: - function
    func btnLogoutClick()
    {
        if self.resultReturn != nil {
            self.resultReturn!("BL","012");
        }
        self.navigationController?.dismiss(animated: true, completion: nil);
    }
    
    func initResultReturn(value:String, value2:String, result:@escaping EditReturn)
    {
        name = value;
        number = value2;
        self.resultReturn = result;
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
