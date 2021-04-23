//
//  MovieModel.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    
    static let minVoteAverage = 0.0
    static let maxVoteAverage = 10.0
    
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]?
    let id: Int
    var originalLanguage: String?
    var originalTitle: String?
    let overview: String
    var popularity: Double?
    let posterPath, releaseDate, title: String
    var video: Bool?
    let voteAverage: Double
    var voteCount: Int?
    
    var posterURL: URL? {
        var urlComponents = MovieService.imageURLComponents
        urlComponents.path += posterPath
        return urlComponents.url
    }
    
    init(id: Int,
         overview: String,
         posterPath: String,
         releaseDate: String,
         title: String,
         voteAverage: Double) {
        
        self.id = id
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.voteAverage = voteAverage
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
