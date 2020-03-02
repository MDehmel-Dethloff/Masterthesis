//
//  ProfilImageViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 19.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import UIKit
import CloudKit

class ProfilImageViewController: UIViewController {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    var tempID: Any = ()
    
    
    @IBAction func boy1Action(_ sender: UIButton) {
        updateData(update: "boy1.png")
        
        LoginViewController.image = "boy1.png"
        updateDataInPointsDB(update: "boy1.png")

        dismiss(animated: true, completion: nil)
    }
    @IBAction func boy2Action(_ sender: UIButton) {
        updateData(update: "boy2.png")
        updateDataInPointsDB(update: "boy2.png")
        LoginViewController.image = "boy2.png"
        dismiss(animated: true, completion: nil)
    }
    @IBAction func boy3Action(_ sender: UIButton) {
        updateData(update: "boy3.png")
        updateDataInPointsDB(update: "boy3.png")
        LoginViewController.image = "boy3.png"
        dismiss(animated: true, completion: nil)
    }
    @IBAction func boy4Action(_ sender: UIButton) {
        updateData(update: "boy4.png")
        updateDataInPointsDB(update: "boy4.png")
        LoginViewController.image = "boy4.png"
        dismiss(animated: true, completion: nil)
    }
    @IBAction func boy5Action(_ sender: UIButton) {
        updateData(update: "boy5.png")
        updateDataInPointsDB(update: "boy5.png")
        LoginViewController.image = "boy5.png"
        dismiss(animated: true, completion: nil)
    }
    @IBAction func girl1Action(_ sender: UIButton) {
        updateData(update: "girl1.png")
        updateDataInPointsDB(update: "girl1.png")
        LoginViewController.image = "girl1.png"
        dismiss(animated: true, completion: nil)
    }
    @IBAction func gril2Action(_ sender: UIButton) {
        updateData(update: "girl2.png")
        updateDataInPointsDB(update: "girl2.png")
        LoginViewController.image = "girl2.png"
        dismiss(animated: true, completion: nil)
    }
    @IBAction func girl3Action(_ sender: UIButton) {
        updateData(update: "girl3.png")
        updateDataInPointsDB(update: "girl3.png")
        LoginViewController.image = "girl3.png"
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
        self.updateProfilImageInPoints()
        })
    }
    
    // Update data in ResidentDB
    func updateData(update: String) {
        
        publicDB.fetch(withRecordID: LoginViewController.resident as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                LoginViewController.image = update
                record.setValue("\(update)", forKey: "image")
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
    }
    // Update data in PointsDB
    func updateDataInPointsDB(update: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5, execute: {
        print(self.tempID)
        self.publicDB.fetch(withRecordID: self.tempID as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                record.setValue("\(update)", forKey: "image")
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
        })
    }
    // Update data in PointsDB
    func updateProfilImageInPoints() {
        
        for index in 0...LoginViewController.points!.count-1 {
            if LoginViewController.points![index].value(forKey: "resident") as! String == LoginViewController.residentName && LoginViewController.points![index].value(forKey: "wg") as! String == LoginViewController.wg {
                self.tempID = LoginViewController.points![index].recordID
                return
            }
        }
    }
    // Alert erstellen mit Action
    func createAlert2(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        ))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
}
