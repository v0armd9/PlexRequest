//
//  Movie.swift
//  Plex Request
//
//  Created by Darin Armstrong on 8/23/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit
import CloudKit

struct MovieConstants {
    static let recordType = "Movie"
    fileprivate static let titleKey = "title"
    fileprivate static let overviewKey = "overview"
    fileprivate static let releaseDateKey = "releaseDate"
    fileprivate static let ratingKey = "rating"
    fileprivate static let posterKey = "poster"
    fileprivate static let boolKey = "isDone"
    fileprivate static let idKey = "ID"
    fileprivate static let dateKey = "dateRequested"
    fileprivate static let photoAssetKey = "photoAsset"
    fileprivate static let userKey = "user"
}

class Movie {
    
    var user: String
    var title: String
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
        get{
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
    
    init(user: String, title: String, overview: String?, release_date: String?, rating: Double, isDone: Bool = false, id: Int, poster: UIImage? = nil, dateAdded: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), poster_path: String?) {
        self.user = user
        self.title = title
        self.overview = overview
        self.release_date = release_date
        self.rating = rating
        self.poster_path = poster_path
        self.isDone = isDone
        self.id = id
        self.dateAdded = dateAdded
        self.recordID = recordID
        self.poster = poster
    }
    
    convenience init?(record: CKRecord) {
        let user = record[MovieConstants.userKey] as! String
        let title = record[MovieConstants.titleKey] as! String
        guard let overview = record[MovieConstants.overviewKey] as? String,
        let poster_path = record[MovieConstants.posterKey] as? String,
        let release_date = record[MovieConstants.releaseDateKey] as? String
        else {return nil}
        let rating = record[MovieConstants.ratingKey] as! Double
        let isDone = record[MovieConstants.boolKey] as! Bool
        let id = record[MovieConstants.idKey] as! Int
        let dateAdded = record[MovieConstants.dateKey] as! Date
        var foundPhoto: UIImage?
        if let photoAsset = record[MovieConstants.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not transform asset to data")
            }
        }
        
        self.init(user: user, title: title, overview: overview, release_date: release_date, rating: rating, isDone: isDone, id: id, poster: foundPhoto, dateAdded: dateAdded, recordID: record.recordID, poster_path: poster_path)
    }
}

extension CKRecord {
    convenience init(movie: Movie) {
        self.init(recordType: MovieConstants.recordType, recordID: movie.recordID)
        self.setValue(movie.user, forKey: MovieConstants.userKey)
        self.setValue(movie.title, forKey: MovieConstants.titleKey)
        self.setValue(movie.overview, forKey: MovieConstants.overviewKey)
        self.setValue(movie.release_date, forKey: MovieConstants.releaseDateKey)
        self.setValue(movie.rating, forKey: MovieConstants.ratingKey)
        self.setValue(movie.poster_path, forKey: MovieConstants.posterKey)
        self.setValue(movie.isDone, forKey: MovieConstants.boolKey)
        self.setValue(movie.id, forKey: MovieConstants.idKey)
        self.setValue(movie.dateAdded, forKey: MovieConstants.dateKey)
        self.setValue(movie.photoAsset, forKey: MovieConstants.photoAssetKey)
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
}
