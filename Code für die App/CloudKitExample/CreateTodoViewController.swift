//
//  CreateTodoViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 03.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import UIKit
import CloudKit

class CreateTodoViewController: UIViewController, UITextFieldDelegate {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var iconButton: UIButton!
    
    static var todoWasCreated = false
    static var imageForTodo = "todo_symbol"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.nameTextField.delegate = self
        self.pointsTextField.delegate = self
        self.descriptionTextField.delegate = self
        
        iconButton.setImage(UIImage(named: CreateTodoViewController.imageForTodo), for: .normal)
    }
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
        nameTextField.resignFirstResponder()
        pointsTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }
    @IBAction func createAction(_ sender: UIButton) {
        
        if LoginViewController.wg == "none" {
            return
        }
        if nameTextField.text == "" || pointsTextField.text == "" {
            createAlert(title: "Todoerstellung ist fehlgeschlagen!", message: "Bitte fülle alle notwendigen Felder aus.")
            return
        }
        saveData()
        CreateTodoViewController.todoWasCreated = true
        createAlert2(title: "Todo wurde erstellt", message: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        iconButton.setImage(UIImage(named: CreateTodoViewController.imageForTodo), for: .normal)
    }

    @IBAction func backAction(_ sender: UIButton) {
        nameTextField.text = ""
        pointsTextField.text = ""
        descriptionTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectIconForTodoAction(_ sender: UIButton) {
        performSegue(withIdentifier: "selectIconTodoSegue", sender: self)
    }
    
    @IBAction func selectIconForTodoAction2(_ sender: UIButton) {
        performSegue(withIdentifier: "selectIconTodoSegue", sender: self)
    }
    
    // Alert erstellen ohne Action
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    // Alert erstellen mit Action
    func createAlert2(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        ))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    // save data in QuestDB with correct wg
    func saveData() {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let QuestRecordID = CKRecord.ID(recordName: "\(nameTextField.text!)\(dateString)")
        let QuestsRecord = CKRecord(recordType: "Quests", recordID: QuestRecordID)
        var wg = ""
        
        if(LoginViewController.users?.count == 0) {   
        }else {
            for index in 0...LoginViewController.users!.count-1{
                if(LoginViewController.resident as! CKRecord.ID == LoginViewController.users![index].recordID){
                    wg = LoginViewController.wg
                }
            }
            
        }
        QuestsRecord["description"] = descriptionTextField.text
        QuestsRecord["name"] = nameTextField.text
        QuestsRecord["points"] = pointsTextField.text
        QuestsRecord["resident"] = "none"
        QuestsRecord["status"] = "nDone"
        QuestsRecord["wg"] = wg
        QuestsRecord["image"] = CreateTodoViewController.imageForTodo
        
        CreateTodoViewController.imageForTodo = "todo_symbol"
        
        LoginViewController.quests?.append(QuestsRecord)
        
        publicDB.save(QuestsRecord) { (record, error) in
            if error != nil{
                return
            } else {
                print("hat geklappt")
            }
        }
    }
}
