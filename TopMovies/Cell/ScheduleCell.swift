//
//  ScheduleCell.swift
//  TopMovies
//
//  Created by panandafog on 23.04.2021.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    private var tableViewController: ScheduleViewController?
    private var notification: UNNotificationRequest?
    private let notificationService = NotificationService()
    private var notificationDate: Date?
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    func setup(with notification: UNNotificationRequest, controller: ScheduleViewController) {
        self.notification = notification
        self.tableViewController = controller
        
        movieTitleLabel.text = notification.content.subtitle
        
        let trigger = notification.trigger as? UNCalendarNotificationTrigger
        if let dateComponents = trigger?.dateComponents,
           let notificationDate = Calendar.current.date(from: dateComponents) {
            datePicker.date = notificationDate
            self.notificationDate = notificationDate
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
        //        guard let notification = self.notification else {
        //            return
        //        }
        //        let success = notificationService.updateScheduledMovieWatchNotification(
        //            newDate: datePicker.date,
        //            notification: notification,
        //            controller: tableViewController)
        //
        //        if success {
        //            tableViewController?.updateTableData(completion: nil)
        //        }
    }
    
    
    @IBAction func exitFromDatePicker(_ sender: UIDatePicker) {
        
        guard let notification = self.notification else {
            return
        }
        let success = notificationService.updateScheduledMovieWatchNotification(
            newDate: datePicker.date,
            notification: notification,
            controller: tableViewController)
        
        if success {
            tableViewController?.updateTableData(completion: nil)
        } else {
            if let notificationDate = self.notificationDate {
                datePicker.date = notificationDate
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        guard let notification = self.notification else {
            return
        }
        notificationService.removeScheduledMovieWatchNotification([notification])
        
        tableViewController?.updateTableData(completion: nil)
    }
}
