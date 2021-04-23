//
//  NotificationService.swift
//  TopMovies
//
//  Created by panandafog on 23.04.2021.
//

import UserNotifications
import UIKit

class NotificationService {
    
    private let movieWatchReminderID = "movieWatchReminder"
    private let movieWatchReminderTitle = "movieWatchReminderTitle".localized
    
    func scheduleMovieWatchNotification(movie: MovieModel,
                                        date: Date,
                                        controller: UIViewController?) -> Bool {
        guard date > Date() else {
            showIncorrectDateAlert(controller: controller)
            return false
        }
        
        let content = UNMutableNotificationContent()
        content.title = movieWatchReminderTitle
        content.subtitle = movie.title
        content.categoryIdentifier = movieWatchReminderID
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        return createNotification(content: content, date: date, controller: nil)
    }
    
    func getScheduledMovieWatchNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { notifications in
            
            completion(notifications.sorted(by: {
                if let lhsTrigger = $0.trigger as? UNCalendarNotificationTrigger,
                   let lhsNotificationDate = Calendar.current.date(from: lhsTrigger.dateComponents),
                   let rhsTrigger = $1.trigger as? UNCalendarNotificationTrigger,
                   let rhsNotificationDate = Calendar.current.date(from: rhsTrigger.dateComponents) {
                    
                    return lhsNotificationDate < rhsNotificationDate
                }
                return true
            }))
        })
    }
    
    func removeScheduledMovieWatchNotification(_ notifications: [UNNotificationRequest]) {
        
        let ids = notifications.map { $0.identifier }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    func updateScheduledMovieWatchNotification(newDate: Date,
                                               notification: UNNotificationRequest,
                                               controller: UIViewController?) -> Bool {
        guard newDate > Date() else {
            showIncorrectDateAlert(controller: controller)
            return false
        }
        
        removeScheduledMovieWatchNotification([notification])
        return createNotification(content: UNMutableNotificationContent(notification.content),
                           date: newDate,
                           controller: nil)
    }
    
    private func createNotification(content: UNMutableNotificationContent,
                                    date: Date,
                                    controller: UIViewController?) -> Bool {
        guard date > Date() else {
            showIncorrectDateAlert(controller: controller)
            return false
        }
        
        let dateComponents = Calendar.current.dateComponents(
            Set(arrayLiteral:
                    Calendar.Component.year,
                    Calendar.Component.month,
                    Calendar.Component.day,
                    Calendar.Component.hour,
                    Calendar.Component.minute),
            from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("error: \(error)")
            } else {
                print("success")
            }
        })
        return true
    }
    
    private func showIncorrectDateAlert(controller: UIViewController?) {
        guard let controller = controller else {
            return
        }
        
        let alert = UIAlertController(
            title: "incorrectDateAlertTitle".localized,
            message: "incorrectDateAlertMessage".localized,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        controller.present(alert, animated: true, completion: nil)
    }
}

extension UNMutableNotificationContent {
    
    convenience init(_ content: UNNotificationContent) {
        self.init()
        
        self.title = content.title
        self.subtitle = content.subtitle
        self.categoryIdentifier = content.categoryIdentifier
        self.sound = content.sound
        self.badge = content.badge
    }
}
