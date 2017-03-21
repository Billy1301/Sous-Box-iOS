//
//  SettingViewController.swift
//  Sous Box
//
//  Created by Billy on 3/21/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let FBloginBtn = FBSDKLoginButton()
        view.addSubview(FBloginBtn)
        
        FBloginBtn.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        FBloginBtn.delegate = self
        
    }

    
   
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("log out of fb")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("logged in success")
    }
    
}
