//
//  LoginVM.swift
//  iDealer
//
//  Created by Lim Ai Zhi on 14/08/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError


class LoginVM: NSObject {
    var userNameSignal : Signal<String?, NoError>;
    var passWordSignal : Signal<String?, NoError>;
    var validSignal: Signal<Bool, NoError>;
    var tfColor:Signal<UIColor, NoError>;
    var loginAction:Action<(String, String),String, NoError>; // action <(input),output,error>
    
    
    init(_ signal1:Signal<String?, NoError>, _ signal2:Signal<String?, NoError>) {
        userNameSignal = signal1;
        passWordSignal = signal2;
        
        validSignal = Signal.combineLatest(userNameSignal, passWordSignal).map{
            $0!.count > 4 && $1!.count > 3
        };
        
        //根据合并的信号，创建控制登录按钮enable的属性
        let loginEnable = Property(initial: false, then: validSignal)
        
        //通过.map对输入框变化的信号进行映射
        let colorSignal : Signal<UIColor, NoError> = signal1.map { text in
            return (text?.count)! > 3 ? .white : .red
        }
        //根据信号创建textfield的颜色属性
        tfColor = colorSignal; //Property(initial: UIColor.white, then:Signal<UIColor, NoError>);
        
        
        loginAction = Action(enabledIf: loginEnable) {
            username, password in
            
            return SignalProducer<String, NoError> { observer, disposable in
                
                DealerModel.callLoginApiWith(loginID: username, password: password, completion:
                    {
                        success in
                        observer.send(value:success);
                        observer.sendCompleted();
                });
                
            }
        }
    }
    
}
