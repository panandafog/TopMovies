//
//  MovieRepository.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import RealmSwift

class MovieRepository {
    private let configuration: Realm.Configuration

    var realm: Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            fatalError("Realm can't be created")
        }
    }

    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }

    func save(_ movies: [MovieModel]) {
        let movies = movies.map(MovieRealm.init(model:))
        try? realm.write {
            realm.add(movies, update: .modified)
        }
    }

    func getMovies() -> Results<MovieRealm> {
        realm.objects(MovieRealm.self)
    }

    func clear() {
        try? realm.write {
          realm.deleteAll()
        }
    }

    func count() -> Int {
        realm.objects(MovieRealm.self).count
    }
}
