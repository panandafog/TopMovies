//
//  MovieFacade.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import RealmSwift

class MovieFacade {
    typealias UpdateMoviesCompletion = ([MovieModel]?) -> Void
    
    let movieRepository = MovieRepository(configuration: .defaultConfiguration)
    let movieService = MovieService()
    private var movieToken: NotificationToken?

    func loadMore() {
        let originalMovieCount = self.movieRepository.count()
        movieService.getMovies(newPage: true, completion: { movies in
            guard let movies = movies else { return }
            self.movieRepository.save(movies)
            if self.movieRepository.count() <= originalMovieCount {
                self.loadMore()
            }
        })
    }

    func getMovies(completion: @escaping UpdateMoviesCompletion) {
        movieService.getMovies(newPage: false, completion: { movies in
            guard let movies = movies else { return }
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
            completion(models)
        }
    }
}
