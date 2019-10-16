//
//  SearchTableViewController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/4/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //elf.hideKeyboardWhenTappedAround()
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = 200
        if traitCollection.userInterfaceStyle == .dark {
            self.searchBar.searchTextField.backgroundColor = .darkGray
            self.searchBar.barTintColor = .black
            let glassIconView = searchBar.searchTextField.leftView as? UIImageView
            glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
            glassIconView?.tintColor = .black
            let clearButton = searchBar.searchTextField.value(forKey: "clearButton") as! UIButton
            clearButton.setImage(UIImage(named: "ic_clear"), for: .normal)
            clearButton.tintColor = .black
        }
    }
    

    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        searchBarTextDidEndEditing(searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tapGesture.isEnabled = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetch()
    }
    
    @IBAction func typeValueChanged(_ sender: Any) {
        fetch()
    }
    
    @IBAction func tappedAround(_ sender: UITapGestureRecognizer) {
        searchBarTextDidEndEditing(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        resignFirstResponder()
        tapGesture.isEnabled = false
    }
    
    func fetch() {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
        searchBar.searchTextField.resignFirstResponder()
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            MovieController.sharedInstance.fetchMovieFor(term: searchTerm) { (results) in
                if let results = results {
                    MovieController.sharedInstance.fetchedMovies = results
                    for movie in MovieController.sharedInstance.fetchedMovies {
                        MovieController.fetchBackdropFor(movie: movie) { (image) in
                            movie.backdrop = image
                        }
                        MovieController.fetchImageFor(movie: movie) { (image) in
                            movie.thumbnail = image
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        } else if typeSegmentedControl.selectedSegmentIndex == 1 {
            TVShowController.sharedInstance.fetchShowFor(term: searchTerm) { (results) in
                if let results = results {
                    TVShowController.sharedInstance.fetchedShows = results
                    for show in TVShowController.sharedInstance.fetchedShows {
                        TVShowController.fetchBackdropFor(tvShow: show) { (image) in
                            show.backdrop = image
                        }
                        TVShowController.fetchImageFor(tvShow: show) { (image) in
                            show.poster = image
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            return MovieController.sharedInstance.fetchedMovies.count
        } else {
            return TVShowController.sharedInstance.fetchedShows.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResult", for: indexPath) as? MovieResultTableViewCell else {return UITableViewCell()}
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            let movie = MovieController.sharedInstance.fetchedMovies[indexPath.row]
            cell.updateCell(movie: movie)
        } else {
            let show = TVShowController.sharedInstance.fetchedShows[indexPath.row]
            cell.updateCell(show: show)
        }

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MovieDetailViewController else {return}
            if typeSegmentedControl.selectedSegmentIndex == 0 {
                let movie = MovieController.sharedInstance.fetchedMovies[indexPath.row]
                destinationVC.movie = movie
            } else {
                let show = TVShowController.sharedInstance.fetchedShows[indexPath.row]
                destinationVC.show = show
            }
        }
    }


}
