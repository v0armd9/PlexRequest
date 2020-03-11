//
//  CreateUserViewController.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/15/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextfield.text, !username.isEmpty else {return}
        UserController.sharedInstance.createUser(username: username) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.showTabBar()
                }
            }
        }
    }
    
    func updateViews() {
        continueButton.layer.borderColor = UIColor(named: "plexOrange")?.cgColor
        continueButton.layer.borderWidth = 2
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
    }
    
    func showTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "tabBarController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}
