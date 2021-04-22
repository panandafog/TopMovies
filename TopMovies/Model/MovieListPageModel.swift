//
//  MovieListPageModel.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import Foundation

// MARK: - MovieListPageModel
struct MovieListPageModel: Codable {
    let page: Int
    let results: [MovieModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
