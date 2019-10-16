//
//  TVShow.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/13/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit
import CloudKit

struct TVShowConstants {
    static let recordType = "TVShow"
    fileprivate static let nameKey = "name"
    fileprivate static let overviewKey = "overview"
    fileprivate static let releaseDateKey = "releaseDate"
    fileprivate static let ratingKey = "rating"
    fileprivate static let posterKey = "poster"
    fileprivate static let boolKey = "isDone"
    fileprivate static let idKey = "ID"
    fileprivate static let dateKey = "dateAdded"
    fileprivate static let photoAssetKey = "photoAsset"
    fileprivate static let userKey = "user"
}

class TVShow {
    
    var user: String
    var name: String
    var overview: String?
    var release_date: String?
    var rating: Double
    var poster_path: String?
    var isDone: Bool
    var id: Int
    var poster: UIImage? {
        get {
            guard let photoData = self.photoData else {return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data?
    var photoAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    var dateAdded: Date
    var recordID: CKRecord.ID
    
    init(user: String, name: String, overview: String?, release_date: String?, rating: Double, isDone: Bool = false, id: Int, dateAdded: Date = Date(), poster: UIImage? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), poster_path: String?) {
        self.user = user
        self.name = name
        self.overview = overview
        self.release_date = release_date
        self.rating = rating
        self.poster_path = poster_path
        self.isDone = isDone
        self.recordID = recordID
        self.id = id
        self.dateAdded = dateAdded
        self.poster = poster
    }
    
    convenience init?(record: CKRecord) {
        let user = record[TVShowConstants.userKey] as! String
        let name = record[TVShowConstants.nameKey] as! String
        guard let overview = record[TVShowConstants.overviewKey] as? String,
        let poster_path = record[TVShowConstants.posterKey] as? String,
        let release_date = record[TVShowConstants.releaseDateKey] as? String
        else {return nil}
        let rating = record[TVShowConstants.ratingKey] as! Double
        let isDone = record[TVShowConstants.boolKey] as! Bool
        let id = record[TVShowConstants.idKey] as! Int
        let dateAdded = record[TVShowConstants.dateKey] as! Date
        var foundPhoto: UIImage?
        if let photoAsset = record[TVShowConstants.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not transform asset to data")
            }
        }
        
        
        self.init(user: user, name: name, overview: overview, release_date: release_date, rating: rating, isDone: isDone, id: id, dateAdded: dateAdded, poster: foundPhoto, recordID: record.recordID, poster_path: poster_path)
    }
}

extension CKRecord {
    convenience init(tvShow: TVShow) {
        self.init(recordType: TVShowConstants.recordType, recordID: tvShow.recordID)
        self.setValue(tvShow.user, forKey: TVShowConstants.userKey)
        self.setValue(tvShow.name, forKey: TVShowConstants.nameKey)
        self.setValue(tvShow.overview, forKey: TVShowConstants.overviewKey)
        self.setValue(tvShow.release_date, forKey: TVShowConstants.releaseDateKey)
        self.setValue(tvShow.rating, forKey: TVShowConstants.ratingKey)
        self.setValue(tvShow.poster_path, forKey: TVShowConstants.posterKey)
        self.setValue(tvShow.isDone, forKey: TVShowConstants.boolKey)
        self.setValue(tvShow.id, forKey: TVShowConstants.idKey)
        self.setValue(tvShow.dateAdded, forKey: TVShowConstants.dateKey)
        self.setValue(tvShow.photoAsset, forKey: TVShowConstants.photoAssetKey)
    }
}

extension TVShow: Equatable {
    static func == (lhs: TVShow, rhs: TVShow) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
}
