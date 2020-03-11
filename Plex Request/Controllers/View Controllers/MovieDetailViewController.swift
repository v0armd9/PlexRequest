//
//  MovieDetailViewController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/4/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var buyTicketLink: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    var fandangoLink: URL?
    
    var trailerID = ""
    
    var movie: MovieResult? {
        didSet {
            loadViewIfNeeded()
            guard let movie = self.movie else {return}
            titleLabel.text = movie.title
            self.ratingLabel.text = "\(movie.rating)"
            self.releaseDateLabel.text = movie.releaseDate
            self.overviewTextView.text = movie.overview
            self.posterImageView.image = movie.thumbnail
            self.backdropImageView.image = movie.backdrop
        }
    }
    
    var requestedMovie: Movie? {
        didSet {
            loadViewIfNeeded()
            guard let movie = self.requestedMovie else {return}
            self.titleLabel.text = movie.title
            self.ratingLabel.text = "\(movie.rating)"
            self.releaseDateLabel.text = movie.release_date
            self.overviewTextView.text = movie.overview
            self.posterImageView.image = movie.poster
        }
    }
    
    var show: TVShowResult? {
        didSet {
            loadViewIfNeeded()
            guard let show = self.show else {return}
            self.titleLabel.text = show.name
            self.ratingLabel.text = "\(show.rating)"
            self.overviewTextView.text = show.overview
            self.posterImageView.image = show.poster
            self.backdropImageView.image = show.backdrop
        }
    }
    
    var requestedShow: TVShow? {
        didSet {
            loadViewIfNeeded()
            guard let show = self.requestedShow else {return}
            self.titleLabel.text = show.name
            self.ratingLabel.text = "\(show.rating)"
            self.overviewTextView.text = show.overview
            self.posterImageView.image = show.poster
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.alpha = 0.3
        self.loadingView.isHidden = true
        self.hideKeyboardWhenTappedAround()
        if movie != nil {
            requestButton.setTitle("Request This Movie", for: .normal)
        } else {
            requestButton.setTitle("Request This Show", for: .normal)
        }
        updateViews()
    }
    
    @IBAction func watchTrailerButtonTapped(_ sender: UIButton) {
        // fetch movieTrailer ID
        guard let movieTitle = self.titleLabel.text else {return}
        MovieController.sharedInstance.fetchTrailerID(forTitle: movieTitle) { (trailerID) in
            self.trailerID = trailerID
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toTrailerView", sender: self)                
            }
        }
    }
    
    
    @IBAction func buyTicketButtonTapped(_ sender: UIButton) {
        guard let url = self.fandangoLink else {return}
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func requestButtonTapped(_ sender: UIButton) {
        self.loadingView.isHidden = false
        self.activityInd.startAnimating()
        self.view.isUserInteractionEnabled = false
        if let movie = movie {
            MovieController.sharedInstance.createMovieWith(searchResult: movie) { (movie) in
                if let movie = movie {
                    MovieController.sharedInstance.requestedMovies.append(movie)
                    DispatchQueue.main.async {
                        self.loadingView.isHidden = true
                        self.activityInd.stopAnimating()
                        self.requestButton.setTitle("Movie Requested!", for: .normal)
                        self.requestButton.isEnabled = false
                        self.view.isUserInteractionEnabled = true
                        
                    }
                }
            }
        } else if let show = show {
            TVShowController.sharedInstance.createTVShow(searchResult: show) { (show) in
                if let show = show {
                    TVShowController.sharedInstance.requestedShows.append(show)
                    DispatchQueue.main.async {
                        self.loadingView.isHidden = true
                        self.activityInd.stopAnimating()
                        self.requestButton.setTitle("Show Requested!", for: .normal)
                        self.requestButton.setTitleColor(.gray, for: .normal)
                        self.requestButton.layer.borderColor = UIColor.gray.cgColor
                        self.requestButton.isEnabled = false
                        self.view.isUserInteractionEnabled = true

                    }
                }
            }
        }
    }
    
    func updateViews() {
        if let movie = movie {
            for requestedMovie in MovieController.sharedInstance.requestedMovies {
                if movie.id == requestedMovie.id {
                    requestButton.setTitle("Movie Already Requested", for: .normal)
                    requestButton.setTitleColor(.gray, for: .normal)
                    requestButton.layer.borderColor = UIColor.gray.cgColor
                    requestButton.isEnabled = false
                }
            }
        } else if let show = show {
            for requestedShow in TVShowController.sharedInstance.requestedShows {
                if show.id == requestedShow.id {
                    requestButton.setTitle("Show Already Requested", for: .normal)
                    requestButton.setTitleColor(.gray, for: .normal)
                    requestButton.layer.borderColor = UIColor.gray.cgColor
                    requestButton.isEnabled = false
                }
            }
        } else if self.requestedMovie != nil {
            requestButton.isHidden = true
        } else if self.requestedShow != nil {
            requestButton.isHidden = true
        }
        if fandangoLink != nil {
            buyTicketLink.isHidden = false
        } else {
            buyTicketLink.isHidden = true
        }
        self.navigationController?.navigationBar.isTranslucent = true
        backdropImageView.alpha = 0.5
        requestButton.layer.borderWidth = 2
        guard let plexOrange = UIColor(named: "plexOrange") else {return}
        requestButton.layer.borderColor = plexOrange.cgColor
        requestButton.layer.cornerRadius = requestButton.frame.height / 2
        requestButton.titleLabel?.textColor = .black
        
        if traitCollection.userInterfaceStyle == .dark {
            requestButton.layer.borderColor = plexOrange.cgColor
            requestButton.titleLabel?.textColor = .white
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTrailerView" {
            guard let destinationVC = segue.destination as? YTPlayerViewController else {return}
            destinationVC.videoID = self.trailerID
        }
    }
}
