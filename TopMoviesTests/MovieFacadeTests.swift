//
//  MovieFacadeTests.swift
//  TopMoviesTests
//
//  Created by panandafog on 23.04.2021.
//

@testable import TopMovies
import RealmSwift
import XCTest

class MovieFacadeTests: XCTestCase {
    
    private var facade: MovieFacade!
    private var serviceMock: MovieServiceMock!
    private var repositorySpy: MovieRepositorySpy!
    
    let expectedMovies = [
        MovieModel(id: 0,
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
                   voteAverage: 7.1),
        MovieModel(id: 1,
                   overview: """
Юный талантливый художник, живущий в Лондоне, случайно попадает в банду, \
которая готовит дерзкую кражу бесценной картины.
""",
                   posterPath: "/eZX3sbYO2ZSAoKCGzJm9Pi8cFpN.jpg",
                   releaseDate: "2021-01-22",
                   title: "Афера Оливера Твиста",
                   voteAverage: 7.0)
    ]
    
    override func setUp() {
        super.setUp()
        serviceMock = MovieServiceMock()
        repositorySpy = MovieRepositorySpy()
        facade = MovieFacadeImpl(movieService: serviceMock, movieRepository: repositorySpy)
    }
    
    override func tearDown() {
        serviceMock = nil
        repositorySpy = nil
        facade = nil
        super.tearDown()
    }
    
    func testGetMovies() {
        serviceMock.stubMovies = expectedMovies
        let expectation = self.expectation(description: #function)
        var actualMovies: [MovieModel]?
        
        facade.getMovies(controller: nil, dataChangedCompletion: { movies in
            actualMovies = movies
            expectation.fulfill()
        }, requestCompletion: nil)
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(actualMovies?.sorted(by: { $0.id < $1.id }),
                       self.expectedMovies.sorted(by: { $0.id < $1.id }))
        XCTAssertTrue(serviceMock.getMoviesCalled)
        XCTAssertEqual(repositorySpy.saved, expectedMovies)
    }
    
    func testLoadMore() {
        serviceMock.stubMovies = expectedMovies
        facade.loadMore(controller: nil, requestCompletion: nil)
        XCTAssertTrue(serviceMock.getMoreMoviesCalled)
        XCTAssertEqual(repositorySpy.saved, expectedMovies)
    }
}

private extension MovieFacadeTests {
    final class MovieServiceMock: MovieService {
        var getMoviesCalled = false
        var getMoreMoviesCalled = false
        var stubMovies: [MovieModel]?
        
        override func getMovies(newPage: Bool, controller: UIViewController?, completion: @escaping MovieService.MovieCompletion) {
            
            getMoviesCalled = true
            getMoreMoviesCalled = newPage
            
            completion(stubMovies)
        }
    }
    
    final class MovieRepositorySpy: MovieRepository {
        private let actualRepository: MovieRepositoryImpl
        
        var saved: [MovieModel]?
        var getMemesCalled = false
        
        init() {
            let configuration = Realm.Configuration(inMemoryIdentifier: "test_realm")
            actualRepository = .init(configuration: configuration)
        }
        
        func save(_ movies: [MovieModel]) {
            saved = movies
            actualRepository.save(movies)
        }
        
        func getMovies() -> Results<MovieRealm> {
            getMemesCalled = true
            return actualRepository.getMovies()
        }
        
        func clear() {
            actualRepository.clear()
        }
        
        func count() -> Int {
            saved?.count ?? 0
        }
    }
}
