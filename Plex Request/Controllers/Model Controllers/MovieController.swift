//
//  MovieController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/4/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class MovieController {
    
    static let sharedInstance = MovieController()
        
    var fetchedMovies: [MovieResult] = []
    
    var topMovies: [MovieResult] = []
    
    var nowPlayingMovies: [MovieResult] = []
    
    var upcomingMovies: [MovieResult] = []

    var requestedMovies: [Movie] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    let baseURL = URL(string: "https://api.themoviedb.org/3")
    
    func fetchMovieFor(term: String, completion: @escaping ([MovieResult]?) -> Void) {
        
        guard var url = baseURL else {completion(nil); return}
        
        url.appendPathComponent("search")
        url.appendPathComponent("movie")
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
                var arrayOfResults:[MovieResult] = []
                for result in resultsArray {
                    let title = result["title"] as! String
                    let rating = result["vote_average"] as! Double
                    let overview = result["overview"] as! String
                    let releaseDate = result["release_date"] as! String
                    let id = result["id"] as! Int
                    let posterPath = result["poster_path"] as? String ?? nil
                    let backdropPath = result["backdrop_path"] as? String ?? nil
                    let movie = MovieResult(title: title, rating: rating, overview: overview, poster: posterPath, backdrop_path: backdropPath, releaseDate: releaseDate, id: id)
                    arrayOfResults.append(movie)
                }
              completion(arrayOfResults)
            } catch {
                print("There was an error decoding the data: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    func fetchTopMovies(pageNum: Int, completion: @escaping ([MovieResult]?) -> Void) {
        
        guard var url = baseURL else {completion(nil); return}
        let pageNumString = String(pageNum)
        url.appendPathComponent("movie")
        url.appendPathComponent("top_rated")
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {completion(nil); return}
        
        let apiQuery = URLQueryItem(name: "api_key", value: "1cc9f8060ce325d7b8e3eb1bc2e2ba4b")
        let languageQuery = URLQueryItem(name: "language", value: "en-US")
        let pageQuery = URLQueryItem(name: "page", value: pageNumString)
        components.queryItems = [apiQuery, languageQuery, pageQuery]
        
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
                var arrayOfResults:[MovieResult] = []
                for result in resultsArray {
                    let title = result["title"] as! String
                    let rating = result["vote_average"] as! Double
                    let overview = result["overview"] as! String
                    let releaseDate = result["release_date"] as! String
                    let id = result["id"] as! Int
                    let posterPath = result["poster_path"] as? String ?? nil
                    let backdropPath = result["backdrop_path"] as? String ?? nil
                    let movie = MovieResult(title: title, rating: rating, overview: overview, poster: posterPath, backdrop_path: backdropPath, releaseDate: releaseDate, id: id)
                    arrayOfResults.append(movie)
                }
              completion(arrayOfResults)
            } catch {
                print("There was an error decoding the data: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    func fetchNowPlayingMovies(pageNum: Int, completion: @escaping ([MovieResult]?) -> Void) {
        
        guard var url = baseURL else {completion(nil); return}
        let pageNumString = String(pageNum)
        url.appendPathComponent("movie")
        url.appendPathComponent("now_playing")
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {completion(nil); return}
        
        let apiQuery = URLQueryItem(name: "api_key", value: "1cc9f8060ce325d7b8e3eb1bc2e2ba4b")
        let languageQuery = URLQueryItem(name: "language", value: "en-US")
        let pageQuery = URLQueryItem(name: "page", value: pageNumString)
        components.queryItems = [apiQuery, languageQuery, pageQuery]
        
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
                var arrayOfResults:[MovieResult] = []
                for result in resultsArray {
                    let title = result["title"] as! String
                    let rating = result["vote_average"] as! Double
                    let overview = result["overview"] as! String
                    let releaseDate = result["release_date"] as! String
                    let id = result["id"] as! Int
                    let posterPath = result["poster_path"] as? String ?? nil
                    let backdropPath = result["backdrop_path"] as? String ?? nil
                    let movie = MovieResult(title: title, rating: rating, overview: overview, poster: posterPath, backdrop_path: backdropPath, releaseDate: releaseDate, id: id)
                    arrayOfResults.append(movie)
                }
              completion(arrayOfResults)
            } catch {
                print("There was an error decoding the data: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    func fetchUpcomingMovies(pageNum: Int, completion: @escaping ([MovieResult]?) -> Void) {
        
        guard var url = baseURL else {completion(nil); return}
        let pageNumString = String(pageNum)
        url.appendPathComponent("movie")
        url.appendPathComponent("upcoming")
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {completion(nil); return}
        
        let apiQuery = URLQueryItem(name: "api_key", value: "1cc9f8060ce325d7b8e3eb1bc2e2ba4b")
        let languageQuery = URLQueryItem(name: "language", value: "en-US")
        let pageQuery = URLQueryItem(name: "page", value: pageNumString)
        components.queryItems = [apiQuery, languageQuery, pageQuery]
        
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
                var arrayOfResults:[MovieResult] = []
                for result in resultsArray {
                    let title = result["title"] as! String
                    let rating = result["vote_average"] as! Double
                    let overview = result["overview"] as! String
                    let releaseDate = result["release_date"] as! String
                    let id = result["id"] as! Int
                    let posterPath = result["poster_path"] as? String ?? nil
                    let backdropPath = result["backdrop_path"] as? String ?? nil
                    let movie = MovieResult(title: title, rating: rating, overview: overview, poster: posterPath, backdrop_path: backdropPath, releaseDate: releaseDate, id: id)
                    arrayOfResults.append(movie)
                }
              completion(arrayOfResults)
            } catch {
                print("There was an error decoding the data: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }.resume()
    }
    
    static func fetchImageFor(movie: MovieResult, completion: @escaping (UIImage?) -> Void) {
        guard var baseURL = URL(string: "https://image.tmdb.org/t/p") else {completion(nil); return}
        guard let posterExtension = movie.poster else {return}
        
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
    
    static func fetchBackdropFor(movie: MovieResult, completion: @escaping (UIImage?) -> Void) {
        guard var baseURL = URL(string: "https://image.tmdb.org/t/p") else {completion(nil); return}
        guard let backdropExtension = movie.backdrop_path else {return}
        
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
    
    static func fetchImageForRequested(movie: Movie, completion: @escaping (UIImage?) -> Void) {
        guard var baseURL = URL(string: "https://image.tmdb.org/t/p") else {completion(nil); return}
        guard let posterExtension = movie.poster_path else {completion(nil); return}
        
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
    
    func createMovieWith(searchResult: MovieResult, completion: @escaping (Movie?) -> Void) {
        guard let user = UserController.sharedInstance.user else {return}
        let requestedMovie = Movie(user: user.username , title: searchResult.title, overview: searchResult.overview, release_date: searchResult.releaseDate, rating: searchResult.rating, id: searchResult.id, poster: searchResult.thumbnail, poster_path: searchResult.poster)
        let record = CKRecord(movie: requestedMovie)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            
            guard let record = record,
                let movie = Movie(record: record) else {completion(nil); return}
            completion(movie)
        }
    }
    
    func fetchRequestedMovies(completion: @escaping ([Movie]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: MovieConstants.recordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            
            guard let records = records else {completion(nil); return}
            let movies = records.compactMap{ Movie(record: $0) }
            completion(movies)
        }
    }
    
    func deleteMovie(recordID: CKRecord.ID, database: CKDatabase, completion: @escaping(Bool) -> Void) {
        database.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func updateMovieStatus(movie: Movie, completion:@escaping (Bool) ->Void) {
        let operation = CKModifyRecordsOperation()
        let record = CKRecord(movie: movie)
        operation.recordsToSave = [record]
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInitiated
        operation.completionBlock = {
            print("Updated Record in CloudKit")
            completion(true)
        }
        publicDB.add(operation)
    }
    
    private func deleteFromCloud(recordID: CKRecord.ID, database: CKDatabase, completion: @escaping(Bool) -> Void) {
        database.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
            }
            completion(true)
        }
    }
    
    func subscribeForAddedMovieRemoteNotifications(completion: @escaping (_ error: Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: MovieConstants.recordType, predicate: predicate, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "New Request"
        notificationInfo.alertBody = "Someone requested a new Movie in Plex Request!"
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
    
    func subscribeForEditedMovieRemoteNotifications(completion: @escaping (_ error: Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: MovieConstants.recordType, predicate: predicate, options: .firesOnRecordUpdate)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "Status Changed"
        notificationInfo.alertBody = "A Movie has been added to the server. Check it out!"
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
    
    func resetBadgeCounter() {
        let badgeResetOperation = CKModifyBadgeOperation(badgeValue: 0)
        badgeResetOperation.modifyBadgeCompletionBlock = { (error) -> Void in
            if error != nil {
                print("error resetting badge: \(String(describing: error))")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
        CKContainer.default().add(badgeResetOperation)
    }
    
}//end of class
