//
//  PreloadingVC.swift
//  OnTheMap
//
//  Created by Ka Ho Poon on 23/1/2017.
//  Copyright © 2017 Ka Ho Poon. All rights reserved.
//

import UIKit

class PreloadingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let identity = Utility.getUsernamePassword()
        if let username = identity.username, let password = identity.password {
            APIManager.udacityLogin(username: username, password: password, completion: { (isRegistered) in
                if let result = isRegistered {
                    result ? self.initTabBarVC() : self.initLoginVC()
                } else {
                    self.initLoginVC()
                }
            })
        } else {
            initLoginVC()
        }
    }
    
    func initTabBarVC() {
        let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "tabBarVC")
        DispatchQueue.main.async {
            self.present(tabBarVC!, animated: true, completion: nil)
        }
    }
    
    func initLoginVC() {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        DispatchQueue.main.async {
            self.present(loginVC!, animated: true, completion: nil)
        }
    }

}
