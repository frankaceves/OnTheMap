//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Frank Aceves on 4/18/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit

class PostLocationViewController: UIViewController {
    // MARK: - PROPERTIES
    
    @IBOutlet weak var locationStringTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPosting(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        //disable UI
        if locationStringTextField.text!.isEmpty || urlTextField.text!.isEmpty {
            print("location and url are required!")
            //enable UI
        } else {
            let userLocation = locationStringTextField.text!
            //print(locationStringTextField.text!, urlTextField.text!)
            //print("next step: execute geocode, then parse POST method")
            ParseClient.sharedInstance().findStudentLocation(location: userLocation)
            //call parse function
                //get mapString
                //geocode into lat/long
                //present another map view?
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
