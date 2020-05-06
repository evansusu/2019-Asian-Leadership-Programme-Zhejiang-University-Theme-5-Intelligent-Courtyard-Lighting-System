//
//  ViewController.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 7/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit

class Homepage: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var UserID: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var txtuserid: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserID.delegate = self
        Password.delegate = self
        // Do any additional setup after loading the view.
        let useridImage =  UIImage(named:"UserID")
        addLeftImageTo(txtField: txtuserid, andImage: useridImage!)
        
        let passwordImage =  UIImage(named:"Password")
        addLeftImageTo(txtField: txtpassword, andImage: passwordImage!)
        
        
    }
    
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func create_button(_ sender: Any) {
        performSegue(withIdentifier: "create_account", sender: self)
    }
    
    @IBAction func Login(_ sender: Any) {
        let account_details = UserDefaults.standard.object(forKey: "AccountDetails") as? [String:String]
        let userid = UserID.text!
        let password = Password.text!
        if account_details?[userid] != nil {
            if password != account_details![userid] {
                let errormessage3 = "Invalid Password"
                showToast(controller: self, message: errormessage3, seconds: 2)
            }
            else {
                dataClass.userID = userid
                performSegue(withIdentifier: "toLightList", sender: self)
            }
        }
        else {
            let errormessage4 = "Invalid UserID"
            showToast(controller: self, message: errormessage4, seconds: 2)
        }
    }
    
    @IBAction func unwindToLoginPage(_ unwindSegue: UIStoryboardSegue) {

    }
}

