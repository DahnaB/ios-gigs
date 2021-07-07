//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Dahna on 5/5/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    let reuseIdentifier = "GigCell"
    let gigController = GigController()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer != nil {
            
            gigController.fetchAllGigs { result in
                if let fetchedGigs = try? result.get() {
                    DispatchQueue.main.async {
                        self.gigController.gigs = fetchedGigs
                        self.tableView.reloadData()
                        print("reloaded")
                        print("\(self.gigController.gigs)")
                    }
                }
            }
        } else {
            performSegue(withIdentifier: "ShowLoginVC", sender: self)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = gigController.gigs[indexPath.row].title
        cell.detailTextLabel?.text = dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLoginVC" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "ShowGigSegue" {
            if let gigVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                gigVC.gigController = gigController
                gigVC.gig = gigController.gigs[indexPath.row]
            }
        } else if segue.identifier == "AddGigSegue" {
            if let gigVC = segue.destination as? GigDetailViewController {
                gigVC.gigController = gigController
            }
        }
    }
}

