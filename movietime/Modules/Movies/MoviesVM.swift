//
//  MoviesVM.swift
//  movietime
//
//  Created by Sandesh Naik on 21/10/25.
//

import Foundation

@Observable
class MoviesVM {
    private let client = ApiRequset.shared
    var movieCatalogs: [MovieCatalogItem] = []
    var nowPlayingCatalog: [Movie] = []
    
    init() {
        fetchMovies()
    }
    
    private func fetchMovies() {
        
        client.getMovie(api: .nowPlaying) {  [weak self] result in
            guard let self else { return }
            nowPlayingCatalog = result
        }
        
        client.getMovie(api: .topRated) {  [weak self] result in
            guard let self else { return }
            movieCatalogs.append(MovieCatalogItem(category: "Top Rated", movies: result))
        }
        
        client.getMovie(api: .trending(.movie, .week)) {  [weak self] result in
            guard let self else { return }
            movieCatalogs.append(MovieCatalogItem(category: "Trending", movies: result))

        }
        
        client.getMovie(api: .upcoming) {  [weak self] result in
            guard let self else { return }
            movieCatalogs.append(MovieCatalogItem(category: "Upcoming", movies: result))
        }
        
        client.getMovie(api: .popular) {  [weak self] result in
            guard let self else { return }
            movieCatalogs.append(MovieCatalogItem(category: "Popular", movies: result))
        }
    }
}
