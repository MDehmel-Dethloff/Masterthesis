//
//  HilfsFunktionen.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 14.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//
import CloudKit
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class HilfsFunktionen: UIViewController {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    // Fetches any kind of Data from iCloudDatabase
    func fetchData(Type: String, Array: String) {
        
        let query = CKQuery(recordType: Type, predicate: NSPredicate(value: true))
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if error != nil {
                print("Ein Error ist aufgetreten")
                return
            }
            if Array == "user" {
                LoginViewController.users = records
                HomeViewController.fetchDataResidentFinished = true
            }
            if Array == "events" {
                LoginViewController.events = records
                EventsViewController.updateEventsFinished = true
            }
            if Array == "quests" {
                LoginViewController.quests = records
                TodoTableViewController.updateQuestsfinished = true
                HomeViewController.fetchDataQuestFinished = true
            }
            if Array == "points" {
                LoginViewController.points = records
                HomeViewController.fetchDataPointsFinished = true
            }
            if Array == "achievements" {
                LoginViewController.achievements = records
            }
            if (LoginViewController.users!.isEmpty || LoginViewController.events!.isEmpty || LoginViewController.quests!.isEmpty) {
                return
            }
        }
    }
    // Hash method thats hashes a value with MD5
    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    // determines the value of the red number if the user achieves a new achievement
    func achievementBadge() {
        
        if let tabItems = tabBarController?.tabBar.items {
            var tempArray: [String] = []
            let tabItem = tabItems[4]
            var tempCounter = 0
            // In this case we want to modify the badge number of the third tab:
            for index in 0...LoginViewController.points!.count-1 {
                if LoginViewController.points![index].recordID == HomeViewController.pointsID as! CKRecord.ID{
                    tempArray = LoginViewController.points![index].value(forKey: "achievements") as! [String]
                }
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
            if !(tempArray.contains("a5")) && LoginViewController.wg != ""{
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
}



