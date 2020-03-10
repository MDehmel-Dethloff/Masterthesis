//
//  NewEventViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 02.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import UIKit
import CloudKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

class NewEventViewController: UIViewController, UITextFieldDelegate {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    static var eventWasCreated = false
    static var admin = false
    static var adminNewEvent = false
    
    let helpFunction = HilfsFunktionen()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the UI to light mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        // Fetches required Data from DB
        helpFunction.fetchData(Type: "Events", Array: "events")
        
        self.eventNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
    }
    // Set the Status Bar to light mode
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Hide keyboard when user press return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
    
    // Creates a new group
    @IBAction func createAction(_ sender: UIButton) {
        
        if passwordTextField.text != repeatPasswordTextField.text {
            createAlert(title: "Account creation failed", message: "Please check your passwords")
            return
        }
        if eventNameTextField.text == "" || passwordTextField.text == "" || repeatPasswordTextField.text == "" {
            createAlert(title: "Account creation failed", message: "Please fill in all fields")
            return
        }
        let text = eventNameTextField.text?.capitalizingFirstLetter().prefix(1)
        if (text != "A" && text != "B" && text != "C" && text != "D" && text != "E" && text != "F" && text != "G" && text != "H" && text != "I" && text != "J" && text != "K" && text != "L" && text != "M" && text != "N" && text != "O" && text != "P" && text != "Q" && text != "R" && text != "S" && text != "T" && text != "U" && text != "V" && text != "W" && text != "X" && text != "Y" && text != "Z") {
            createAlert(title: "Account creation failed", message: "Event name must start with a letter")
            return
        }
        let eventName = eventNameTextField.text?.capitalizingFirstLetter() as NSString?
        
        if LoginViewController.events?.count == 0 {
            
        } else {
            for index in 0...LoginViewController.events!.count-1 {
                if(eventName == LoginViewController.events![index].value(forKey: "name") as? NSString){
                    createAlert(title: "Account creation failed", message: "Event name already exists")
                    return
                }
            }
        }
        NewEventViewController.eventWasCreated = true
        saveData()
        LoginViewController.wg = eventName! as String
        updateData()
        dismiss(animated: true, completion: nil)
        }

    // Performs a Segue if this button gets clicked
    @IBAction func backAction(_ sender: UIButton) {
        eventNameTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    // save data in EventDB
    func saveData() {
        
        let EventRecordID = CKRecord.ID(recordName: "\(eventNameTextField.text!.capitalizingFirstLetter())")
        let EventsRecord = CKRecord(recordType: "Events", recordID: EventRecordID)
        
        let md5Data = self.helpFunction.MD5(string: passwordTextField.text!)
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        
        EventsRecord["name"] = eventNameTextField.text!.capitalizingFirstLetter()
        EventsRecord["password"] = md5Hex
        EventsRecord["section"] = eventNameTextField.text!.capitalizingFirstLetter().prefix(1) as NSString
        NewEventViewController.adminNewEvent = true
        publicDB.save(EventsRecord) { (record, error) in
            if error != nil{
                return
            } else {
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
    // Update data in ResidentDB
    func updateData() {
        
        publicDB.fetch(withRecordID: LoginViewController.resident as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                
                record.setValue("\(LoginViewController.wg)", forKey: "wg")
                HomeViewController.wgHasChanged = true
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
    }
}


