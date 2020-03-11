//
//  LoadingScreenViewController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/14/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {
    
    var isDone = false
    var fetchCount = 0
    var isDoneMovieArray: [Movie] = []
    var isNotDoneMovieArray: [Movie] = []
    var isDoneShowArray: [TVShow] = []
    var isNotDoneShowArray: [TVShow] = []
    
    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logoPulseDown()
        MovieController.sharedInstance.fetchRequestedMovies { (movies) in
            if let movies = movies {
                MovieController.sharedInstance.requestedMovies = movies
            }
            self.fetchCount += 1
            if self.fetchCount == 2 {
                self.isDone = true
            }
        }
        TVShowController.sharedInstance.fetchRequestedShows { (shows) in
            if let shows = shows {
                TVShowController.sharedInstance.requestedShows = shows
            }
            self.fetchCount += 1
            if self.fetchCount == 2 {
                self.isDone = true
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func logoPulseDown() {
        UIView.animate(withDuration: 1.5, animations: {
            self.logoImageView.alpha = 0.5
            self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(2*Double.pi))
            
        }) { (success) in
            if success {
                if !self.isDone {
                    self.logoPulseUp()
                } else {
                    UserController.sharedInstance.fetchUser { (success) in
                        DispatchQueue.main.async {
                            if success {
                                self.showTabBar()
                            } else {
                                self.showUserCreateVC()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func logoPulseUp() {
        UIView.animate(withDuration: 1.5, animations: {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.logoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(2*Double.pi))
        }) { (success) in
            if success {
                if !self.isDone {
                    self.logoPulseDown()
                } else {
                    UserController.sharedInstance.fetchUser { (success) in
                        DispatchQueue.main.async {
                            if success {
                                self.showTabBar()
                            } else {
                                self.showUserCreateVC()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "tabBarController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func showUserCreateVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "createUserVC")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
