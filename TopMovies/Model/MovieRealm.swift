//
//  MovieRealm.swift
//  TopMovies
//
//  Created by panandafog on 22.04.2021.
//

import RealmSwift

class MovieRealm: Object {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var overview = ""
    @objc dynamic var poster = ""
    @objc dynamic var date = ""
    @objc dynamic var rate = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
}

// MARK: - MemeRealm
extension MovieRealm {
    var model: MovieModel? {
        guard let id = Int(self.id), let voteAverage = Double(self.rate) else {
            return nil
        }
        
        return MovieModel(id: id,
                          overview: overview,
                          posterPath: poster,
                          releaseDate: date,
                          title: title,
                          voteAverage: voteAverage)
    }
    
    convenience init(model: MovieModel) {
        self.init()
        
        id = String(model.id)
        title = model.title
        overview = model.overview
        poster = model.posterPath
        date = model.releaseDate
        rate = String(model.voteAverage)
    }
}
