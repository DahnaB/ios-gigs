//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Dahna on 5/6/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK:  Action
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
