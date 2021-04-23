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
        
        let success = notificationService.scheduleMovieWatchNotification(
            movie: movie,
            date: datePicker.date,
            controller: self)
        
        if success {
            mainController?.dismiss(animated: true, completion: {
            })
        }
    }
}
