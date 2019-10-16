//
//  RequestedMoviesTableViewController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/4/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit
import CloudKit

class RequestedMoviesTableViewController: UITableViewController {
    
    static let sharedInstance = RequestedMoviesTableViewController()
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    var filtered: Bool = false
    var isNotDoneMovieArray: [Movie] = []
    var isDoneMovieArray: [Movie] = []
    var isDoneShowArray: [TVShow] = []
    var isNotDoneShowArray: [TVShow] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = 200
        self.tableView.reloadData()
        self.filterButton.image = UIImage(systemName: "person.crop.circle")
        self.navigationItem.title = "All Requests"
        
    }
    
    @IBAction func typeValueChanged(_ sender: Any) {
        DispatchQueue.main.async {
            self.refresh()
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        filtered = !filtered
        self.refresh()
        if filtered {
            self.filterButton.image = UIImage(systemName: "person.crop.circle.fill")
            self.navigationItem.title = "My Requests"

        } else {
            self.filterButton.image = UIImage(systemName: "person.crop.circle")
            self.navigationItem.title = "All Requests"

        }
    }
    
    
    func refresh() {
        isNotDoneMovieArray = []
        isDoneMovieArray = []
        isDoneShowArray = []
        isNotDoneShowArray = []
        if !filtered {
            if !MovieController.sharedInstance.requestedMovies.isEmpty {
                for movie in MovieController.sharedInstance.requestedMovies {
                    if movie.isDone {
                        self.isDoneMovieArray.append(movie)
                    } else {
                        self.isNotDoneMovieArray.append(movie)
                    }
                }
                self.isNotDoneMovieArray.sort(by: {$0.dateAdded > $1.dateAdded })
                self.isDoneMovieArray.sort(by: {$0.dateAdded > $1.dateAdded })
            }
            if !TVShowController.sharedInstance.requestedShows.isEmpty {
                for show in TVShowController.sharedInstance.requestedShows {
                    if show.isDone {
                        self.isDoneShowArray.append(show)
                    } else {
                        self.isNotDoneShowArray.append(show)
                    }
                }
                self.isNotDoneShowArray.sort(by: {$0.dateAdded > $1.dateAdded })
                self.isDoneShowArray.sort(by: {$0.dateAdded > $1.dateAdded })
            }
        } else {
            guard let user = UserController.sharedInstance.user else {return}
            if !MovieController.sharedInstance.requestedMovies.isEmpty {
                for movie in MovieController.sharedInstance.requestedMovies where movie.user == user.username {
                    if movie.isDone {
                        self.isDoneMovieArray.append(movie)
                    } else {
                        self.isNotDoneMovieArray.append(movie)
                    }
                }
                self.isNotDoneMovieArray.sort(by: {$0.dateAdded > $1.dateAdded })
                self.isDoneMovieArray.sort(by: {$0.dateAdded > $1.dateAdded })
            }
            if !TVShowController.sharedInstance.requestedShows.isEmpty {
                for show in TVShowController.sharedInstance.requestedShows where show.user == user.username {
                    if show.isDone {
                        self.isDoneShowArray.append(show)
                    } else {
                        self.isNotDoneShowArray.append(show)
                    }
                }
                self.isNotDoneShowArray.sort(by: {$0.dateAdded > $1.dateAdded })
                self.isDoneShowArray.sort(by: {$0.dateAdded > $1.dateAdded })
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isDone = isDoneAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        if let user = UserController.sharedInstance.user {
            if user.username == "Marcus"{
                return UISwipeActionsConfiguration(actions: [isDone, delete])
            } else {
                return nil
            }
        }
        return nil
    }
    
    func isDoneAction(at indexPath: IndexPath) -> UIContextualAction {
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            
            var movieToBeComplete: Movie? = nil
            switch indexPath.section {
            case 0:
                movieToBeComplete = isNotDoneMovieArray[indexPath.row]
            case 1:
                movieToBeComplete = isDoneMovieArray[indexPath.row]
            default:
                break
            }
            guard let movieToComplete = movieToBeComplete else {return UIContextualAction()}
            //            guard let index = MovieController.sharedInstance.requestedMovies.firstIndex(of: movieToComplete) else {return UIContextualAction()}
            //            MovieController.sharedInstance.requestedMovies[index].isDone = !MovieController.sharedInstance.requestedMovies[index].isDone
            let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                movieToComplete.isDone = !movieToComplete.isDone
                MovieController.sharedInstance.requestedMovies.append(movieToComplete)
                MovieController.sharedInstance.updateMovieStatus(movie: movieToComplete) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.refresh()
                        }
                    }
                }
                completion(true)
            }
            if !movieToComplete.isDone {
                action.image = #imageLiteral(resourceName: "checkMark")
                action.backgroundColor = .systemTeal
            } else {
                action.image = #imageLiteral(resourceName: "backArrow")
                action.backgroundColor = .systemTeal
            }
            return action
        } else {
            var showToBeComplete: TVShow? = nil
            switch indexPath.section {
            case 0:
                showToBeComplete = isNotDoneShowArray[indexPath.row]
            case 1:
                showToBeComplete = isDoneShowArray[indexPath.row]
            default:
                break
            }
            guard let showToComplete = showToBeComplete else {return UIContextualAction()}
            let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                showToComplete.isDone = !showToComplete.isDone
                TVShowController.sharedInstance.requestedShows.append(showToComplete)
                TVShowController.sharedInstance.updateShowStatus(tvShow: showToComplete) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.refresh()
                        }
                    }
                }
                completion(true)
            }
            if !showToComplete.isDone {
                action.image = #imageLiteral(resourceName: "checkMark")
                action.backgroundColor = .systemYellow
            } else {
                action.image = #imageLiteral(resourceName: "backArrow")
                action.backgroundColor = .systemTeal
            }
            return action
        }
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            
            var movieToBeComplete: Movie? = nil
            switch indexPath.section {
            case 0:
                movieToBeComplete = isNotDoneMovieArray[indexPath.row]
            case 1:
                movieToBeComplete = isDoneMovieArray[indexPath.row]
            default:
                break
            }
            guard let movieToComplete = movieToBeComplete else {return UIContextualAction()}
            guard let index = MovieController.sharedInstance.requestedMovies.firstIndex(of: movieToComplete) else {return UIContextualAction()}
            MovieController.sharedInstance.requestedMovies.remove(at: index)
            let database = CKContainer.default().publicCloudDatabase
            let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                MovieController.sharedInstance.deleteMovie(recordID: movieToComplete.recordID, database: database) { (success) in
                    DispatchQueue.main.async {
                        self.refresh()
                    }
                }
                completion(true)
            }
            action.image = #imageLiteral(resourceName: "trash-512")
            action.backgroundColor = .red
            return action
        } else {
            var showToBeComplete: TVShow? = nil
            switch indexPath.section {
            case 0:
                showToBeComplete = isNotDoneShowArray[indexPath.row]
            case 1:
                showToBeComplete = isDoneShowArray[indexPath.row]
            default:
                break
            }
            guard let showToComplete = showToBeComplete else {return UIContextualAction()}
            guard let index = TVShowController.sharedInstance.requestedShows.firstIndex(of: showToComplete) else {return UIContextualAction()}
            TVShowController.sharedInstance.requestedShows.remove(at: index)
            let database = CKContainer.default().publicCloudDatabase
            let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                TVShowController.sharedInstance.deleteShow(recordID: showToComplete.recordID, database: database) { (success) in
                    DispatchQueue.main.async {
                        self.refresh()
                    }
                }
                completion(true)
            }
            action.image = #imageLiteral(resourceName: "trash-512")
            action.backgroundColor = .red
            return action
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        var isNotDoneCount = 0
        var isDoneCount = 0
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            isNotDoneCount = self.isNotDoneMovieArray.count
            isDoneCount = self.isDoneMovieArray.count
        } else {
            isNotDoneCount = self.isNotDoneShowArray.count
            isDoneCount = self.isDoneShowArray.count
        }
        switch section {
        case 0:
            count = isNotDoneCount
        case 1:
            count = isDoneCount
        default:
            break
        }
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieResultTableViewCell
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            var movieForCell: Movie? = nil
            switch indexPath.section {
            case 0:
                movieForCell = isNotDoneMovieArray[indexPath.row]
            case 1:
                movieForCell = isDoneMovieArray[indexPath.row]
            default:
                break
            }
            
            guard let unwrappedMovie = movieForCell else {return UITableViewCell()}
            
            cell.updateCellForRequest(movie: unwrappedMovie)
            
            return cell
        } else {
            var showForCell: TVShow? = nil
            switch indexPath.section {
            case 0:
                showForCell = isNotDoneShowArray[indexPath.row]
            case 1:
                showForCell = isDoneShowArray[indexPath.row]
            default:
                break
            }
            
            guard let unwrappedShow = showForCell else {return UITableViewCell()}
            
            cell.updateCellForRequest(show: unwrappedShow)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            switch section {
            case 0:
                if isNotDoneMovieArray.isEmpty {
                    return nil
                } else {
                    title = "Requested"
                }
            case 1:
                if isDoneMovieArray.isEmpty {
                    return nil
                } else {
                    title = "Added to Server"
                }
            default:
                break
            }
            return title
        } else {
            switch section {
            case 0:
                if isNotDoneShowArray.isEmpty {
                    return nil
                } else {
                    title = "Requested"
                }
            case 1:
                if isDoneShowArray.isEmpty {
                    return nil
                } else {
                    title = "Added to Server"
                }
            default:
                break
            }
            return title
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRequestedDetailView" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MovieDetailViewController else {return}
            if typeSegmentedControl.selectedSegmentIndex == 0 {
                var movie: Movie? = nil
                switch indexPath.section {
                case 0:
                    movie = isNotDoneMovieArray[indexPath.row]
                case 1:
                    movie = isDoneMovieArray[indexPath.row]
                default:
                    break
                }
                guard let reqMovie = movie else {return}
                destinationVC.requestedMovie = reqMovie
            } else {
                var show: TVShow? = nil
                switch indexPath.section {
                case 0:
                    show = isNotDoneShowArray[indexPath.row]
                case 1:
                    show = isDoneShowArray[indexPath.row]
                default:
                    break
                }
                guard let reqShow = show else {return}
                destinationVC.requestedShow = reqShow
            }
        }
    }
    
    
}
