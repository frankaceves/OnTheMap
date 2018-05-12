//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Frank Aceves on 4/8/18.
//  Copyright © 2018 Frank Aceves. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    // MARK: - PROPERTIES
    var students: [StudentInformation] = [StudentInformation]()
    
    @IBOutlet var studentTableView: UITableView!
    
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        studentTableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ParseClient.sharedInstance().getStudentInfo { (results, error) in
            if let results = results {
                self.students = results

                DispatchQueue.main.async {
                    self.studentTableView.reloadData()
                }
            } else {
                print(error!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // create and set the logout button
//        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        
        // create and set the reload button
        //parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "RELOAD", style: .plain, target: self, action: #selector(reloadStudentInfo))
//        parent!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadStudentInfo))
//        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadStudentInfo))
//
//        let postButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postLocation))
//        parent!.navigationItem.rightBarButtonItems = [reloadButton, postButton]
    }
    
    @IBAction func reloadStudentInfo() {
        print("reload pressed in student table")
        //add activity indicator
        let activityIndicator = UIViewController.activateSpinner(onView: self.tableView)
        
        ParseClient.sharedInstance().getStudentInfo { (results, error) in
            if let results = results {
                self.students = results
                
                DispatchQueue.main.async {
                    UIViewController.deactivateSpinner(spinner: activityIndicator)
                    self.studentTableView.reloadData()
                }
            } else {
                print(error!)
            }
        }
    }
    
    @IBAction private func logout() {
        UdacityClient.sharedInstance().logoutRequest { (success, error) in
            if error != nil {
                print("logout error")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction private func postLocationPressed() {
        //when button clicked, check for object ID
        ParseClient.sharedInstance().checkForObjectId(UdacityClient.Constants.studentKey) { (success) in
            if !success {
                //if no objectID, instantiate PostLocationVC
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostLocationViewController") as UIViewController
                self.present(controller, animated: true, completion: nil)
            } else {
                //if objectID exists, notification for overwrite
                let alert = UIAlertController(title: nil, message: "User \"\(UdacityClient.Constants.firstName) \(UdacityClient.Constants.lastName)\" has already posted a Student Location. Would you like to overwrite their location?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
                    print("overwrite pressed")
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostLocationViewController") as UIViewController
                    self.present(controller, animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        
        
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 50
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "studentCell"
        let student = students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // Configure the cell...
        // PIN IMAGE
        cell?.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        // NAME / TITLE
        if let firstName = student.studentFirstName, firstName != "" {
            if let lastName = student.studentLastName, lastName != "" {
                    cell?.textLabel!.text = "\(firstName) \(lastName)"
            } else {
                cell?.textLabel!.text = firstName
            }
        } else {
            cell?.textLabel!.text = "Student Name Unknown"
        }
        //account for "" entered as first & last name
        
        // URL
        if let url = student.studentMediaURL, url != "" {
            cell?.detailTextLabel?.text = url
        } else {
            cell?.detailTextLabel?.text = "No Student URL Provided"
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[(indexPath as NSIndexPath).row]
        if let studentURLstring = student.studentMediaURL, let studentURL = URL(string: studentURLstring) {
            if UIApplication.shared.canOpenURL(studentURL) {
                UIApplication.shared.open(studentURL, options: [:]) { (success) in
                }
            } else {
                print("this url is not valid")
            }
        }
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
