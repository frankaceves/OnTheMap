//
//  LocationTextDelegate.swift
//  OnTheMap
//
//  Created by Frank Aceves on 5/19/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit

class LocationTextDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
