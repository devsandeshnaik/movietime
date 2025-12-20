//
//  MoviePoster.swift
//  movietime
//
//  Created by Sandesh Naik on 21/10/25.
//

import SwiftUI

struct MoviePoster: View {
    var movie: Movie
    @State private var loader: ImageLoader
    
    init(movie: Movie) {
        self.movie = movie
        guard let posterURL = movie.posterURL else {
            fatalError("Movie must have a valid poster URL")
        }
        self.loader = ImageLoader(url: posterURL)
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
