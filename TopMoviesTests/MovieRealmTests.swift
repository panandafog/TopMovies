//
//  MovieRealmTests.swift
//  TopMoviesTests
//
//  Created by panandafog on 23.04.2021.
//

@testable import TopMovies
import XCTest

class MovieRealmTests: XCTestCase {
    
    var movie: MovieModel?
    var movieRealm: MovieRealm?
    
    override func setUp() {
        super.setUp()
        
        let movie = MovieModel(id: 0,
                               overview: """
Джим был лучшим профессиональным снайпером, но теперь он оставил войны позади \
и ведёт уединённую мирную жизнь. Покою приходит конец, когда он решает вступиться \
за беззащитного мальчика, случайно ставшего свидетелем преступлений могущественного \
наркокартеля. С этого момента Джиму предстоит в одиночку противостоять киллерам, \
используя все свои боевые навыки.
""",
                               posterPath: "/6vcDalR50RWa309vBH1NLmG2rjQ.jpg",
                               releaseDate: "2021-01-15",
                               title: "Заступник",
                               voteAverage: 7.1)
        
        movieRealm = MovieRealm(model: movie)
        self.movie = movie
    }
    
    func testMovieModelToMovieRealm() {
        
        guard let model = movie,
              let realm = movieRealm else {
            
            XCTFail()
            return
        }
        
        XCTAssertEqual(String(model.id), realm.id)
        XCTAssertEqual(model.overview, realm.overview)
        XCTAssertEqual(model.posterPath, realm.poster)
        XCTAssertEqual(model.releaseDate, realm.date)
        XCTAssertEqual(model.title, realm.title)
        XCTAssertEqual(String(model.voteAverage), realm.rate)
    }
}
