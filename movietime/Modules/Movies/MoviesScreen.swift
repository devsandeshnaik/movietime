//
//  HomeScreen.swift
//  movietime
//
//  Created by Sandesh Naik on 20/08/25.
//

import SwiftUI

struct MoviesScreen: View {
    @State var viewModel = MoviesVM()
    
    var body: some View {
        ZStack {
            Color(hex: "#F5EFE3")
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    NowPlayingMovieGroup(movies: viewModel.nowPlayingCatalog)
                        .aspectRatio(16/9, contentMode: .fill)
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
                                        //.frame(minWidth: 120)
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
        }
        .edgesIgnoringSafeArea(.vertical)
    }
       
}

//#Preview {
//    MoviesScreen()
//}
