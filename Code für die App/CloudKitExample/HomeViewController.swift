//
//  HomeViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 07.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import UIKit
import CloudKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static var latestEventsForResident: [CKRecord]? = []
    let publicDB = CKContainer.default().publicCloudDatabase
    var tempEventArray: [CKRecord]? = []
    var tempArray: [String] = []
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
    var loggedOut: Bool = false
    var homeTableIsEmpty = false
    var latestEventsIsEmpty = false
    static var pointsID: Any = ()
    static var wgHasChanged: Bool = false
    
    @IBOutlet weak var yourTodosLabel: UILabel!
    @IBOutlet weak var latestEventsLabel: UILabel!
    @IBOutlet weak var wgLabel: UILabel!
    @IBOutlet weak var placementLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    
    @IBAction func profilButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueSelectProfilImage", sender: self)
        
    }
    @IBOutlet weak var profilmImageButton: HomeViewUIButton!
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var latestEventsTableView: UITableView!
    
    let helpFunction = HilfsFunktionen()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        homeTableView.delegate = self
        homeTableView.dataSource = self
        latestEventsTableView.delegate = self
        latestEventsTableView.dataSource = self
        
        showTodoInfo()
        
        profilmImageButton.setImage(UIImage(named: "\(LoginViewController.image)"), for: .normal)
        setResidentPoints()
        wgLabel.text = "Gruppe: \(LoginViewController.wg)"
        LoginViewController.achievementCounter = "0"
        
        NewEventViewController.admin = false
        
        if LoginViewController.wg == "none"{
            yourTodosLabel.text = "Deine Todos:"
            latestEventsLabel.text = "Neuste Ereignisse:"
        } else {
            yourTodosLabel.text = "Deine Todos:"
            latestEventsLabel.text = "Neuste Ereignisse:"
        }
        
        if let tabItems = tabBarController?.tabBar.items {
            
            let tabItem = tabItems[3]
            var tempCounter = 0
            // In this case we want to modify the badge number of the 4th tab:
            if LoginViewController.points!.count == 0 {
            } else {
                for index in 0...LoginViewController.points!.count-1 {
                    if LoginViewController.points![index].recordID == HomeViewController.pointsID as! CKRecord.ID{
                        tempArray = LoginViewController.points![index].value(forKey: "achievements") as! [String]
                    }
                }
                LoginViewController.achievementCounter = "\(tempArray.count)"
            }
            if tempArray.contains("admin"){
                NewEventViewController.admin = true
                print("zzzich war hier101010")
            }
            if !(tempArray.contains("a1")) && Int(LoginViewController.todoCounter)! > 0 {
                tempCounter += 1
            }
            if !(tempArray.contains("a2")) && Int(LoginViewController.todoCounter)! > 4 {
                tempCounter += 1
            }
            if !(tempArray.contains("a3")) && Int(LoginViewController.todoCounter)! > 9 {
                tempCounter += 1
            }
            if !(tempArray.contains("a4")) && Int(LoginViewController.todoCounter)! > 24 {
                tempCounter += 1
            }
            if !(tempArray.contains("a5")) && Int(LoginViewController.todoCounter)! > 49{
                tempCounter += 1
            }
            if !(tempArray.contains("a6")) && Int(LoginViewController.pointsResident)! > 14{
                tempCounter += 1
            }
            if !(tempArray.contains("a7")) && Int(LoginViewController.pointsResident)! > 49{
                tempCounter += 1
            }
            if tempCounter > 0 {
                tabItem.badgeValue = "\(tempCounter)"
            } else {
                tabItem.badgeValue = nil
            }
            
        }
        helpFunction.fetchData(Type: "Residents", Array: "users")
        helpFunction.fetchData(Type: "Quests", Array: "quests")
        helpFunction.fetchData(Type: "Points", Array: "points")
        helpFunction.fetchData(Type: "Events", Array: "events")
        while(true) {
            print("ich war hier in while 1")
            if HomeViewController.fetchDataQuestFinished == true && HomeViewController.fetchDataPointsFinished == true{
                setResidentScore()
                createLatestEventArray()
                selectQuestsForResident()
                showResidentInformation()
                return
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        loggedOut = false
        tempArray.removeAll()
        
        showTodoInfo()
        
        profilmImageButton.setImage(UIImage(named: "\(LoginViewController.image)"), for: .normal)
        if TodoTableViewController.todoSelected == true {
            ProgressHUD.show("aktualisieren")
        }
        if HomeViewController.wgHasChanged == true {
            ProgressHUD.show("lädt")
        }
        if LoginViewController.wg == "none"{
            yourTodosLabel.text = "Deine Todos:"
            latestEventsLabel.text = "Neuste Ereignisse:"
        } else {
            yourTodosLabel.text = "Deine Todos:"
            latestEventsLabel.text = "Neuste Ereignisse:"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.refreshHomeTable()
            self.wgLabel.text = "Gruppe: \(LoginViewController.wg)"
            
            TodoTableViewController.todoSelected = false
        })
        
        
    }

    
    // Log out Button
    @IBAction func LogOutAction(_ sender: UIButton) {
        ProgressHUD.show("ausloggen")
        loggedOut = true
        NewEventViewController.admin = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
            self.dismiss(animated: true, completion: nil)
            ProgressHUD.dismiss()
        })
    }
    // Leave event Button
    @IBAction func LeaveEventAction(_ sender: UIButton) {
        createAlert3(title: "Möchtest du die Gruppe verlassen?", message: "")
    }
    // Anzahl der Zeilen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        index = 0
        index2 = 0
        if(tableView == homeTableView) {
            if LoginViewController.questsForResident!.count == 0 {
                homeTableIsEmpty = true
                showTodoInfo()
                return 1
            }
            return LoginViewController.questsForResident!.count
        } else {
            if HomeViewController.latestEventsForResident!.count == 0 {
                latestEventsIsEmpty = true
                return 1
            }
            return HomeViewController.latestEventsForResident!.count
        }
    }
    // Inhalt der Zeilen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == homeTableView) {
           
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
            let cell2 = homeTableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
            
            if homeTableIsEmpty == false {
                cell.imageCell.image = UIImage(named: LoginViewController.questsForResident![index].value(forKey: "image") as! String)
                cell.nameLabel.text = "\(LoginViewController.questsForResident![index].value(forKey: "name")!)"
                if "\(LoginViewController.questsForResident![index].value(forKey: "points")!)" == "1" {
                    cell.pointsLabel.text = "\(LoginViewController.questsForResident![index].value(forKey: "points")!) Punkt"
                } else {
                    cell.pointsLabel.text = "\(LoginViewController.questsForResident![index].value(forKey: "points")!) Punkte"
                }
            }
            
            index += 1
            if homeTableIsEmpty == true {
                
                homeTableIsEmpty = false
                cell2.selectionStyle = .none
                return cell2
            } else {
               return cell
            }
            
            }
        if(tableView == latestEventsTableView) {
            let cell = latestEventsTableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! EventTableViewCell
            let cell2 = latestEventsTableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath)

            if latestEventsIsEmpty == false {
            cell.imageCell.image = UIImage(named: "job_done.png")
            cell.nameLabel.text = "\(HomeViewController.latestEventsForResident![index2].value(forKey: "name")!)"
            cell.selectionStyle = .none
            if "\(HomeViewController.latestEventsForResident![index2].value(forKey: "points")!)" == "1" {
                cell.pointsLabel.text = "\(HomeViewController.latestEventsForResident![index2].value(forKey: "points")!) Punkt"
            } else {
                cell.pointsLabel.text = "\(HomeViewController.latestEventsForResident![index2].value(forKey: "points")!) Punkte"
            }
            cell.residentLabel.text = "bearbeitet von: \(HomeViewController.latestEventsForResident![index2].value(forKey: "resident")!)"
            }
            index2 += 1
            if latestEventsIsEmpty == true {
                latestEventsIsEmpty = false
                cell2.selectionStyle = .none
                return cell2
            } else {
                return cell
            }
        }
        return UITableViewCell()
    }
    // Updatet the selected todo
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == homeTableView && LoginViewController.questsForResident!.count > 0) {
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
                        self!.placementLabel.text = "Platzierung: \(LoginViewController.rankResident)"
                        self!.pointsLabel.text = "\(LoginViewController.pointsResident) Punkte"
                    }
                    
                }
                
            }
        }
        if NewEventViewController.admin {
            roleLabel.text = "Admin"
        } else {
            roleLabel.text = "User"
        }
    }
    
    func selectQuestsForResident() {
        LoginViewController.questsForResident?.removeAll()
        if(LoginViewController.quests?.count == 0) {
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
        alert.addAction(UIAlertAction(title: "Erledigt", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            ProgressHUD.show("aktualisieren")
            LoginViewController.todoCounter = "\(Int(LoginViewController.todoCounter)! + 1)"
            self.updateResidentFinished = false
            self.updateQuestFinished = false
            self.helpFunction.fetchData(Type: "Residents", Array: "user")
            self.updateData(ID: ID)
            self.updateDataPoints(IDQuest: ID)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                while(true) {
                    print("ich war hier in while 2")
                    if (self.updateResidentFinished == true && self.updateQuestFinished == true){
                        self.helpFunction.fetchData(Type: "Quests", Array: "quests")
                        self.refreshHomeTable()
                        break
                    }
                }
                if self.loggedOut == false {
                    ProgressHUD.dismiss()
                }
            })
        }
        ))
        alert.addAction(UIAlertAction(title: "Noch nicht", style: UIAlertAction.Style.default, handler: nil
        ))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    // Alert erstellen mit Action für Leave Event
    func createAlert3(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Gruppe verlassen", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            ProgressHUD.show("Gruppe verlassen")
            self.deleteData()
            LoginViewController.wg = "none"
            self.updateDataResidents()
            self.viewWillAppear(true)
        }
        ))
        alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertAction.Style.default, handler: nil
        ))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    // Update data in QuestDB
    func updateData(ID: CKRecord.ID){
        
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
        publicDB.fetch(withRecordID: HomeViewController.pointsID as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                
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
    // Update data in ResidentDB
    func updateDataResidents(){
        
        publicDB.fetch(withRecordID: LoginViewController.resident as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                record.setValue("none", forKey: "wg")
                self.updateQuestFinished = true
                self.publicDB.save(record) { _, error in
                    return
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
        print("zzzz \(NewEventViewController.admin)")
        if NewEventViewController.admin == true {
            NewEventViewController.admin = true
        } else {
            NewEventViewController.admin = false
        }
        
        print("ich war hier am start1")
        HomeViewController.fetchDataResidentFinished = false
        HomeViewController.fetchDataQuestFinished = false
        HomeViewController.fetchDataPointsFinished = false
        updateSelectedQuestForUserFinished = false
        updateLatestEventArrayFinished = false
        LoginViewController.achievementCounter = "0"
        
        if let tabItems = tabBarController?.tabBar.items {
            print("ich war hier am start2")
            let tabItem = tabItems[3]
            var tempCounter = 0
            
            for index in 0...LoginViewController.points!.count-1 {
                if LoginViewController.points![index].recordID == HomeViewController.pointsID as! CKRecord.ID{
                    tempArray = LoginViewController.points![index].value(forKey: "achievements") as! [String]
                }
            }
            
            if AchievementViewController.deleteBadge == true {
                tabItem.badgeValue = nil
                AchievementViewController.deleteBadge = false
            } else {
                
                if !(tempArray.contains("a1")) && Int(LoginViewController.todoCounter)! > 0 {
                    tempCounter += 1
                }
                if !(tempArray.contains("a2")) && Int(LoginViewController.todoCounter)! > 4 {
                    tempCounter += 1
                }
                if !(tempArray.contains("a3")) && Int(LoginViewController.todoCounter)! > 9 {
                    tempCounter += 1
                }
                if !(tempArray.contains("a4")) && Int(LoginViewController.todoCounter)! > 24 {
                    tempCounter += 1
                }
                if !(tempArray.contains("a5")) && Int(LoginViewController.todoCounter)! > 49{
                    tempCounter += 1
                }
                if !(tempArray.contains("a6")) && Int(LoginViewController.pointsResident)! > 14{
                    tempCounter += 1
                }
                if !(tempArray.contains("a7")) && Int(LoginViewController.pointsResident)! > 49{
                    tempCounter += 1
                }
                if tempCounter > 0 {
                    tabItem.badgeValue = "\(tempCounter)"
                } else {
                    tabItem.badgeValue = nil
                }
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if(HomeViewController.wgHasChanged == true) {
                self.setResidentPoints()
                HomeViewController.wgHasChanged = false
            }
            self.setRole()
            self.setResidentScore()
            self.showResidentInformation()
            
            
            self.helpFunction.fetchData(Type: "Residents", Array: "user")
            self.helpFunction.fetchData(Type: "Quests", Array: "quests")
            self.helpFunction.fetchData(Type: "Points", Array: "points")
            while(true) {
                print("ich war hier in while 3")
                if HomeViewController.fetchDataResidentFinished == true && HomeViewController.fetchDataPointsFinished == true {
                    self.setResidentScore()
                    self.showResidentInformation()
                    break
                }
            }
            while(true) {
                print("ich war hier in while 4")
                if HomeViewController.fetchDataQuestFinished == true {
                    print("ich war hier in while4.4")
                    self.createLatestEventArray()
                    self.selectQuestsForResident()
                    if self.updateSelectedQuestForUserFinished == true {
                        print("ich war hier in while 4.55")
                        self.homeTableView.reloadData()
                        self.latestEventsTableView.reloadData()
                        if self.loggedOut == false {
                            ProgressHUD.dismiss()
                        }
                        
                        return
                    }
                    
                }
            }
        })
        if loggedOut == false{
            ProgressHUD.dismiss()
        }
        
    }
    // Holt die neuste Quest aus dem QuestArray und hängt es dem ResidentQuestarray an. löscht die quests aus dem tempArray
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
                print("ich war hier in while 5")
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
                    HomeViewController.pointsID = LoginViewController.points![index].recordID
                    updateDataInPointsDB(update: LoginViewController.image)
                }
            }
            if LoginViewController.pointsResident == "-1" {
                saveData()
                LoginViewController.pointsResident = "0"
            }
        }
    }
    // Update data in PointsDB
    func updateDataInPointsDB(update: String) {
        
        publicDB.fetch(withRecordID: HomeViewController.pointsID as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                record.setValue("\(update)", forKey: "image")
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
    }
    // save data in PointDB
    func saveData() {
        let PointRecordID = CKRecord.ID(recordName: "\(LoginViewController.residentName)\(LoginViewController.wg)")
        HomeViewController.pointsID = CKRecord.ID(recordName: "\(LoginViewController.residentName)\(LoginViewController.wg)")
        let PointsRecord = CKRecord(recordType: "Points", recordID: PointRecordID)
        
        PointsRecord["resident"] = LoginViewController.residentName
        PointsRecord["score"] = "0"
        PointsRecord["wg"] = LoginViewController.wg
        PointsRecord["image"] = LoginViewController.image
        PointsRecord["todoCounter"] = "0"
        PointsRecord["title"] = ""
        if NewEventViewController.adminNewEvent{
            PointsRecord["achievements"] = ["admin"]
        } else {
            PointsRecord["achievements"] = [] as __CKRecordObjCValue
        }
        
        LoginViewController.todoCounter = "0"
        LoginViewController.points?.append(PointsRecord)
        publicDB.save(PointsRecord) { (record, error) in
            if error != nil{
                return
            } else {
                print("hat geklappt")
            }
        }
    }
    // delete data in PointDB
    func deleteData() {
        
        publicDB.delete(withRecordID: HomeViewController.pointsID as! CKRecord.ID) { (record, error) in
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
    func setRole() {
        for index in 0...LoginViewController.points!.count-1 {
            if LoginViewController.points![index].recordID == HomeViewController.pointsID as! CKRecord.ID{
                tempArray = LoginViewController.points![index].value(forKey: "achievements") as! [String]
            }
        }
        print("zzz \(self.tempArray)")
        print("zzz \(NewEventViewController.admin)")
        if self.tempArray.contains("admin") {
            print("zzz ich war hier in 1111111")
            NewEventViewController.admin = true
        }
        LoginViewController.achievementCounter = "\(self.tempArray.count)"
    }
    
    func showTodoInfo() {
        if homeTableIsEmpty && LoginViewController.todoCounter == "0" && LoginViewController.wg != "none" && LoginViewController.showTodoInfo == true{
            LoginViewController.showTodoInfo = false
            createAlert(title: "Du hast keine Todos ausgewählt", message: "Um ein Todo auszuwählen, musst du auf den Todo-Reiter wechseln und dort ein neues Todo anlegen oder ein bereits bestehendes Todo auswählen. Todos können ausgewählt werden, indem man auf sie klickt.")
        }
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
}
