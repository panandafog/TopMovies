//
//  AddNotificationController.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import UIKit

class AddNotificationController: UIViewController {
    
    var movie: MovieModel?
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker?.locale = .current
    }
    
    @IBAction func addNotificationButtonPressed(_ sender: UIButton) {
        print("Selected date/time:", datePicker.date)
    }
}
