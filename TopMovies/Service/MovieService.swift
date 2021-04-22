//
//  MovieService.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import Foundation
import Alamofire

class MovieService {
    typealias MovieCompletion = ([MovieModel]?) -> Void
    
    static var defaultURLComponents: URLComponents {
        var tmp = URLComponents()
        tmp.scheme = "https"
        tmp.host = "api.themoviedb.org"
        tmp.queryItems = [
            URLQueryItem(name: "api_key", value: "c7d2a590385fa79c0ac352c37605f9a4"),
            URLQueryItem(name: "language", value: "ru")
        ]
        return tmp
    }
    
    private static var defaultImageResolution = 500
    
    static var imageURLComponents: URLComponents {
        var tmp = URLComponents()
        tmp.scheme = "https"
        tmp.host = "image.tmdb.org"
        tmp.path = "/t/p/w\(defaultImageResolution)/"
        tmp.queryItems = [
            URLQueryItem(name: "api_key", value: "c7d2a590385fa79c0ac352c37605f9a4"),
            URLQueryItem(name: "language", value: "ru")
        ]
        return tmp
    }

    private var currentPage: Int = 1
    private var popularMoviesUrl: URL? {
        var tmp = MovieService.defaultURLComponents
        tmp.path = "/3/movie/popular"
        tmp.queryItems?.append(URLQueryItem(name: "page", value: "\(self.currentPage)"))
        return tmp.url
    }

    func getMovies(newPage: Bool, completion: @escaping MovieCompletion) {
        if !newPage {
            currentPage = 1
        } else {
            currentPage += 1
        }
        guard let url = popularMoviesUrl else {
            completion(nil)
            return
        }
        
        AF.request(url, method: .get).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                print ("success")
                
                guard let data = response.data else {
                    completion(nil)
                    return
                }
                guard let page = try? JSONDecoder().decode(MovieListPageModel.self, from: data) else {
                    completion(nil)
                    return
                }
                
                completion(page.results)
                
            case .failure(let error):
                print ("error")
                completion(nil)
            }
        })
    }
}
