//
//  NowPlayingMovieGroup.swift
//  movietime
//
//  Created by Sandesh Naik on 20/12/25.
//

import SwiftUI

struct NowPlayingMovieGroup: View {
    
    let movies: [Movie]
    
    var body: some View {
        TabView {
            ForEach(movies) { movie in
                MovieBanner(movie: movie)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
    }
    
}

