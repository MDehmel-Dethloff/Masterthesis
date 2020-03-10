//
//  EventsViewController.swift
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

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    var index = 0
    var indexB = 0
    var starting = true
    var hashedPW = ""
    var indexArray: [String]? = []
    var indexHeaderArray: [String] = []
    var A = 0
    var B = 0
    var C = 0
    var D = 0
    var E = 0
    var F = 0
    var G = 0
    var H = 0
    var I = 0
    var J = 0
    var K = 0
    var L = 0
    var M = 0
    var N = 0
    var O = 0
    var P = 0
    var Q = 0
    var R = 0
    var S = 0
    var T = 0
    var U = 0
    var V = 0
    var W = 0
    var X = 0
    var Y = 0
    var Z = 0
    
    static var updateEventsFinished = false
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var createGroupLabel: UILabel!
    
    
    let helpFunction = HilfsFunktionen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the UI to light mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableDescription()
        getIndexForTableView()
        eventTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventTableDescription()
        // If this view is shown for the first time, the tableview for the groups gets build
        if starting {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
                self.starting = false
                self.indexB = 0
                EventsViewController.updateEventsFinished = false
                // Fetches required Data from DB
                self.helpFunction.fetchData(Type: "Events", Array: "events")
                while(true) {
                    if EventsViewController.updateEventsFinished == true {
                        self.getIndexForTableView()
                        self.index = 0
                        self.eventTableView.reloadData()
                        
                        return
                    }
                }
            })
        // else: update the tableview
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                self.indexB = 0
                EventsViewController.updateEventsFinished = false
                // Fetches required Data from DB
                self.helpFunction.fetchData(Type: "Events", Array: "events")
            })
            // if the user created a new group: show an animation for creating a group so the user knows that he has to wait for a few seconds
            if NewEventViewController.eventWasCreated == true {
                self.createGroupLabel.center = self.view.center
                self.createGroupLabel.center.x = self.view.center.x
                self.createGroupLabel.center.y = self.view.center.y
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
                self.createGroupLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Gruppe erstellen1")!)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.createGroupLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Gruppe erstellen2")!)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3, execute: {
                self.createGroupLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Gruppe erstellen3")!)
            })
            }
            // when the new group is created, the user automatically joins this group
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                while(true) {
                    if EventsViewController.updateEventsFinished == true {
                        self.getIndexForTableView()
                        self.index = 0
                        self.eventTableView.reloadData()
                        self.createGroupLabel.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                        if NewEventViewController.eventWasCreated == true {
                            self.createAlert(title: "Du bist der Gruppe \(LoginViewController.wg) beigetreten", message: "")
                            NewEventViewController.eventWasCreated = false
                        }
                        return
                    }
                }
            })
        }
    }
    // Performs a Segue if this button gets clicked
    @IBAction func createNewEventAction(_ sender: UIButton) {
        performSegue(withIdentifier: "übergangEvents", sender: self)
    }
    
    
    // Updates data in ResidentDB, if the user has joined a new group
    func updateData(index: Int) {
        
        publicDB.fetch(withRecordID: LoginViewController.resident as! CKRecord.ID) { (record, error) in
            if let record = record, error == nil {
                
                record.setValue("\(LoginViewController.events![index].value(forKey: "name")!)", forKey: "wg")
                LoginViewController.wg = LoginViewController.events![index].value(forKey: "name") as! String
                HomeViewController.wgHasChanged = true
                DispatchQueue.main.async { [weak self] in
                    if let tabItems = self?.tabBarController?.tabBar.items {
                        let tabItem = tabItems[3]
                        tabItem.badgeValue = nil
                        AchievementViewController.deleteBadge = true
                    }
                }
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
    }
    // creates the tableview's header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return indexHeaderArray[section]
    }
    
    // returns the number of sections of the tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return indexHeaderArray.count
    }
    // returns the umber of lines for every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == indexB && indexHeaderArray[indexB] == "A" {
            indexB += 1
            return A
        }
        if section == indexB && indexHeaderArray[indexB] == "B" {
            indexB += 1
            return B
        }
        if section == indexB && indexHeaderArray[indexB] == "C" {
            indexB += 1
            return C
        }
        if section == indexB && indexHeaderArray[indexB] == "D" {
            indexB += 1
            return D
        }
        if section == indexB && indexHeaderArray[indexB] == "E" {
            indexB += 1
            return E
        }
        if section == indexB && indexHeaderArray[indexB] == "F" {
            indexB += 1
            return F
        }
        if section == indexB && indexHeaderArray[indexB] == "G" {
            indexB += 1
            return G
        }
        if section == indexB && indexHeaderArray[indexB] == "H" {
            indexB += 1
            return H
        }
        if section == indexB && indexHeaderArray[indexB] == "I" {
            indexB += 1
            return I
        }
        if section == indexB && indexHeaderArray[indexB] == "J" {
            indexB += 1
            return J
        }
        if section == indexB && indexHeaderArray[indexB] == "K" {
            indexB += 1
            return K
        }
        if section == indexB && indexHeaderArray[indexB] == "L" {
            indexB += 1
            return L
        }
        if section == indexB && indexHeaderArray[indexB] == "M" {
            indexB += 1
            return M
        }
        if section == indexB && indexHeaderArray[indexB] == "N" {
            indexB += 1
            return N
        }
        if section == indexB && indexHeaderArray[indexB] == "O" {
            indexB += 1
            return O
        }
        if section == indexB && indexHeaderArray[indexB] == "P" {
            indexB += 1
            return P
        }
        if section == indexB && indexHeaderArray[indexB] == "Q" {
            indexB += 1
            return Q
        }
        if section == indexB && indexHeaderArray[indexB] == "R" {
            indexB += 1
            return R        }
        if section == indexB && indexHeaderArray[indexB] == "S" {
            indexB += 1
            return S
        }
        if section == indexB && indexHeaderArray[indexB] == "T" {
            indexB += 1
            return T
        }
        if section == indexB && indexHeaderArray[indexB] == "U" {
            indexB += 1
            return U
        }
        if section == indexB && indexHeaderArray[indexB] == "V" {
            indexB += 1
            return V
        }
        if section == indexB && indexHeaderArray[indexB] == "W" {
            indexB += 1
            return W
        }
        if section == indexB && indexHeaderArray[indexB] == "X" {
            indexB += 1
            return X
        }
        if section == indexB && indexHeaderArray[indexB] == "Y" {
            indexB += 1
            return Y
        }
        if section == indexB && indexHeaderArray[indexB] == "Z" {
            indexB += 1
            return Z
        }
        return 0
    }
    // Creates the content of every cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(LoginViewController.events![index].value(forKey: "name") ?? "")"
        index += 1
        return cell
    }
    // Performs an action if a cell gets clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var indexForItem = indexPath.row
        if indexPath.section > 0 {
            indexForItem = getIndexForSelectedItem(numberOfSection: indexPath.section-1, numberOfItemInSection: indexPath.row)
        }
        alertWithTF(title: "Bitte gib das Passwort für die Gruppe ein.", message: "", indexI: indexForItem)
    }
    
    // Creates an alert without an action
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.black
    }
    // Creates an alert with a textfield
    func alertWithTF(title: String, message: String, indexI: Int) {
        //Step : 1
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //Step : 2
        let save = UIAlertAction(title: "Beitreten!", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                //Read TextFields text data
                let md5Data = self.helpFunction.MD5(string: textField.text!)
                self.hashedPW =  md5Data.map { String(format: "%02hhx", $0) }.joined()
                self.checkPWforEvent(indexI: indexI)
            } else {
                self.createAlert(title: "Falsches Passwort", message: "")
            }
        }
        //Step : 3
        //For TextField
        alert.addTextField { (textField) in
            textField.placeholder = "Passwort"
            textField.isSecureTextEntry = true
        }
        //Step : 4
        alert.addAction(save)
        let cancel = UIAlertAction(title: "Abbrechen", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
    }
    // Checks if the given password is correct
    func checkPWforEvent(indexI: Int) {
        
        if(LoginViewController.events![indexI].value(forKey: "password") as! String == hashedPW){
            createAlert(title: "Du bist der Gruppe \(LoginViewController.events![indexI].value(forKey: "name")!) beigetreten.", message: "")
            self.updateData(index: indexI)
            NewEventViewController.admin = false
        } else {
            createAlert(title: "Falsches Passwort!", message: "")
        }
    }
    // determines which index Header is neeeded
    func getIndexForTableView() {
        
        A = 0
        B = 0
        C = 0
        D = 0
        E = 0
        F = 0
        G = 0
        H = 0
        I = 0
        J = 0
        K = 0
        L = 0
        M = 0
        N = 0
        O = 0
        P = 0
        Q = 0
        R = 0
        S = 0
        T = 0
        U = 0
        V = 0
        W = 0
        X = 0
        Y = 0
        Z = 0
        indexArray?.removeAll()
        indexHeaderArray.removeAll()
        if LoginViewController.events?.count == 0 {
        } else {
            for indexI in 0...LoginViewController.events!.count-1 {
                indexArray?.append(LoginViewController.events![indexI].value(forKey: "section") as! String)
            }
            if indexArray?.count == 0 {
            } else {
                
                for indexA in 0...indexArray!.count-1 {
                    
                    switch indexArray![indexA] {
                    case "A":
                        A += 1
                    case "B":
                        B += 1
                    case "C":
                        C += 1
                    case "D":
                        D += 1
                    case "E":
                        E += 1
                    case "F":
                        F += 1
                    case "G":
                        G += 1
                    case "H":
                        H += 1
                    case "I":
                        I += 1
                    case "J":
                        J += 1
                    case "K":
                        K += 1
                    case "L":
                        L += 1
                    case "M":
                        M += 1
                    case "N":
                        N += 1
                    case "O":
                        O += 1
                    case "P":
                        P += 1
                    case "Q":
                        Q += 1
                    case "R":
                        R += 1
                    case "S":
                        S += 1
                    case "T":
                        T += 1
                    case "U":
                        U += 1
                    case "V":
                        V += 1
                    case "W":
                        W += 1
                    case "X":
                        X += 1
                    case "Y":
                        Y += 1
                    case "Z":
                        Z += 1
                    default: break
                        
                    }
                }
                if A > 0 {
                    indexHeaderArray.append("A")
                }
                if B > 0 {
                    indexHeaderArray.append("B")
                }
                if C > 0 {
                    indexHeaderArray.append("C")
                }
                if D > 0 {
                    indexHeaderArray.append("D")
                }
                if E > 0 {
                    indexHeaderArray.append("E")
                }
                if F > 0 {
                    indexHeaderArray.append("F")
                }
                if G > 0 {
                    indexHeaderArray.append("G")
                }
                if H > 0 {
                    indexHeaderArray.append("H")
                }
                if I > 0 {
                    indexHeaderArray.append("I")
                }
                if J > 0 {
                    indexHeaderArray.append("J")
                }
                if K > 0 {
                    indexHeaderArray.append("K")
                }
                if L > 0 {
                    indexHeaderArray.append("L")
                }
                if M > 0 {
                    indexHeaderArray.append("M")
                }
                if N > 0 {
                    indexHeaderArray.append("N")
                }
                if O > 0 {
                    indexHeaderArray.append("O")
                }
                if P > 0 {
                    indexHeaderArray.append("P")
                }
                if Q > 0 {
                    indexHeaderArray.append("Q")
                }
                if R > 0 {
                    indexHeaderArray.append("R")
                }
                if S > 0 {
                    indexHeaderArray.append("S")
                }
                if T > 0 {
                    indexHeaderArray.append("T")
                }
                if U > 0 {
                    indexHeaderArray.append("U")
                }
                if V > 0 {
                    indexHeaderArray.append("V")
                }
                if W > 0 {
                    indexHeaderArray.append("W")
                }
                if X > 0 {
                    indexHeaderArray.append("X")
                }
                if Y > 0 {
                    indexHeaderArray.append("Y")
                }
                if Z > 0 {
                    indexHeaderArray.append("Z")
                }
                indexHeaderArray.append("")
            }
        }
    }
    // Determines the index of the selected Item at the Tableview
    func getIndexForSelectedItem(numberOfSection: Int, numberOfItemInSection: Int) -> Int{
        var tempCounter = 0
        for index in 0...numberOfSection {
            tempCounter += eventTableView.numberOfRows(inSection: index)
        }
        tempCounter += numberOfItemInSection
        return tempCounter
    }
    // Creates a description if the user dosen't joined a group yet
    func eventTableDescription() {
        
        if LoginViewController.wg == "none" {
            createAlert(title: "In diesem Tab kannst du eine eigene Gruppe anlegen oder einer bereits bestehenden Gruppe beitreten. Um einer Gruppe beitreten zu können, benötigst du das Passwort der Gruppe.", message: "")
        }
    }
    
}
