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
        //print("reload pressed in student table")
        DispatchQueue.main.async {
            self.studentTableView.reloadData()
        }
    }
    
    @IBAction private func logout() {
        UdacityClient.sharedInstance().logoutRequest { (success, error) in
            if error != nil {
                print("logout error")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction private func postLocation() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostLocationViewController") as UIViewController
        present(controller, animated: true, completion: nil)
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
