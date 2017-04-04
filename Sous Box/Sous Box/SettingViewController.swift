//
//  SettingViewController.swift
//  Sous Box
//
//  Created by Billy on 3/21/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class SettingViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let FBloginBtn = FBSDKLoginButton()
        facebookButton.addSubview(FBloginBtn)
        FBloginBtn.frame = CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 50)
        FBloginBtn.delegate = self
        
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("log out of fb")
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            
//        print("User: \(String(describing: user)) logged in success")
        }
    }
    
}
