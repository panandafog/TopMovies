//
//  MovieFacade.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import RealmSwift

class MovieFacade {
    typealias UpdateMoviesDataChangedCompletion = ([MovieModel]?) -> Void
    typealias UpdateMoviesRequestCompletion = () -> Void
    
    let movieRepository = MovieRepository(configuration: .defaultConfiguration)
    let movieService = MovieService()
    private var movieToken: NotificationToken?

    func loadMore(controller: UIViewController?,
                  requestCompletion: UpdateMoviesRequestCompletion? = nil) {
        let originalMovieCount = self.movieRepository.count()
        movieService.getMovies(newPage: true, controller: controller, completion: { movies in
            
            guard let movies = movies else {
                return
            }
            self.movieRepository.save(movies)
            if self.movieRepository.count() <= originalMovieCount {
                self.loadMore(controller: controller)
            }
        })
    }

    func getMovies(controller: UIViewController?, dataChangedCompletion: @escaping UpdateMoviesDataChangedCompletion, requestCompletion: UpdateMoviesRequestCompletion? = nil) {
        movieService.getMovies(newPage: false, controller: controller, completion: { movies in
            requestCompletion?()
            
            guard let movies = movies else {
                return
            }
            self.movieRepository.save(movies)
        })
        
        let movies = movieRepository.getMovies()
        movieToken = movies.observe { _ in
            
            var models = [MovieModel]()
            for movie in movies {
                if let model = movie.model {
                    models.append(model)
                }
            }
            dataChangedCompletion(models)
        }
    }
}
