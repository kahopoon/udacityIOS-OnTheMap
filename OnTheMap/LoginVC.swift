//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 23/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextfield, passwordTextfield: UITextField!
    @IBOutlet weak var loginButton, sigupButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        if checkInputTextfieldValid() {
            
            DispatchQueue.main.async(execute: {
                self.uiOnHold(true)
                self.activityView.startAnimating()
            })

            APIManager.udacityLogin(username: emailTextfield.text!, password: passwordTextfield.text!, completion: { (isRegistered, expiration) in
                
                DispatchQueue.main.async(execute: {
                    self.uiOnHold(false)
                    self.activityView.stopAnimating()
                })
                
                if let result = isRegistered {
                    if result {
                        Utility.saveSession(withDateString: expiration!)
                        self.initTabBarVC()
                    } else {
                        Utility.genericAlert(title: "Warning", message: "Invalid email / password...", sender: self)
                    }
                } else {
                    Utility.genericAlert(title: "Warning", message: "Network error, please try again later...", sender: self)
                }
                
            })
            
        } else {
            Utility.genericAlert(title: "Warning", message: "Please enter email and password to contine...", sender: self)
        }
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func checkInputTextfieldValid() -> Bool {
        return !(emailTextfield.text?.isEmpty)! && !(passwordTextfield.text?.isEmpty)!
    }
    
    func uiOnHold(_ value: Bool) {
        let allUI = [emailTextfield, passwordTextfield, loginButton, sigupButton] as [UIControl]
        for ui in allUI {
            ui.isEnabled = !value
        }
    }
    
    func initTabBarVC() {
        let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
        DispatchQueue.main.async {
            self.present(tabBarVC!, animated: true, completion: nil)
        }
    }

}

