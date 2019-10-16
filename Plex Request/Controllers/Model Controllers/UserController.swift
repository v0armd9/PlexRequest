//
//  UserController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/15/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let sharedInstance = UserController()
    
    var user: User? = nil
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    func createUser(username: String, completion: @escaping (Bool) -> Void) {
        let newUser = User(username: username)
        let record = CKRecord(user: newUser)
        
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            if let record = record {
                let savedUser = User(record: record)
                self.user = savedUser
                completion(true)
            } else {
                completion(false)
                return
            }
        }
    }
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: UserConstants.recordType, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            if let record = record {
                let fetchedUser = User(record: record[0])
                self.user = fetchedUser
                completion(true)
            } else {
                completion(false)
                return
            }
        }
    }
}
