//
//  LeaderBoardViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 15.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import UIKit
import CloudKit

class LeaderBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    @IBOutlet weak var LeaderBoardTableView: UITableView!
    var rank = 1
    var index = 0
    var LeaderBoardResident: [CKRecord]? = []
    var tempArray: [CKRecord]? = []
    var temp = 0
    
    let helpFunction = HilfsFunktionen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        LeaderBoardTableView.delegate = self
        LeaderBoardTableView.dataSource = self
        
        sortLeaderBoardArray()
        LeaderBoardTableView.reloadData()
        
        helpFunction.fetchData(Type: "Points", Array: "points")
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.sortLeaderBoardArray()
            self.LeaderBoardTableView.reloadData()
         })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        helpFunction.fetchData(Type: "Points", Array: "points")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.sortLeaderBoardArray()
            self.LeaderBoardTableView.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        index = 0
        rank = 1
        if LoginViewController.wg == "none" {
            return 0
        }
        return LeaderBoardResident!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LeaderBoardTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaderBoardTableViewCell
        
        cell.selectionStyle = .none
        cell.rankLabel.text = "Rang: \(rank)"
        cell.nameLabel.text = "\(LeaderBoardResident![index].value(forKey: "resident")!)"
        cell.titleLabel.text = "\(LeaderBoardResident![index].value(forKey: "title")!)"
        cell.pointsLabel.text = "\(LeaderBoardResident![index].value(forKey: "score")!) Punkte"
        if LeaderBoardResident![index].recordID == HomeViewController.pointsID as! CKRecord.ID{
            cell.imageCell.image = UIImage(named: "\(LoginViewController.image)")
        } else {
            cell.imageCell.image = UIImage(named: "\(LeaderBoardResident![index].value(forKey: "image")!)")
        }
        let temp: [String] = LeaderBoardResident![index].value(forKey: "achievements") as! [String]
        if temp.contains("admin") {
            cell.counterLabel.text = "\((LeaderBoardResident![index].value(forKey: "achievements")! as! [String]).count-1)"
        } else {
            cell.counterLabel.text = "\((LeaderBoardResident![index].value(forKey: "achievements")! as! [String]).count)"
        }
        
        print((LeaderBoardResident![index].value(forKey: "achievements") as! [String]).count)
        rank += 1
        index += 1
        return cell
    }
    // Updatet the selected user to admin
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        temp = indexPath.row
        if NewEventViewController.admin == true {
            createAlert2(title: "Was möchtest du tuen?", message: "Befördern: Befördere den Benutzer zum Admin. \nRauswerfen: Werfe den Benutzer aus der Gruppe.", ID: LeaderBoardResident![indexPath.row].recordID)
        }
        
    }
    // Alert erstellen mit Action
    func createAlert2(title: String, message: String, ID: CKRecord.ID) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Befördern", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.updateDataPoints(ID: ID)
        }
        ))
        alert.addAction(UIAlertAction(title: "Rauswerfen", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.updateDataResidents()
            self.deleteData(ID: ID)
        }
        ))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertAction.Style.default, handler: nil
        ))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    func getResidentForLeaderBoard() {
        
        var indexCounter: Int = 0
        var tempResident = tempArray?.first
        
        for index in 0...tempArray!.count-1 {
            if Int(tempResident?.value(forKey: "score") as! String)! < Int(tempArray![index].value(forKey: "score") as! String)! {
                tempResident = tempArray![index]
                indexCounter = index
            }
        }
        LeaderBoardResident?.append(tempResident!)
        tempArray?.remove(at: indexCounter)
    }
    
    func sortLeaderBoardArray() {
        
        LeaderBoardResident?.removeAll()
        tempArray?.removeAll()
        if LoginViewController.points?.count == 0 {
        }else {
            for index in 0...LoginViewController.points!.count-1 {
                if LoginViewController.points![index].value(forKey: "wg") as! String == LoginViewController.wg {
                    tempArray?.append(LoginViewController.points![index])
                }
            }
        }
        if tempArray?.count == 0 {
            
        } else {
            for _ in 0...tempArray!.count-1 {
                getResidentForLeaderBoard()
            }
        }

    }
    // Update data in PointsDB
    func updateDataPoints(ID: CKRecord.ID) {
        var tempArray2: [String] = []
        for index in 0...LoginViewController.points!.count-1 {
            if LoginViewController.points![index].recordID == ID{
                tempArray2 = LoginViewController.points![index].value(forKey: "achievements") as! [String]
            }
        }
         print(tempArray2)
        tempArray2.append("admin")
        print(tempArray2)
        
        publicDB.fetch(withRecordID: ID) { (record, error) in
            if let record = record, error == nil {
                record.setValue(tempArray2, forKey: "achievements")
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
    // delete data in PointDB
    func deleteData(ID: CKRecord.ID) {
        
        LeaderBoardResident?.remove(at: temp)
        viewWillAppear(true)
        publicDB.delete(withRecordID: ID) { (record, error) in
            if error != nil{
                return
            } else {
                print("hat geklappt")
            }
        }
    }
    // Update data in ResidentDB
    func updateDataResidents(){
        
        let tempName = LeaderBoardResident![temp].value(forKey: "resident") as! String
        var ID2: Any = ()
        var tempWG = ""
        for index in 0...LoginViewController.users!.count-1 {
            if LoginViewController.users![index].value(forKey: "name") as! String == tempName {
                ID2 = LoginViewController.users![index].recordID
                tempWG = LoginViewController.users![index].value(forKey: "wg") as! String
            }
        }
        
        if tempWG == LoginViewController.wg {
            publicDB.fetch(withRecordID: ID2 as! CKRecord.ID) { (record, error) in
                if let record = record, error == nil {
                    record.setValue("none", forKey: "wg")
                    self.publicDB.save(record) { _, error in
                        return
                    }
                }
            }
        }

    }
}
