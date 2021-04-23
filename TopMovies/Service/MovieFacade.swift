//
//  MovieFacade.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import RealmSwift

protocol MovieFacade {
    typealias UpdateMoviesDataChangedCompletion = ([MovieModel]?) -> Void
    typealias UpdateMoviesRequestCompletion = () -> Void

    func getMovies(controller: UIViewController?, dataChangedCompletion: @escaping UpdateMoviesDataChangedCompletion, requestCompletion: UpdateMoviesRequestCompletion?)
    func loadMore(controller: UIViewController?,
                  requestCompletion: UpdateMoviesRequestCompletion?)
}

class MovieFacadeImpl: MovieFacade {
    
    private (set) var movieRepository: MovieRepository
    private (set) var movieService: MovieService
    private var movieToken: NotificationToken?
    
    init(movieService: MovieService? = nil, movieRepository: MovieRepository? = nil) {
        if let service = movieService {
            self.movieService = service
        } else {
            self.movieService = MovieService()
        }
        
        if let repository = movieRepository {
            self.movieRepository = repository
        } else {
            self.movieRepository = MovieRepositoryImpl(configuration: .defaultConfiguration)
        }
    }

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
        movieService.getMovies(newPage: false, controller: controller, completion: { movies_ in
            requestCompletion?()
            
            guard let movies = movies_ else {
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
