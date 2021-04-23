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
    @IBOutlet var rateBar: UIProgressView!
    
    func setup(with movie: MovieModel, controller: MainViewController, index: IndexPath) {
        self.movie = movie
        self.mainController = controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie?.title
        dateLabel.text = movie?.releaseDate
        overviewLabel.text = movie?.overview
        
        if let movie = movie {
            let rate = (movie.voteAverage - MovieModel.minVoteAverage)
                / (MovieModel.maxVoteAverage - MovieModel.minVoteAverage)
            rateBar.setProgress(Float(rate), animated: true)
        }
        
        guard let url = movie?.posterURL else { return }
        posterImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
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
