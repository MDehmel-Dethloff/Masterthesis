//
//  TodoTableViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 03.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import UIKit
import CloudKit

class TodoTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    var questsForResident: [CKRecord]? = []
    var index = 0
    static var updateQuestsfinished: Bool = false
    static var todoSelected = false
    @IBOutlet weak var todoTableView: EventTableSizeViewController!
    
    let helpFunction = HilfsFunktionen()
    
    override func viewDidLoad() {
        questsForResident?.removeAll()
        super.viewDidLoad()
        // Set the UI to light mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        selectedQuests()
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        
            self.refreshTable()
            
            CreateTodoViewController.todoWasCreated = false

    }
    
    // returns the number of lines for the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        index = 0
        return questsForResident!.count
    }
    // returns the content for every cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell

        cell.imageCell.image = UIImage(named: questsForResident![index].value(forKey: "image") as! String)
        cell.nameLabel.text = "\(questsForResident![index].value(forKey: "name")!)"
        if(questsForResident![index].value(forKey: "points") as! String == "1"){
            cell.pointsLabel.text = "\(questsForResident![index].value(forKey: "points")!) Punkt"
        } else {
            cell.pointsLabel.text = "\(questsForResident![index].value(forKey: "points")!) Punkte"
        }
        index += 1
        return cell
    }
    
    // Performs a Segue to the create-Todo-screen
    @IBAction func createTodoAction(_ sender: UIButton) {
        performSegue(withIdentifier: "übergangTodo", sender: self)
    }
    
    // Updates the selected todo
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        createAlert2(title: "\(questsForResident![indexPath.row].value(forKey: "name")!)", message: "\(questsForResident![indexPath.row].value(forKey: "description")!)", ID: questsForResident![indexPath.row].recordID)
    }
    // Updates the content of the quest-array with "wg" and "resident" == none
    func selectedQuests() {
        
        if LoginViewController.quests?.count == 0 {
        } else {
            questsForResident?.removeAll()
            for index in 0...LoginViewController.quests!.count-1 {
                if(LoginViewController.wg == LoginViewController.quests![index].value(forKey: "wg") as! String && LoginViewController.quests![index].value(forKey: "resident") as! String == "none"){
                    questsForResident?.append(LoginViewController.quests![index])
                }
            }
        }
        self.todoTableView.reloadData()
    }
    // Creates an alert with an action
    func createAlert2(title: String, message: String, ID: CKRecord.ID) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let home = HomeViewController()
        home.selectQuestsForResident()
        alert.addAction(UIAlertAction(title: "Annehmen", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            if LoginViewController.questsForResident!.count > 6 {
                self.createAlert(title: "Du kannst dieses Todo nicht annehmen!", message: "Du hast bereits genug Todos angenommen.")
            } else {
                TodoTableViewController.todoSelected = true
                self.updateData(ID: ID)
                self.refreshTable()
            }
        }
        ))
        alert.addAction(UIAlertAction(title: "Ablehnen", style: UIAlertAction.Style.default, handler: nil
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
    // Update data in QuestDB
    func updateData(ID: CKRecord.ID) {
        
        for index in 0...LoginViewController.quests!.count-1 {
            if LoginViewController.quests![index].recordID == ID {
                LoginViewController.quests![index].setValue("\(LoginViewController.residentName)", forKey: "resident")
            }
        }
        
        
        publicDB.fetch(withRecordID: ID) { (record, error) in
            if let record = record, error == nil {
                record.setValue("\(LoginViewController.residentName)", forKey: "resident")
                
                self.publicDB.save(record) { _, error in
                    return
                }
            }
        }
    }
    // updates the tableview
    func refreshTable() {
        
        if CreateTodoViewController.todoWasCreated == true {
            self.selectedQuests()
            return
        }
        TodoTableViewController.updateQuestsfinished = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
            self.helpFunction.fetchData(Type: "Quests", Array: "quests")
            while(true) {
                if(TodoTableViewController.updateQuestsfinished == true) {
                    self.selectedQuests()
                    return
                }
            }
        })
    }
}
