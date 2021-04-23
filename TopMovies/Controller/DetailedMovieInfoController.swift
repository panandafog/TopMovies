//
//  DetailedMovieInfoController.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import UIKit

class DetailedMovieInfoController: UIViewController {
    
    private var movie: MovieModel?
    private var mainController: MainViewController?
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    func setup(with movie: MovieModel, controller: MainViewController, index: IndexPath) {
        self.movie = movie
        self.mainController = controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie?.title
        dateLabel.text = movie?.releaseDate
        overviewLabel.text = movie?.overview
        
        guard let url = movie?.posterURL else { return }
        posterImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func scheduleViewingButtonPressed(_ sender: UIButton) {
        
        guard let viewController = UIStoryboard(name: "AddNotification", bundle: nil)
                .instantiateViewController(withIdentifier: "AddNotificationController") as? AddNotificationController else {
            return
        }
        
        viewController.setup(with: movie, controller: mainController)
        mainController?.dismiss(animated: true, completion: {
            self.mainController?.navigationController?.present(viewController, animated: true)
        })
    }
}
