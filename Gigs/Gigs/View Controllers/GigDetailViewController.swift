//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Dahna on 5/6/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    // MARK: Properties
    var gigController: GigController!
    var gig: Gig?
    
    // MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK:  Action
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
         
            let date = datePicker.date
            guard let title = titleTextField.text,
                let description = descriptionTextView.text else { return }
        
        let newGig = Gig(title: title, dueDate: date, description: description)
        
        
            
    }
        

    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        if gig == nil {
            self.title = "New Gig"
        } else {
            titleTextField?.text = gig?.title
            datePicker.date = gig?.dueDate ?? Date()
            descriptionTextView.text = gig?.description
        }
    }

}
