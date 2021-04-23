//
//  ViewController.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let facade = MovieFacade()
    private var movies = [MovieModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 250
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        self.tableView.refreshControl?.beginRefreshing()
        updateTableData()
    }
    
    func updateTableData() {
        
        facade.getMovies(controller: self, dataChangedCompletion: { newMovies in
            
            guard let newMovies = newMovies else { return }
            
            self.movies = newMovies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, requestCompletion: {
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        })
    }
    
    @objc func handleRefreshControl() {
        facade.movieRepository.clear()
        updateTableData()
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            fatalError("Table view is not configured")
        }
        
        let movie = movies[indexPath.row]
        cell.setup(with: movie, controller: self)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == movies.count - 1 else { return }
        facade.loadMore(controller: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "DetailedMovieInfo", bundle: nil)
                .instantiateViewController(withIdentifier: "DetailedMovieInfoViewController") as? DetailedMovieInfoController else {
            return
        }
        
        let movie = movies[indexPath.row]
        viewController.setup(with: movie, controller: self, index: indexPath)
        
        navigationController?.present(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

