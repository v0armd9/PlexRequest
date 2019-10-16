//
//  tapToDismissKeyboardExtension.swift
//  Plex Request
//
//  Created by Darin Armstrong on 10/15/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
