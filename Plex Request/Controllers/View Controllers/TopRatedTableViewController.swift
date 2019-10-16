//
//  TopRatedTableViewController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/15/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class TopRatedTableViewController: UITableViewController {
    
    var pageNum = 1
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = 200
        prevButton.isEnabled = false
        updateButtonAppearance()
        fetchPage(pageNum)
        
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        pageNum -= 1
        if pageNum == 1 {
            prevButton.isEnabled = false
        }
        fetchPage(pageNum)
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        pageNum += 1
        if pageNum > 1 {
            prevButton.isEnabled = true
        }
        fetchPage(pageNum)
    }
    
    func updateButtonAppearance() {
        prevButton.layer.borderWidth = 2
        prevButton.layer.borderColor = UIColor.black.cgColor
        prevButton.layer.cornerRadius = prevButton.frame.height / 2
    
        nextButton.layer.borderWidth = 2
        nextButton.layer.borderColor = UIColor.black.cgColor
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }
    
    func fetchPage(_ page: Int) {
        activityInd.isHidden = false
        activityInd.startAnimating()
        MovieController.sharedInstance.fetchTopMovies(pageNum: page) { (results) in
            if let results = results {
                let totalCount = results.count * 2
                var imageFetchCount = 0
                for movie in results {
                    MovieController.fetchBackdropFor(movie: movie) { (image) in
                        imageFetchCount += 1
                        movie.backdrop = image
                        if imageFetchCount == totalCount {
                            DispatchQueue.main.async {
                                MovieController.sharedInstance.topMovies = results
                                self.tableView.reloadData()
                                self.activityInd.isHidden = true
                                self.activityInd.stopAnimating()
                            }
                        }
                    }
                    MovieController.fetchImageFor(movie: movie) { (image) in
                        imageFetchCount += 1
                        movie.thumbnail = image
                        if imageFetchCount == totalCount {
                            DispatchQueue.main.async {
                                MovieController.sharedInstance.topMovies = results
                                self.tableView.reloadData()
                                self.activityInd.isHidden = true
                                self.activityInd.stopAnimating()
                            }
                        }
                    }
                }
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieController.sharedInstance.topMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topMovieCell", for: indexPath) as? MovieResultTableViewCell else {return UITableViewCell()}
        let movie = MovieController.sharedInstance.topMovies[indexPath.row]
        cell.updateCell(movie: movie)

        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTopDetailView" {
            guard let indexPath = self.tableView.indexPathForSelectedRow else {return}
            let movie = MovieController.sharedInstance.topMovies[indexPath.row]
            let destinationVC = segue.destination as? MovieDetailViewController
            destinationVC?.movie = movie
        }
    }

}
