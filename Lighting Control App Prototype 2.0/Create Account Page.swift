//
//  Create Account Page.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 8/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit

class Create_Account_Page: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var newUserID: UITextField!
    @IBOutlet weak var newUserPw: UITextField!
    @IBOutlet weak var rePw: UITextField!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        newUserID.delegate = self
        newUserPw.delegate = self
        rePw.delegate = self
        let useridImage =  UIImage(named:"UserID")
        addLeftImageTo(txtField: newUserID, andImage: useridImage!)
        
        let passwordImage =  UIImage(named:"Password")
        addLeftImageTo(txtField: newUserPw, andImage: passwordImage!)
        
        let reenterpasswordImage = UIImage(named:"Password")
        addLeftImageTo(txtField: rePw, andImage: passwordImage!)
        

        // Do any additional setup after loading the view.
        var storedUserID = ["admin"]
        UserDefaults.standard.set(storedUserID, forKey: "storedUserID")
        var account_details:[String:String] = ["admin": "admin"]
        UserDefaults.standard.set(account_details, forKey: "AccountDetails")
        print(UserDefaults.standard.object(forKey: "storedUserID")!)
        print(UserDefaults.standard.object(forKey: "AccountDetails")!)
    }

    func showToast(controller:UIViewController, message:String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .red
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    
    @IBAction func create_account(_ sender: Any) {
        let userid = newUserID.text!
        let password = newUserPw.text!
        let verifypw = rePw.text!
        var storedUserID = UserDefaults.standard.object(forKey: "storedUserID") as! [String]
        if storedUserID.contains(userid) {
            let errormessage1 = "Error: UserID taken"
            showToast(controller: self, message: errormessage1 , seconds: 1)
        }
        else {
            if verifypw != password {
                let errormessage2 = "Error: Password does not match"
                showToast(controller: self, message: errormessage2, seconds: 1)
            }
            else {
                storedUserID.append(userid)
                UserDefaults.standard.set(storedUserID, forKey:"storedUserID")
                var account_details = UserDefaults.standard.object(forKey: "AccountDetails") as! [String:String]
                account_details[userid] = password
                UserDefaults.standard.set(account_details, forKey: "AccountDetails")
                performSegue(withIdentifier: "back_to_homepage", sender: self)
            }
        }
    }
        
        
        
    }
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

