//
//  HomeScreen.swift
//  movietime
//
//  Created by Sandesh Naik on 20/08/25.
//

import SwiftUI

struct MoviesScreen: View {
    let viewModel = MoviesVM()
    
    var body: some View {
        List {
            VStack(spacing: 0) {
                NowPlayingMovieGroup(movies: viewModel.nowPlayingCatalog)
            }
            .frame(height: 320)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            ForEach(viewModel.movieCatalogs, id: \.self) { catalog in
                Section(catalog.category) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(catalog.movies, id: \.self) { movie in
                                MoviePoster(movie: movie)
                            }
                        }
                        .frame(height: 150)
                    }
                }
            }
        }
        .listStyle(.plain)
        .edgesIgnoringSafeArea(.top)
    }
       
}

#Preview {
    MoviesScreen()
}
