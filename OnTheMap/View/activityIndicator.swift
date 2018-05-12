//
//  activityIndicator.swift
//  OnTheMap
//
//  Created by Frank Aceves on 5/12/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func activateSpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(white: 0.10, alpha: 0.75)
        
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func deactivateSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
