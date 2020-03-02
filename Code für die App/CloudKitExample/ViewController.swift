//
//  ViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 30.07.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit
import CloudKit

struct Quest: Decodable {
    let name: String
    let points: String
    let description: String
    let resident: String
    let wg: String
    let status:String
}


class ViewController: UIViewController {
    
    
    let publicDB = CKContainer.default().publicCloudDatabase
    var questArray = [Quest] ()
    var fetchdata: [CKRecord]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    
    func fetchData() {
        
        let query = CKQuery(recordType: "Quests", predicate: NSPredicate(value: true))
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            /*guard let records = records, error == nil else {
                print("Error")
                return
            }*/
            if error != nil {
                print("Ein Error ist aufgetreten")
                return
            }
            self.fetchdata = records
            if (self.fetchdata!.isEmpty) {
                return
            }
            //print(self.fetchdata?.first?.value(forKey: "name"))
            /*for index in 0...self.fetchdata!.count-1{
                let tempQuest = Quest(name: records[index].value(forKey: "name") as! String, points: records[index].value(forKey: "points") as! String, description: records[index].value(forKey: "description") as! String, resident: records[index].value(forKey: "resident") as! String, wg: records[index].value(forKey: "wg") as! String, status: records[index].value(forKey: "status") as! String)
                self.questArray.append(tempQuest)
            }*/
        }
    }
    
    func saveData() {

        let QuestRecordID = CKRecord.ID(recordName: "115")
        let QuestsRecord = CKRecord(recordType: "Quests", recordID: QuestRecordID)
        
        QuestsRecord["name"] = "sauber machen" as NSString
        QuestsRecord["points"] = "22" as NSString
        QuestsRecord["description"] = "bitte alles" as NSString
        QuestsRecord["resident"] = "wiwi" as NSString
        QuestsRecord["wg"] = "sandwiese" as NSString
        QuestsRecord["status"] = "nDone" as NSString
        
        publicDB.save(QuestsRecord) { (record, error) in
            if error != nil{
                return
            } else {
                print("hat geklappt")
            }
        }
    }
    
    func deleteData() {
        
        let deleteRecord = self.fetchdata?.first?.recordID
        publicDB.delete(withRecordID: deleteRecord!) { (record, error) in
            if error != nil{
                return
            } else {
                print("wurde gelöscht")
            }
        }
    }
    
    func updateData() {
        let updateRecord = self.fetchdata?.first?.recordID
        
        publicDB.fetch(withRecordID: updateRecord!) { (record, error) in
            if let record = record, error == nil {
                
                record.setValue("Done", forKey: "status")
                
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        deleteData()
    }
    
    @IBAction func insertAction(_ sender: UIButton) {
        saveData()
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        updateData()
    }
    
    
    
}


///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

//
//  HomeViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 07.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import UIKit
import CloudKit

/*class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    static var latestEventsForResident: [CKRecord]? = []
    var tempEventArray: [CKRecord]? = []
    var index = 0
    var index2 = 0
    static var fetchDataQuestFinished: Bool = false
    static var fetchDataResidentFinished: Bool = false
    static var fetchDataPointsFinished: Bool = false
    var updateResidentFinished: Bool = false
    var updateQuestFinished: Bool = false
    var updateSelectedQuestForUserFinished: Bool = false
    var updateLatestEventArrayFinished: Bool = false
    var counter = 0
    var pointsID: Any = ()
    static var wgHasChanged: Bool = false
    
    @IBOutlet weak var placementLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBAction func profilButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueSelectProfilImage", sender: self)
        
    }
    @IBOutlet weak var profilmImageButton: HomeViewUIButton!
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var latestEventsTableView: UITableView!
    
    let helpFunction = HilfsFunktionen()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        latestEventsTableView.delegate = self
        latestEventsTableView.dataSource = self
        
        profilmImageButton.setImage(UIImage(named: "\(LoginViewController.image)"), for: .normal)
        setResidentPoints()
        
        //fetchDataQuests()
        helpFunction.fetchData(Type: "Residents", Array: "users")
        helpFunction.fetchData(Type: "Quests", Array: "quests")
        helpFunction.fetchData(Type: "Points", Array: "points")
        while(true) {
            if HomeViewController.fetchDataQuestFinished == true && HomeViewController.fetchDataPointsFinished == true{
                setResidentScore()
                createLatestEventArray()
                selectQuestsForResident()
                showResidentInformation()
                //homeTableView.reloadData()
                //latestEventsTableView.reloadData()
                return
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        profilmImageButton.setImage(UIImage(named: "\(LoginViewController.image)"), for: .normal)
        if TodoTableViewController.todoSelected == true {
            ProgressHUD.show("updating")
        }
        if HomeViewController.wgHasChanged == true {
            ProgressHUD.show("loading")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.refreshHomeTable()
            
            TodoTableViewController.todoSelected = false
        })
    }
    
    // Anzahl der Zeilen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        index = 0
        index2 = 0
        if(tableView == homeTableView) {
            return LoginViewController.questsForResident!.count
        } else {
            //return latestEventsForResident!.count
            return HomeViewController.latestEventsForResident!.count
        }
    }
    // Inhalt der Zeilen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == homeTableView) {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
            if Int(LoginViewController.questsForResident![index].value(forKey: "points") as! String)! < 5 {
                cell.imageCell.image = UIImage(named: "todo_green.png")
            }
            if 5 <= Int(LoginViewController.questsForResident![index].value(forKey: "points") as! String)! && Int(LoginViewController.questsForResident![index].value(forKey: "points") as! String)! < 10 {
                cell.imageCell.image = UIImage(named: "todo_orange.png")
            }
            if 10 <= Int(LoginViewController.questsForResident![index].value(forKey: "points") as! String)! {
                cell.imageCell.image = UIImage(named: "todo_red.png")
            }
            
            cell.nameLabel.text = "\(LoginViewController.questsForResident![index].value(forKey: "name")!)"
            if "\(LoginViewController.questsForResident![index].value(forKey: "points")!)" == "1" {
                cell.pointsLabel.text = "\(LoginViewController.questsForResident![index].value(forKey: "points")!) Point"
            } else {
                cell.pointsLabel.text = "\(LoginViewController.questsForResident![index].value(forKey: "points")!) Points"
            }
            
            index += 1
            return cell
        }
        if(tableView == latestEventsTableView) {
            let cell = latestEventsTableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! EventTableViewCell
            cell.imageCell.image = UIImage(named: "todo_done.png")
            cell.nameLabel.text = "\(HomeViewController.latestEventsForResident![index2].value(forKey: "name")!)"
            if "\(HomeViewController.latestEventsForResident![index2].value(forKey: "points")!)" == "1" {
                cell.pointsLabel.text = "\(HomeViewController.latestEventsForResident![index2].value(forKey: "points")!) Point"
            } else {
                cell.pointsLabel.text = "\(HomeViewController.latestEventsForResident![index2].value(forKey: "points")!) Points"
            }
            
            cell.residentLabel.text = "by: \(HomeViewController.latestEventsForResident![index2].value(forKey: "resident")!)"
            index2 += 1
            return cell
        }
        return UITableViewCell()
    }
    // Updatet the selected todo
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == homeTableView) {
            createAlert2(title: "\(LoginViewController.questsForResident![indexPath.row].value(forKey: "name")!)", message: "\(LoginViewController.questsForResident![indexPath.row].value(forKey: "description")!)", ID: LoginViewController.questsForResident![indexPath.row].recordID)
        }
    }
    // Set the users score and rank
    func showResidentInformation() {
        
        if LoginViewController.users?.count == 0 {
        } else {
            for index in 0...LoginViewController.users!.count-1 {
                if(LoginViewController.resident as! CKRecord.ID == LoginViewController.users![index].recordID){
                    DispatchQueue.main.async { [weak self] in
                        self!.placementLabel.text = "Place: \(LoginViewController.rankResident)"
                        self!.pointsLabel.text = "\(LoginViewController.pointsResident) points"
                    }
                    
                }
                
            }
        }
    }
    
    func selectQuestsForResident() {
        LoginViewController.questsForResident?.removeAll()
        if(LoginViewController.quests?.count == 0) {
            //self.updateSelectedQuestForUserFinished = true
        }else {
            for index in 0...LoginViewController.quests!.count-1 {
                if(LoginViewController.residentName == LoginViewController.quests![index].value(forKey: "resident") as! String && LoginViewController.quests![index].value(forKey: "status") as! String == "nDone" && LoginViewController.quests![index].value(forKey: "wg") as! String == LoginViewController.wg) {
                    LoginViewController.questsForResident?.append(LoginViewController.quests![index])
                }
                if(index == LoginViewController.quests!.count-1) {
                    self.updateSelectedQuestForUserFinished = true
                }
            }
        }
    }
    // Alert erstellen mit Action
    func createAlert2(title: String, message: String, ID: CKRecord.ID) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            ProgressHUD.show("updating")
            LoginViewController.todoCounter = "\(Int(LoginViewController.todoCounter)! + 1)"
            self.updateResidentFinished = false
            self.updateQuestFinished = false
            self.helpFunction.fetchData(Type: "Residents", Array: "user")
            self.updateData(ID: ID)
            self.updateDataPoints(IDQuest: ID)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                while(true) {
                    if (self.updateResidentFinished == true && self.updateQuestFinished == true){
                        self.helpFunction.fetchData(Type: "Quests", Array: "quests")
                        self.refreshHomeTable()
                        break
                    }
                }
                ProgressHUD.dismiss()
            })
        }
        ))
        alert.addAction(UIAlertAction(title: "Not yet", style: UIAlertAction.Style.default, handler: nil
        ))
        self.present(alert, animated: true, completion: nil)
    }
    // Update data in QuestDB
    func updateData(ID: CKRecord.ID){
        
        /*for index in 0...LoginViewController.quests!.count-1 {
         if LoginViewController.quests![index].recordID == ID {
         LoginViewController.quests![index].setValue("Done", forKey: "status")
         }
         }*/
        
        publicDB.fetch(withRecordID: ID) { (record, error) in
            if let record = record, error == nil {
                record.setValue("Done", forKey: "status")
                self.updateQuestFinished = true
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
    }
    // Update data in PointsDB
    func updateDataPoints(IDQuest: CKRecord.ID) {
        let tempPoints = String(Int(LoginViewController.pointsResident)! + self.getQuestsPoints(IDQuest: IDQuest))
        publicDB.fetch(withRecordID: pointsID as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                
                /*for index in 0...LoginViewController.points!.count-1 {
                 if LoginViewController.points![index].value(forKey: "resident") as! String == LoginViewController.residentName && LoginViewController.points![index].value(forKey: "wg") as! String == LoginViewController.wg{
                 LoginViewController.points![index].setValue("\(LoginViewController.todoCounter)", forKey: "todoCounter")
                 LoginViewController.points![index].setValue("\(tempPoints)", forKey: "score")
                 }
                 }*/
                
                record.setValue("\(tempPoints)", forKey: "score")
                record.setValue("\(LoginViewController.todoCounter)", forKey: "todoCounter")
                print("ich war hier")
                self.updateResidentFinished = true
                LoginViewController.pointsResident = tempPoints
                self.publicDB.save(record) { _, error in
                    if error != nil{
                        print("ich war hier in error")
                        return
                    } else {
                        print("hat geklappt")
                    }
                }
            }
        }
    }
    // Return users score
    func getUsersPoints(ID: CKRecord.ID) -> Int{
        for index in 0...LoginViewController.users!.count-1 {
            if(LoginViewController.resident as! CKRecord.ID == LoginViewController.users![index].recordID) {
                return Int(LoginViewController.users![index].value(forKey: "points") as! String)!
            }
        }
        return 0
    }
    // Return points from current quest
    func getQuestsPoints(IDQuest: CKRecord.ID) -> Int {
        if LoginViewController.quests!.count == 0 {
        } else {
            for index in 0...LoginViewController.quests!.count-1 {
                if(IDQuest == LoginViewController.quests![index].recordID) {
                    return Int(LoginViewController.quests![index].value(forKey: "points") as! String)!
                }
            }
        }
        return 0
    }
    func refreshHomeTable() {
        HomeViewController.fetchDataResidentFinished = false
        HomeViewController.fetchDataQuestFinished = false
        HomeViewController.fetchDataPointsFinished = false
        updateSelectedQuestForUserFinished = false
        updateLatestEventArrayFinished = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if(HomeViewController.wgHasChanged == true) {
                self.setResidentPoints()
                HomeViewController.wgHasChanged = false
            }
            self.setResidentScore()
            self.showResidentInformation()
            
            
            self.helpFunction.fetchData(Type: "Residents", Array: "user")
            self.helpFunction.fetchData(Type: "Quests", Array: "quests")
            self.helpFunction.fetchData(Type: "Points", Array: "points")
            while(true) {
                if HomeViewController.fetchDataResidentFinished == true && HomeViewController.fetchDataPointsFinished == true {
                    self.setResidentScore()
                    self.showResidentInformation()
                    break
                }
            }
            while(true) {
                if HomeViewController.fetchDataQuestFinished == true {
                    self.createLatestEventArray()
                    self.selectQuestsForResident()
                    if self.updateSelectedQuestForUserFinished == true {
                        self.homeTableView.reloadData()
                        self.latestEventsTableView.reloadData()
                        ProgressHUD.dismiss()
                        return
                    }
                    
                }
            }
        })
    }
    // Holt die neuste QUest aus dem QuestArray und hängt es dem ResidentQuestarray an. löscht die quests aus dem tempArray
    func getlatestElement() {
        
        if tempEventArray!.isEmpty {
            counter += 1
            return
        }
        var latestEvent: CKRecord = (tempEventArray?.first!)!
        var indexcounter = 0
        
        for index in 0...tempEventArray!.count-1 {
            if (latestEvent.modificationDate! < tempEventArray![index].modificationDate!){
                latestEvent = tempEventArray![index]
                indexcounter = index
            }
        }
        HomeViewController.latestEventsForResident?.append(latestEvent)
        tempEventArray?.remove(at: indexcounter)
        counter += 1
    }
    func createLatestEventArray() {
        HomeViewController.latestEventsForResident?.removeAll()
        tempEventArray?.removeAll()
        if LoginViewController.quests!.count == 0 {
        } else {
            for index in 0...LoginViewController.quests!.count-1 {
                if LoginViewController.quests![index].value(forKey: "wg") as! String == LoginViewController.wg && LoginViewController.quests![index].value(forKey: "status") as! String == "Done"{
                    tempEventArray?.append(LoginViewController.quests![index])
                }
            }
            while (counter < 6) {
                getlatestElement()
            }
            self.updateLatestEventArrayFinished = true
            counter = 0
        }
    }
    func setResidentPoints() {
        LoginViewController.pointsResident = "-1"
        if LoginViewController.points?.count == 0 {
            saveData()
            LoginViewController.pointsResident = "0"
        } else {
            for index in 0...LoginViewController.points!.count-1 {
                if LoginViewController.points![index].value(forKey: "resident") as! String == LoginViewController.residentName && LoginViewController.points![index].value(forKey: "wg") as! String == LoginViewController.wg {
                    LoginViewController.pointsResident = LoginViewController.points![index].value(forKey: "score")! as! String
                    LoginViewController.todoCounter = LoginViewController.points![index].value(forKey: "todoCounter") as! String
                    pointsID = LoginViewController.points![index].recordID
                }
            }
            if LoginViewController.pointsResident == "-1" {
                saveData()
                LoginViewController.pointsResident = "0"
            }
        }
    }
    // save data in PointDB
    func saveData() {
        let PointRecordID = CKRecord.ID(recordName: "\(LoginViewController.residentName)\(LoginViewController.pointsResident)\(LoginViewController.wg)")
        pointsID = CKRecord.ID(recordName: "\(LoginViewController.residentName)\(LoginViewController.pointsResident)\(LoginViewController.wg)")
        let PointsRecord = CKRecord(recordType: "Points", recordID: PointRecordID)
        
        PointsRecord["resident"] = LoginViewController.residentName
        PointsRecord["score"] = "0"
        PointsRecord["wg"] = LoginViewController.wg
        PointsRecord["image"] = LoginViewController.image
        PointsRecord["todoCounter"] = "0"
        LoginViewController.todoCounter = "0"
        
        publicDB.save(PointsRecord) { (record, error) in
            if error != nil{
                return
            } else {
                print("hat geklappt")
            }
        }
    }
    func setResidentScore() {
        
        var tempArray: [CKRecord]? = []
        var tempRank: Int = 1
        
        if LoginViewController.points?.count == 0{
        } else {
            for index in 0...LoginViewController.points!.count-1 {
                if LoginViewController.points![index].value(forKey: "wg") as! String == LoginViewController.wg {
                    tempArray?.append(LoginViewController.points![index])
                }
            }
        }
        if tempArray?.count == 0 {
            LoginViewController.rankResident = "1"
        } else {
            for index in 0...tempArray!.count-1 {
                if (Int(LoginViewController.pointsResident)! < Int((tempArray![index].value(forKey: "score")) as! String)!) {
                    tempRank += 1
                }
            }
            LoginViewController.rankResident = String(tempRank)
        }
    }
}
*/


