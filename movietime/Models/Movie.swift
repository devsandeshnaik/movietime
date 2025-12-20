//
//  Movie.swift
//  movietime
//
//  Created by Sandesh Naik on 14/09/25.
//

import Foundation

struct MovieCatalogItem: Identifiable, Hashable {
  
    let id = UUID()
    let category: String
    let movies: [Movie]
    
    static func == (lhs: MovieCatalogItem, rhs: MovieCatalogItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Movie: Codable, Identifiable, Hashable {
    private(set) var id: Int
    private(set) var title: String
    private(set) var adult: Bool
    private(set) var backDropPath: String
    private(set) var genreIds: [Int]
    private(set) var originalLanguage: String
    private(set) var originalTitle: String
    private(set) var overview: String
    private(set) var popularity: Double
    private(set) var posterPath: String
    private(set) var releaseDate: String
    private(set) var video: Bool
    private(set) var voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, adult, overview, popularity, video
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case backDropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Movie {
    
    var backDropURL: URL?{
        let urlString = NetworkConstants.imageURl + self.backDropPath
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    var posterURL: URL?{
        let urlString = NetworkConstants.imageURl + self.posterPath
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
}
