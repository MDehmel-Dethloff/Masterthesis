//
//  LoginViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 01.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit 
import CloudKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var fetchdata: [CKRecord]? = []
    let publicDB = CKContainer.default().publicCloudDatabase
    static var resident: Any = ()
    static var wg: String = ""
    static var image: String = ""
    static var residentName: String = ""
    static var pointsResident: String = "-1"
    static var rankResident: String = "0"
    static var todoCounter: String = "0"
    static var achievementCounter = "0"
    static var showTodoInfo: Bool = true
    static var users: [CKRecord]? = []
    static var quests: [CKRecord]? = []
    static var events: [CKRecord]? = []
    static var points: [CKRecord]? = []
    static var achievements: [CKRecord]? = []
    static var questsForResident: [CKRecord]? = []
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let helpFunction = HilfsFunktionen()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the UI to light mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        // Fetches required Data from DB
        helpFunction.fetchData(Type: "Residents", Array: "user")
        helpFunction.fetchData(Type: "Points", Array: "points")
        helpFunction.fetchData(Type: "Achievements", Array: "achievements")
        
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.helpFunction.fetchData(Type: "Residents", Array: "user")
        })
    }
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Hide keyboard when user press return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    // Set the Status Bar to light mode
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    // Perfoms a Segue when this button is clicked
    @IBAction func createAccountAction(_ sender: UIButton) {
        userNameTextField.text = ""
        passwordTextField.text = ""
        performSegue(withIdentifier: "übergang", sender: self)
    }
    // Performs the login action when this button is clicked
    @IBAction func loginAction(_ sender: UIButton) {
        
        let username = userNameTextField.text as NSString?
        let password = helpFunction.MD5(string: passwordTextField.text!)
        let md5Hex =  password.map { String(format: "%02hhx", $0) }.joined() as NSString
        if(LoginViewController.users!.count == 0){
            createAlert2(title: "Das Einloggen ist fehlgeschlagen!", message: "Bitte prüfe deine Eingaben.")
            return
        }
        if LoginViewController.users!.count > 0 {
            for index in 0...LoginViewController.users!.count-1{
                if(username == LoginViewController.users![index].value(forKey: "name") as? NSString && md5Hex == LoginViewController.users![index].value(forKey: "password") as? NSString){
                    LoginViewController.resident = LoginViewController.users![index].recordID
                    LoginViewController.wg = LoginViewController.users![index].value(forKey: "wg") as! String
                    LoginViewController.image = LoginViewController.users![index].value(forKey: "image") as! String
                    saveUserName()
                    userNameTextField.text = ""
                    passwordTextField.text = ""
                    LoginViewController.showTodoInfo = true
                    return
                }
            }
            createAlert2(title: "Das Einloggen ist fehlgeschlagen!", message: "Bitte prüfe deine Eingaben.")
        }
    }
    // Create an alert with an action
    func createAlert2(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        ))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    // save users name
    func saveUserName () {
        
        if(LoginViewController.users?.count == 0) {    
        } else {
            for index in 0...LoginViewController.users!.count-1 {
                if(LoginViewController.resident as! CKRecord.ID == LoginViewController.users![index].recordID) {
                    LoginViewController.residentName = LoginViewController.users![index].value(forKey: "name") as! String
                }
            }
        }
    }
}
