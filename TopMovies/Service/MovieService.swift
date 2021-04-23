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
            URLQueryItem(name: "language", value: "language".localized)
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
            URLQueryItem(name: "language", value: "language".localized)
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
    
    func getMovies(newPage: Bool, controller: UIViewController?, completion: @escaping MovieCompletion) {
       
        guard Connectivity.isConnectedToInternet else {
            self.showErrorAlert(errorType: .noInternet,
                                  controller: controller)
            completion(nil)
            return
        }
        
        if !newPage {
            currentPage = 1
        } else {
            currentPage += 1
        }
        
        guard let url = popularMoviesUrl else {
            return
        }
        
        AF.request(url, method: .get)
            .responseJSON(completionHandler: { response in
                
                switch response.result {
                case .success(let value):
                    
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
                    
                    switch error {
                    case .sessionTaskFailed(let urlError as URLError):
                        
                        switch urlError.code {
                        
                        case .notConnectedToInternet, .dataNotAllowed:
                            self.showErrorAlert(errorType: .noInternet,
                                                  controller: controller)
                        case .timedOut:
                            self.showErrorAlert(errorType: .timeout,
                                                  controller: controller)
                        default:
                            print("urlError: \(urlError)")
                            self.showErrorAlert(errorType: .unknown,
                                                  controller: controller,
                                                  errorMessage: error.errorDescription)
                        }
                    default:
                        print("error: \(error)")
                        self.showErrorAlert(errorType: .unknown,
                                              controller: controller,
                                              errorMessage: error.errorDescription)
                    }
                    
                    completion(nil)
                }
            })
    }
    
    private func showErrorAlert(errorType: ErrorType, controller: UIViewController?, errorMessage: String? = nil) {
        guard let controller = controller else {
            return
        }
        
        var title = ""
        var message = ""
        
        switch errorType {
        case .noInternet:
            title = "noInternetAlertTitle".localized
            message = "noInternetAlertMessage".localized
        case .timeout:
            title = "timeoutAlertTitle".localized
            message = "timeoutAlertMessage".localized
        case .unknown:
            title = "unknownErrorAlertTitle".localized
            message = errorMessage ?? ""
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        controller.present(alert, animated: true, completion: nil)
    }
    
    enum ErrorType {
        case noInternet
        case timeout
        case unknown
    }
}
