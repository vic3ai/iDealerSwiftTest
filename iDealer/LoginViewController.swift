//
//  LoginViewController.swift
//  iDealer
//
//  Created by IRS on 28/09/2017.
//  Copyright © 2017 IrsSoftware. All rights reserved.
//

import UIKit
import Alamofire
import KVLoading

class LoginViewController: UIViewController {

    @IBOutlet weak var textLoginID: UITextField!
    @IBOutlet weak var textLoginPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textLoginID.autocapitalizationType = .allCharacters
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        KVLoading.show()
        self.callLoginAspx()
        
        
    }
    
    func callLoginAspx()
    {
        
        self.textLoginID.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        let loginParameters :Parameters = [
            "DealerID":self.textLoginID.text!,
            "Password":self.textLoginPassword.text!,
            "Version" :"2017.08.16"
        ]
        
        Alamofire.request("http://irssoftware.dyndns.info/DealerWebRequest/DealerLogin.aspx", method:.post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let dict = response.result.value as? NSDictionary
                {
                    
                    if dict.object(forKey: "Result") as? String == "True"
                    {
                        KVLoading.hide()
                        LibraryApi.shareInstance.loginID = dict.object(forKey: "UserName") as? String
                        LibraryApi.shareInstance.purchaseID = dict.object(forKey: "PurchaseID") as? String
                        
                        let mainViewController = MainViewController()
                        let navMainViewController: UINavigationController = UINavigationController(rootViewController: mainViewController)
                        self.navigationController?.present(navMainViewController, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        KVLoading.hide()
                    }
                    
                }
                
                
            case .failure(let error):
                print(error)
            }
            
             //debugPrint(response.result.value!)
        }
        
        //var optionalString: String? = "Hello"
        ///optionalString = nil
        
        //var myString:String! = nil
        
        
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
