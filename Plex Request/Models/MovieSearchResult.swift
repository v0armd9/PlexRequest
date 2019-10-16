//
//  MovieSearchResult.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/4/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import Foundation
import UIKit

//struct TopLevelJSON: Codable {
//    let results: [MovieResult]
//}

class MovieResult {
    let title: String
    let rating: Double
    let overview: String
    let poster: String?
    let backdrop_path: String?
    var backdrop: UIImage?
    var thumbnail: UIImage?
    let releaseDate: String
    let id: Int
    
    init(title: String, rating: Double, overview: String, poster: String?, backdrop_path: String?, backdrop: UIImage? = nil, thumbnail: UIImage? = nil, releaseDate: String, id: Int) {
        
        self.title = title
        self.rating = rating
        self.overview = overview
        self.poster = poster
        self.backdrop_path = backdrop_path
        self.backdrop = backdrop
        self.thumbnail = thumbnail
        self.releaseDate = releaseDate
        self.id = id
    }
//    enum CodingKeys: String, CodingKey {
//        case title
//        case rating = "vote_average"
//        case overview
//        case poster = "poster_path"
//        case releaseDate = "release_date"
//        case id
//    }
}
