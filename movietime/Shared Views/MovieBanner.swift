//
//  MovieBanner.swift
//  movietime
//
//  Created by Sandesh Naik on 20/08/25.
//

import SwiftUI

struct MovieBanner: View {
    
    let movie: Movie
    @State private var loader: ImageLoader
    
    init(movie: Movie ) {
        self.movie = movie
        guard let imageURL = movie.posterURL else { fatalError("No Image URL") }
        self.loader = ImageLoader(url: imageURL)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading, content: {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 320, alignment: .top)
                
            } else {
                
                ContentUnavailableView("Loading", systemImage: "circle.dotted")
                    .background(Color.black.opacity(0.5))
                    .redacted(reason: .placeholder)
            }
            Color.black.opacity(0.25)
        })
        .overlay(alignment: .bottomLeading) {
            Text(movie.title)
                .font(.headline.weight(.black))
                .padding(.leading, 16)
                .padding(.bottom, 8)
        }
        .task {
            await loader.load()
        }
        .foregroundStyle(.white)
    }
        
}

#Preview {

}
