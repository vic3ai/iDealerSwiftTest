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
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError


class LoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var textLoginID: UITextField!
    @IBOutlet weak var textLoginPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad();
//        var tt = TestHardCode();
//        print(tt.string1);
        
        
        let validUserNameSignal = self.textLoginID.reactive.continuousTextValues.map {
            text in
            //print(text!);
            return self.isValidUsername(loginID: text!);
        }
        validUserNameSignal.map({
            isValidUserName in
            return isValidUserName ? UIColor.clear	: UIColor.yellow;
        }).observeValues({backgroundColor in
            self.textLoginID.backgroundColor = backgroundColor;
        });
        
        let validPasswordSignal = self.textLoginPassword.reactive.continuousTextValues.map({text in
            return self.isValidPassword(password: text!);
        });
        
        validPasswordSignal.map({
            text in
            return text ? UIColor.clear : UIColor.yellow;
        }).observeValues({text in
            self.textLoginPassword.backgroundColor = text;
        })
        
        //btnLogin.reactive.isEnabled <~ Signal.combineLatest(validPasswordSignal, validUserNameSignal).map{$0 && $1};
        self.textLoginID.autocapitalizationType = .allCharacters
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        
        
        
        self.bindViewModel();
    }
    
    func bindViewModel()
    {
        
        //初始化vm
        let viewModel = LoginVM.init(textLoginID.reactive.continuousTextValues, textLoginPassword.reactive.continuousTextValues)
        //把信号绑定给登录button
        //btnLogin.reactive.isEnabled <~ viewModel.validSignal
        //把颜色属性绑定给Textfield
        btnLogin.reactive.backgroundColor <~ viewModel.tfColor
        //通过CocoaAction实现button的点击
        
        btnLogin.reactive.pressed = CocoaAction<UIButton>(viewModel.loginAction){
            _ in
            KVLoading.show();
            return (self.textLoginID.text!, self.textLoginPassword.text!)
        }
 
        //观察登录是否成功
        viewModel.loginAction.values.observeValues({ success in
            if success == "Success" {
                //print("login : \(success)" )
                self.navigateToNextView(success: success);
                //VC跳转
            }
            else
            {
                KVLoading.hide();
            }
        })
 
    }
    
    func testazlim()
    {
        print("ffffffff");
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func someSimpleFunction(msg:String, someClosure:()->()){
        //#1
        print("function called 1");
        someClosure();
    }
    
    func blockDoubleCall()
    {
        someSimpleFunction(msg:"Hello from fxx")
        {
            // #2 from someClosure;
            print("Hello world from closure 2");
        }
    }
    
    func isValidUsername(loginID:String)->Bool
    {
        if loginID == "azlim"
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    func isValidPassword(password:String)->Bool
    {
        if password == "1234"
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    func navigateToNextView(success:String?)
    {
        if let result = success
        {
            if result == "Success"
            {
                KVLoading.hide();
                let mainViewController = MainViewController();
                // initial return closure
                mainViewController.didFinishEditingSignal.observeValues({ value in
                    print("ReactiveCocoa replace delegate - " + value);
                });
                mainViewController.initResultReturn(value: "ah lim", value2: "017", result: { (value, value2) in
                    print(value, value2);
                });
                let navMainViewController: UINavigationController = UINavigationController(rootViewController: mainViewController);
                self.navigationController?.present(navMainViewController, animated: true, completion: nil);
            }
            else if result == "Fail"
            {
                KVLoading.hide();
                let vehicleTableView = VehiclesTableViewController();
                let navMainViewController: UINavigationController = UINavigationController(rootViewController: vehicleTableView);
                self.navigationController?.present(navMainViewController, animated: true, completion: nil);
            }
            else
            {
                let controller = UIAlertController.alertControllerWithTitle(title: "Error", message: result);
                self.present(controller, animated: false, completion: nil);
            }
        }
        else
        {
            KVLoading.hide();
        }
    }
    
    /*
    @IBAction func btnLoginClick(_ sender: Any) {
        
        KVLoading.show()
        
        DealerModel.callLoginApiWith(loginID: self.textLoginID.text!, password: self.textLoginPassword.text!, completion: { (value:String?) in
            
            if let result = value
            {
                if result == "Success"
                {
                    KVLoading.hide();
                    let mainViewController = MainViewController();
                    // initial return closure
                    mainViewController.initResultReturn(value: "ah lim", value2: "017", result: { (value, value2) in
                        print(value, value2);
                    });
                    let navMainViewController: UINavigationController = UINavigationController(rootViewController: mainViewController);
                    self.navigationController?.present(navMainViewController, animated: true, completion: nil);
                }
                else if result == "Fail"
                {
                    KVLoading.hide();
                    let vehicleTableView = VehiclesTableViewController();
                    let navMainViewController: UINavigationController = UINavigationController(rootViewController: vehicleTableView);
                    self.navigationController?.present(navMainViewController, animated: true, completion: nil);
                }
                else
                {
                    let controller = UIAlertController.alertControllerWithTitle(title: "Error", message: result);
                    self.present(controller, animated: false, completion: nil);
                }
            }
        });
 
    }
    */
    func testSwiftClosure()
    {
        let simpleClosure:(String)->(String) = {name in
            let greeting = "Hello " + name;
            return greeting;
        };
        
        let result = simpleClosure("mamak");
        print(result);
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /* uses reactive signal to bine button touchUpInside event
     let signInSignal = btnLogin.reactive.controlEvents(.touchUpInside);
     signInSignal.observeValues {text in
     print("button click");
     }
     */
    
    /* uses reactive signal to bine button touchUpInside event plus create signal producer
     btnLogin.reactive.controlEvents(.touchUpInside).flatMap(.latest){_ in
     self.createSignInSignalProducer();
     }.observeValues({
     success in
     self.navigateToNextView(success: success);
     print("Sign In result :\(success)");
     })
     */
    
    /*
     let signUpActiveSignal = Signal.combineLatest(validUserNameSignal, validPasswordSignal);
     
     signUpActiveSignal.map({
     (validUserNameSignal , validPasswordSignal) in
     return validPasswordSignal && validUserNameSignal;
     }).observeValues({signUpActive in
     self.btnLogin.isEnabled = signUpActive;
     })
     */
    
    /*
     private func createSignInSignalProducer()-> SignalProducer<String, NoError>{
     let (signInSignal,observer) = Signal<String, NoError>.pipe();
     // for side effects
     let signInSignalProducer = SignalProducer<String,NoError>(signInSignal);
     
     DealerModel.callLoginApiWith(loginID: self.textLoginID.text!, password: self.textLoginPassword.text!, completion:
     {
     success in
     observer.send(value:success);
     observer.sendCompleted();
     });
     return signInSignalProducer;
     
     }
     */
    /*
     private func createSignInSignal() -> Signal<String,NoError>{
     KVLoading.show();
     let (signInSignal, observer) = Signal<String, NoError>.pipe();
     
     DealerModel.callLoginApiWith(loginID: self.textLoginID.text!, password: self.textLoginPassword.text!, completion:
     {
     success in
     observer.send(value:success);
     observer.sendCompleted();
     });
     
     //        DealerModel.signIn(withUserName: self.textLoginID.text!, withPassword: self.textLoginPassword.text!, completion: {
     //            success in
     //
     //            observer.send(value:success);
     //            observer.sendCompleted();
     //        });
     
     return signInSignal;
     
     }
     */

}
