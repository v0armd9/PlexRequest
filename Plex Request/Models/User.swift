//
//  User.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/15/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import Foundation
import CloudKit

struct UserConstants {
    static let recordType = "User"
    fileprivate static let usernameKey = "username"
    
}

class User {
    
    let username: String
    let recordID: CKRecord.ID
    
    init(username: String, recordID: CKRecord.ID = CKRecord.ID(recordName: (UUID().uuidString))) {
        
        self.username = username
        self.recordID = recordID
    }
    
    convenience init?(record: CKRecord) {
        let username = record[UserConstants.usernameKey] as! String
        
        self.init(username: username, recordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserConstants.recordType, recordID: user.recordID)
        self.setValue(user.username, forKey: UserConstants.usernameKey)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
