//
//  MovieCell.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import Kingfisher
import UIKit

class MovieCell: UITableViewCell {
    
    private var movie: MovieModel?
    private var mainController: MainViewController?
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var rateBar: UIProgressView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        posterImageView.kf.cancelDownloadTask()
    }

    func setup(with movie: MovieModel, controller: MainViewController) {
        self.movie = movie
        self.mainController = controller
        
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        overviewLabel.text = movie.overview
        
        let rate = (movie.voteAverage - MovieModel.minVoteAverage)
            / (MovieModel.maxVoteAverage - MovieModel.minVoteAverage)
        rateBar.setProgress(Float(rate), animated: true)
        
        guard let url = movie.posterURL else { return }
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
        mainController?.navigationController?.present(viewController, animated: true)
    }
}
