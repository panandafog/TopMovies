//
//  ScheduleViewController.swift
//  TopMovies
//
//  Created by panandafog on 23.04.2021.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    private let service = NotificationService()
    private var notifications = [UNNotificationRequest]()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 250
        tableView.dataSource = self
        tableView.delegate = self
        
        updateTableData()
    }
    
    func updateTableData() {
        service.getScheduledMovieWatchNotifications(completion: { notifications in
            self.notifications = notifications
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell else {
            fatalError("Table view is not configured")
        }
        cell.setup(with: notifications[indexPath.row], controller: self)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
