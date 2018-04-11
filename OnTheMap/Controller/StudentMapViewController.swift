//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Frank Anthony Aceves on 4/10/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit

class StudentMapViewController: UIViewController {
    // - MARK: PROPERTIES
    //TODO: set up mapview property (to reload when reload button is pressed).
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("student map loaded")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // create and set the logout button
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        
        // create and set the reload button
        //parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "RELOAD", style: .plain, target: self, action: #selector(reloadStudentInfo))
        //        parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadStudentInfo))
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadStudentInfo))
        
        let postButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(reloadStudentInfo))
        parent!.navigationItem.rightBarButtonItems = [reloadButton, postButton]
    }
    
    @objc func reloadStudentInfo() {
        print("reload pressed in student Map")
        // reload map view
        
    }
    
    @objc func logout() {
        UdacityClient.sharedInstance().logoutRequest { (success, error) in
            if error != nil {
                print("logout error")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
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
