//
//  TVShowResult.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/13/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class TVShowResult {
    let name: String
    let rating: Double
    let overview: String
    let posterPath: String?
    let backdrop_path: String?
    var backdrop: UIImage?
    var poster: UIImage?
    let releaseDate: String
    let id: Int
    
    init(name: String, rating: Double, overview: String, posterPath: String?, backdrop_path: String?, backdrop: UIImage? = nil, thumbnail: UIImage? = nil, releaseDate: String, id: Int) {
        
        self.name = name
        self.rating = rating
        self.overview = overview
        self.posterPath = posterPath
        self.backdrop_path = backdrop_path
        self.backdrop = backdrop
        self.poster = thumbnail
        self.releaseDate = releaseDate
        self.id = id
    }
}
