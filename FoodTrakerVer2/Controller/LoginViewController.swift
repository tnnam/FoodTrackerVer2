//
//  LoginViewController.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/6/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let email = UserDefaults.standard.value(forKey: "email") as? String {
            if email != "" {
                loading.startAnimating()
                self.presentLoginedInScreen()
                loading.stopAnimating()
            } else {
                containerView.isHidden = false
            }
        } else {
            containerView.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginFBAction(_ sender: UIButton) {
        containerView.isHidden = true
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error == nil {
                let fbLoginResult: FBSDKLoginManagerLoginResult = result!
                if (result?.isCancelled)! {
                    return
                }
                if fbLoginResult.grantedPermissions.contains("email") {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData() {
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    if let info = result as? DICT {
                        if let email = info["email"] as? String,
                            let name = info["name"] as? String,
                            let picture = info["picture"] as? DICT,
                            let data = picture["data"] as? DICT,
                            let url = data["url"] as? String {
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(name, forKey: "name")
                            UserDefaults.standard.set(url, forKey: "url")
                            UserDefaults.standard.set(false, forKey: "FirstLogin")
                            self.presentLoginedInScreen()
                        }
                    }
                }
            })
        }
    }
    
}

extension LoginViewController {
    func presentLoginedInScreen() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        present(tabBarController, animated: true, completion: nil)
    }

}
