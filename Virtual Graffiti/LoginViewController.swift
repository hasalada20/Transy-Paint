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
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // deinit observers to prevent crashes
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
        UserDefaults.standard.set(newEmail!+"@transy.edu", forKey:"userEmail");
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
                
                let v = self.storyboard?.instantiateViewController(withIdentifier:"ViewController") as! ViewController
                self.navigationController!.pushViewController(v, animated: true)
            }
            else {
                dispAlert(userMessage: "Email or password incorrect. Please try again.");
            }
            
    
            
        }
        else {
            dispAlert(userMessage: "Email or password incorrect. Please try again.");
        }
        
    }
    
    // Keyboard handling
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
                view.frame.origin.y = -keyboardRect.height
        }
        else {
            view.frame.origin.y = 0
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
