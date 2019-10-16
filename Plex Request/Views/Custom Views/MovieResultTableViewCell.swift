//
//  MovieResultTableViewCell.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/4/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class MovieResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    func updateCell(movie: MovieResult) {
        movieImageView?.image = nil
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = "\(movie.rating)"
        movieImageView?.image = movie.thumbnail
    }
    
    func updateCellForRequest(movie: Movie) {
        movieImageView?.image = nil
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = "\(movie.rating)"
        movieImageView?.image = movie.poster
    }
    
    func updateCell(show: TVShowResult) {
        movieImageView.image = nil
        movieTitleLabel.text = show.name
        movieRatingLabel.text = "\(show.rating)"
        movieImageView.image = show.poster
    }
    
    func updateCellForRequest(show: TVShow) {
           movieImageView?.image = nil
           movieTitleLabel.text = show.name
           movieRatingLabel.text = "\(show.rating)"
           movieImageView?.image = show.poster
       }
}
