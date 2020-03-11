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
    @IBOutlet weak var completeIcon: UIImageView!
    
    func updateCell(movie: MovieResult) {
        completeIcon.isHidden = true
        movieImageView?.image = nil
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = "\(movie.rating)"
        movieImageView?.image = movie.thumbnail
    }
    
    func updateCellForRequest(movie: Movie) {
        if movie.isDone {
            completeIcon.isHidden = false
        } else {
            completeIcon.isHidden = true
        }
        movieImageView?.image = nil
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = "\(movie.rating)"
        movieImageView?.image = movie.poster
    }
    
    func updateCell(show: TVShowResult) {
        completeIcon.isHidden = true
        movieImageView.image = nil
        movieTitleLabel.text = show.name
        movieRatingLabel.text = "\(show.rating)"
        movieImageView.image = show.poster
    }
    
    func updateCellForRequest(show: TVShow) {
        if show.isDone {
            completeIcon.isHidden = false
        } else {
            completeIcon.isHidden = true
        }
           movieImageView?.image = nil
           movieTitleLabel.text = show.name
           movieRatingLabel.text = "\(show.rating)"
           movieImageView?.image = show.poster
       }
}
