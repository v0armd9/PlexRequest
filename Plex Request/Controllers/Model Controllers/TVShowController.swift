//
//  TVShowController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/13/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class TVShowController {
    
    static let sharedInstance = TVShowController()
    
    var fetchedShows: [TVShowResult] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    var requestedShows: [TVShow] = []
    
    let baseURL = URL(string: "https://api.themoviedb.org/3")
    
    func fetchShowFor(term: String, completion: @escaping ([TVShowResult]?) -> Void) {
        
        guard var url = baseURL else {completion(nil); return}
        
        url.appendPathComponent("search")
        url.appendPathComponent("tv")
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {completion(nil); return}
        
        let apiQuery = URLQueryItem(name: "api_key", value: "1cc9f8060ce325d7b8e3eb1bc2e2ba4b")
        let searchTermQuery = URLQueryItem(name: "query", value: term)
        components.queryItems = [apiQuery, searchTermQuery]
        
        guard let finalURL = components.url else {completion(nil); return}
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("An error occured while GETting data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                guard let topLevelJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {completion(nil); return}
                let resultsArray = topLevelJSON["results"] as! [[String : AnyObject]]
                var arrayOfResults:[TVShowResult] = []
                for result in resultsArray {
                    let name = result["name"] as! String
                    let rating = result["vote_average"] as! Double
                    let overview = result["overview"] as! String
                    let releaseDate = result["first_air_date"] as? String ?? "no data"
                    let id = result["id"] as! Int
                    let posterPath = result["poster_path"] as? String ?? nil
                    let backdropPath = result["backdrop_path"] as? String ?? nil
                    let show = TVShowResult(name: name, rating: rating, overview: overview, posterPath: posterPath, backdrop_path: backdropPath, releaseDate: releaseDate, id: id)
                    arrayOfResults.append(show)
                }
                completion(arrayOfResults)
            } catch {
                print("There was an error decoding the data: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    static func fetchImageFor(tvShow: TVShowResult, completion: @escaping (UIImage?) -> Void) {
        guard var baseURL = URL(string: "https://image.tmdb.org/t/p") else {completion(nil); return}
        guard let posterExtension = tvShow.posterPath else {return}
        
        baseURL.appendPathComponent("original")
        baseURL.appendPathComponent(posterExtension)
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("There was an error with the imageURL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("There was an error retrieving an image")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    static func fetchBackdropFor(tvShow: TVShowResult, completion: @escaping (UIImage?) -> Void) {
        guard var baseURL = URL(string: "https://image.tmdb.org/t/p") else {completion(nil); return}
        guard let backdropExtension = tvShow.backdrop_path else {return}
        
        baseURL.appendPathComponent("original")
        baseURL.appendPathComponent(backdropExtension)
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("There was an error with the imageURL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("There was an error retrieving an image")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    static func fetchImageForRequested(tvShow: TVShow, completion: @escaping (UIImage?) -> Void) {
        guard var baseURL = URL(string: "https://image.tmdb.org/t/p") else {completion(nil); return}
        guard let posterExtension = tvShow.poster_path else {completion(nil); return}
        
        baseURL.appendPathComponent("original")
        baseURL.appendPathComponent(posterExtension)
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("There was an error with the imageURL: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("There was an error retrieving an image")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    func createTVShow(searchResult: TVShowResult, completion: @escaping (TVShow?) -> Void) {
        guard let user = UserController.sharedInstance.user else {return}
        let requestedTVShow = TVShow(user: user.username, name: searchResult.name, overview: searchResult.overview, release_date: searchResult.releaseDate, rating: searchResult.rating, id: searchResult.id, poster: searchResult.poster, poster_path: searchResult.posterPath)
        let record = CKRecord(tvShow: requestedTVShow)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            
            guard let record = record,
                let show = TVShow(record: record) else {completion(nil); return}
            completion(show)
        }
    }
    
    func fetchRequestedShows(completion: @escaping ([TVShow]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: TVShowConstants.recordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            
            guard let records = records else {completion(nil); return}
            let shows = records.compactMap{ TVShow(record: $0) }
            completion(shows)
        }
    }
    
    func deleteShow(recordID: CKRecord.ID, database: CKDatabase, completion: @escaping(Bool) -> Void) {
        database.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func updateShowStatus(tvShow: TVShow, completion:@escaping (Bool) ->Void) {
        let operation = CKModifyRecordsOperation()
        let record = CKRecord(tvShow: tvShow)
        operation.recordsToSave = [record]
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInitiated
        operation.completionBlock = {
            completion(true)
            print("Updated Record in CloudKit")
        }
        publicDB.add(operation)
    }
    
    func subscribeForAddedShowRemoteNotifications(completion: @escaping (_ error: Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: TVShowConstants.recordType, predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "New Request"
        notificationInfo.alertBody = "Someone requested a new TV Show in Plex Request!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(error)
            }
            completion(nil)
        }
    }
    
    func subscribeForEditedShowRemoteNotifications(completion: @escaping (_ error: Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: TVShowConstants.recordType, predicate: predicate, options: .firesOnRecordUpdate)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Status Changed"
        notificationInfo.alertBody = "The status of a requested TV Show has changed. Open plex request to check it out!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(error)
            }
            completion(nil)
        }
    }
}//end of class
