//
//  LoginViewController.swift
//  Virtual Graffiti
//
//  Created by Austin Lamb on 4/5/20.
//  Copyright © 2020 hunter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var SignInEmailTextField: UITextField!
    @IBOutlet weak var SignInPasswordTextField: UITextField!
    @IBOutlet weak var CreateEmailTextField: UITextField!
    @IBOutlet weak var CreatePasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var LoginEmailTextField: UITextField!
    @IBOutlet weak var LoginPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func dispAlert(userMessage:String) {
        var alert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler:nil);
        
        alert.addAction(okAction);
        
        self.present(alert, animated: true, completion: nil);
    }
    

    @IBAction func CreateButtonClicked(_ sender: Any) {
        
        let newEmail = CreateEmailTextField.text;
        let newPass = CreatePasswordTextField.text;
        let newPassConfirm = ConfirmPasswordTextField.text;
        
        // Check for empty fields
        if(newEmail!.isEmpty || newPass!.isEmpty || newPassConfirm!.isEmpty) {
            
            dispAlert(userMessage: "Please fill out all fields.");
            return;
        }
        
        if(newPass != newPassConfirm) {
            
            dispAlert(userMessage: "Passwords do not match. Try again.");
            return;
        }
        
        // Store data: STORES LOCALLY FOR NOW
        UserDefaults.standard.set(newEmail, forKey:"userEmail");
        UserDefaults.standard.set(newPass, forKey:"userPass");
        UserDefaults.standard.synchronize();
        
        // Display alert message with confirmation
        dispAlert(userMessage: "Registration successful. Please sign in.");
        
    }
    @IBAction func SignInClicked(_ sender: Any) {
        let userEmail = LoginEmailTextField.text;
        let userPassword = LoginPasswordTextField.text;
        
        let userEmailStored = UserDefaults.standard.string(forKey: "userEmail");
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPass");
        
        if(userEmailStored == userEmail) {
            if(userPasswordStored == userPassword)
            {
                // Log in successful
                UserDefaults.standard.set(true,forKey:"isUserLoggedIn");
                UserDefaults.standard.synchronize();
                self.dismiss(animated: true,completion:nil);
            }
            else {
                dispAlert(userMessage: "Email or password incorrect. Please try again.");
            }
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
