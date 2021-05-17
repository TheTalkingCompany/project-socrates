//
//  spinner.swift
//  Socrates
//
//  Created by Harsh Patel on 3/22/21.
//  Copyright © 2021 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

var activitySpinnerView: UIView?

extension UIViewController {
    
    func showSpinner(){
        activitySpinnerView = UIView(frame: self.view.bounds)
        activitySpinnerView?.backgroundColor=UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.center=activitySpinnerView!.center
        ai.startAnimating()
        activitySpinnerView?.addSubview(ai)
        self.view.addSubview(activitySpinnerView!)
        
    }
    
    func removeSpinner(){
        activitySpinnerView?.removeFromSuperview()
        activitySpinnerView = nil
    }
    
    
}

