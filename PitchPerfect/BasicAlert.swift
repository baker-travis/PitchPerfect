//
//  BasicAlert.swift
//  PitchPerfect
//
//  Created by Baker, Travis on 1/19/17.
//  Copyright © 2017 Baker, Travis. All rights reserved.
//

import UIKit

class BasicAlert {
    let alert: UIAlertController
    
    init(title: String, message: String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    }
    
    func show(in parentVC: UIViewController, animated: Bool = true) {
        parentVC.present(alert, animated: animated, completion: nil)
    }
}
