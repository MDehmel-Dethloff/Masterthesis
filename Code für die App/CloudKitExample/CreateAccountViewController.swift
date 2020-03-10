//
//  CreateAccountViewController.swift
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

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    let publicDB = CKContainer.default().publicCloudDatabase
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    let helpFunction = HilfsFunktionen()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the UI to light mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        // Fetches required Data from DB
        helpFunction.fetchData(Type: "Residents", Array: "user")
        
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
        
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
    }
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Hide keyboard when user press return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
    // Performs a Segue if this button gets clicked
    @IBAction func backAction(_ sender: UIButton) {
        userNameTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    // Performs a creat action if this button gets clicked
    @IBAction func createAction(_ sender: UIButton) {
        
        if passwordTextField.text != repeatPasswordTextField.text {
            createAlert(title: "Accounterstellung fehlgeschlagen!", message: "Bitte prüfe deine Passwörter.")
            return
        }
        if userNameTextField.text == "" || passwordTextField.text == "" || repeatPasswordTextField.text == "" {
            createAlert(title: "Accounterstellung fehlgeschlagen!", message: "Bitte fülle alle Felder aus.")
            return
        }
        let username = userNameTextField.text as NSString?

        if LoginViewController.users?.count == 0 {
        } else {
            for index in 0...LoginViewController.users!.count-1 {
                if(username == LoginViewController.users![index].value(forKey: "name") as? NSString){
                    createAlert(title: "Accounterstellung fehlgeschlagen!", message: "Der Benutzername existiert bereits.")
                    return
                }
            }
        }
        saveData()
        createAlert2(title: "Account wurde erstellt.", message: "")
    }
    // Saves the data in the DB
    func saveData() {
        
        let ResidentRecordID = CKRecord.ID(recordName: "\(userNameTextField.text!)")
        let ResidentsRecord = CKRecord(recordType: "Residents", recordID: ResidentRecordID)

        let md5Data = self.helpFunction.MD5(string: passwordTextField.text!)
        
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        
        ResidentsRecord["name"] = userNameTextField.text!
        ResidentsRecord["password"] = md5Hex
        ResidentsRecord["points"] = "0" as NSString
        ResidentsRecord["rank"] = "0" as NSString
        ResidentsRecord["wg"] = "none" as NSString
        ResidentsRecord["image"] = "defaultImage.png" as NSString
        
        publicDB.save(ResidentsRecord) { (record, error) in
            if error != nil{
                return
            } else {
                self.helpFunction.fetchData(Type: "Residents", Array: "user")
                print("hat geklappt")
            }
        }
    }
    // Creates an alert with an action
    func createAlert2(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        ))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    // Creates an alert without an action
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
}
