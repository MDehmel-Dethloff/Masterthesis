//
//  AchievementViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 22.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import CloudKit
import UIKit

class AchievementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let publicDB = CKContainer.default().publicCloudDatabase
    @IBOutlet weak var AchievementTableView: EventTableSizeViewController!
    var index = 0
    var tempArray: [String] = []
    var tempArrayAny: [Any] = []
    var changedSomething = false
    var titleAchievement = false
    static var deleteBadge = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the UI to light mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        AchievementTableView.delegate = self
        AchievementTableView.dataSource = self
        if LoginViewController.points?.count == 0 {
        } else {
            for index in 0...LoginViewController.points!.count-1 {
                if HomeViewController.pointsID as! CKRecord.ID == LoginViewController.points![index].recordID{
                    tempArray = LoginViewController.points![index].value(forKey: "achievements") as! [String]
                }
            }
        }
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[4]
            tabItem.badgeValue = nil
            AchievementViewController.deleteBadge = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        titleAchievement = false
        tempArray.removeAll()
        tempArray.append("admin")
        AchievementTableView.reloadData()
        tempArrayAny.removeAll()
            changedSomething = false
            tempArrayAny = tempArray as [Any]
            updateDataPoints()
        // deletes the small red number on the achievementbadge 
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[4]
            tabItem.badgeValue = nil
            AchievementViewController.deleteBadge = true
        }
    }
    
    // returns the number of rows for the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        index = 0
        return LoginViewController.achievements!.count
    }
    // creates the content for every cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AchievementTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AchievementTableViewCell
        let cell2 = AchievementTableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! AchievementTableViewCell
        if index == 4 {
            let temp: String = LoginViewController.achievements![index].value(forKey: "name") as! String
            let temp2: String = String(temp.prefix(23))
            print(temp2)
            cell2.cellLabel.text = temp2
            cell2.selectionStyle = .none
            cell2.cellLabel.textColor = UIColor.lightGray
            let temp3:String = String(temp.suffix(23))
            cell2.rewardLabel.text = temp3
            cell2.rewardLabel.textColor = UIColor.lightGray
            
        } else {
            cell.cellLabel.text = "\(LoginViewController.achievements![index].value(forKey: "name")!)"
            cell.selectionStyle = .none
            cell.cellLabel.textColor = UIColor.lightGray
        }
        
        if index == 0 && Int(LoginViewController.todoCounter)! > 0 {
            cell.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)c")
            cell.cellLabel.textColor = UIColor.black
            if tempArray.contains("a1") {
            } else {
                tempArray.append("a1")
                changedSomething = true
            }
            index += 1
            return cell
        }
        if index == 1 && Int(LoginViewController.todoCounter)! > 4 {
            cell.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)c")
            cell.cellLabel.textColor = UIColor.black
            if tempArray.contains("a2") {
            } else {
                tempArray.append("a2")
                changedSomething = true
            }
            index += 1
            return cell
        }
        if index == 2 && Int(LoginViewController.todoCounter)! > 9 {
            cell.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)c")
            cell.cellLabel.textColor = UIColor.black
            if tempArray.contains("a3") {
            } else {
                tempArray.append("a3")
                changedSomething = true
            }
            index += 1
            return cell
        }
        if index == 3 && Int(LoginViewController.todoCounter)! > 24 {
            cell.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)c")
            cell.cellLabel.textColor = UIColor.black
            if tempArray.contains("a4") {
            } else {
                tempArray.append("a4")
                changedSomething = true
            }
            index += 1
            return cell
        }
        if index == 4 && Int(LoginViewController.todoCounter)! > 49 {
            titleAchievement = true
            cell2.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)c")
            cell2.cellLabel.textColor = UIColor.black
            print("ich war hier in 5")
            if tempArray.contains("a5") {
            } else {
                print("ich war hier auch in 5")
                tempArray.append("a5")
                changedSomething = true
            }
            index += 1
            return cell2
        }
        if index == 5 && Int(LoginViewController.pointsResident)! > 14 {
            cell.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)c")
            cell.cellLabel.textColor = UIColor.black
            if tempArray.contains("a6") {
            } else {
                tempArray.append("a6")
                changedSomething = true
            }
            index += 1
            return cell
        }
        if index == 6 && Int(LoginViewController.pointsResident)! > 49 {
            cell.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)c")
            cell.cellLabel.textColor = UIColor.black
            if tempArray.contains("a7") {
            } else {
                print("zeigen: ich war hier")
                tempArray.append("a7")
                changedSomething = true
            }
            index += 1
            return cell
        }

        cell.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)")
        cell2.cellImage.image = UIImage(named: "\(LoginViewController.achievements![index].value(forKey: "image")!)")
        index += 1
        if index == 5 {
            return cell2
        } else {
            return cell
        }
    }
    // Updatet the selected Achievement
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if titleAchievement {
            createAlert2(title: "Chose your Title.", message: "Female: die Fleißige. \nMale: der Fleißige.")
        }
    }
    // Creates an alert with an action
    func createAlert2(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Female", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            let tempName = "die Fleißige."
            self.updateDataInPointsDB(update: tempName)
        }
        ))
        alert.addAction(UIAlertAction(title: "Male", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            let tempName2 = "der Fleißige."
            self.updateDataInPointsDB(update: tempName2)
        }
        ))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil
        ))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    
    // Update data in PointsDB
    func updateDataPoints() {
        publicDB.fetch(withRecordID: HomeViewController.pointsID as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                record.setValue(self.tempArrayAny, forKey: "achievements")
                self.publicDB.save(record) { _, error in
                    if error != nil{
                        print("error")
                        return
                    } else {
                        print("hat geklappt")
                    }
                }
            }
        }
    }
    // Update data in PointsDB
    func updateDataInPointsDB(update: String) {
        
        publicDB.fetch(withRecordID: HomeViewController.pointsID as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                record.setValue("\(update)", forKey: "title")
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
    }
}
