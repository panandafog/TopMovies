//
//  AddNotificationController.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import UIKit
import UserNotifications

class AddNotificationController: UIViewController {
    
    private var movie: MovieModel?
    private var mainController: MainViewController?
    private var notificationService = NotificationService()
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker?.locale = .current
    }
    
    func setup(with movie: MovieModel?, controller: MainViewController?) {
        self.movie = movie
        self.mainController = controller
    }
    
    @IBAction func addNotificationButtonPressed(_ sender: UIButton) {
        guard let movie = self.movie else {
            return
        }
        
        guard datePicker.date > Date() else {
            showIncorrectDateAlert()
            return
        }
        
        notificationService.scheduleMovieWatchNotification(movie: movie, date: datePicker.date)
        mainController?.dismiss(animated: true, completion: {
        })
    }
    
    private func showIncorrectDateAlert() {
        let alert = UIAlertController(title: "Incorrect date", message: "Please select date after today", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
