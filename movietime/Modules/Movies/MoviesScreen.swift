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
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                NowPlayingMovieGroup(movies: viewModel.nowPlayingCatalog)
                    .frame(height: 320)
                ForEach(viewModel.movieCatalogs, id: \.id) { catalog in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(catalog.category)
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(catalog.movies, id: \.id) { movie in
                                    MoviePoster(movie: movie)
                                }
                            }
                            .frame(height: 150)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
       
}

#Preview {
    MoviesScreen()
}
