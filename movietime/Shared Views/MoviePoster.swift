//
//  MoviePoster.swift
//  movietime
//
//  Created by Sandesh Naik on 21/10/25.
//

import SwiftUI
import Combine

struct MoviePoster: View {
    var movie: Movie
    @State private var loader: ImageLoader
    
    init(movie: Movie, loader: ImageLoader? = nil) {
        self.movie = movie
        if let loader {
            self._loader = State(initialValue: loader)
        } else {
            self._loader = State(initialValue: ImageLoader(url: movie.posterURL))
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading, content: {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFit()
                    
                
            } else {
                ContentUnavailableView("Loading", systemImage: "circle.dotted")
                    .background(Color.black.opacity(0.5))
                    .redacted(reason: .placeholder)
            }
            Color.black.opacity(0.25)
        })
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .animation(.easeIn, value: loader.image)
        .task {
            await loader.load()
        }
        .frame(height: 150)
    }
    
    
    private var imageURL : URL? {
        return movie.posterURL
    }
}

#if DEBUG
#Preview {
    let sampleMovie = Movie(
        id: 2661,
        title: "Batman",
        adult: false,
        backDropPath: "/s2JJkEcVz1Q4uLnNhWZwCcBjqMr.jpg",
        genreIds: [28,35,80],
        originalLanguage: "en",
        originalTitle: "Batman",
        overview: "The Dynamic Duo faces four super-villains who plan to hold the world for ransom with the help of a secret invention that instantly dehydrates people.",
        popularity: 4.5326,
        posterPath: "/zzoPxWHnPa0eyfkMLgwbNvdEcVF.jpg",
        releaseDate: "1966-07-30",
        video: false,
        voteAverage: 6.407
    )
    
    MoviePoster(movie: sampleMovie, loader: ImageLoader(url: nil, shouldMock: true))
}
#endif
