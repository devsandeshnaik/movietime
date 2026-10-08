//
//  MovieBanner.swift
//  movietime
//
//  Created by Sandesh Naik on 20/08/25.
//

import SwiftUI
import Combine

@MainActor @Observable
class MovieBannerVM {
    
    enum Phase {
        case idle, loading, loaded(Image), failed
    }
    
    var phase: Phase = .idle
    
    @ObservationIgnored
    var movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
    }
    
    func loadImage() async {
        phase = .loading
        guard let url = movie.backDropURL else {
            phase = .failed
            return
        }
        do {
            let image = try await ImageLoader.shared.loadImage(for: url, imageType: .banner)
            phase = .loaded(image)
        } catch {
            phase = .failed
        }
    }
}

struct MovieBanner: View {
    var movie: Movie
    @State private var vm: MovieBannerVM
    
    init(movie: Movie) {
        self.movie = movie
        _vm = State(initialValue: MovieBannerVM(movie))
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                switch vm.phase {
                case .idle, .loading:
                    ContentUnavailableView("Loading", systemImage: "circle.dotted")
                        .background(Color.black.opacity(0.5))
                        .redacted(reason: .placeholder)
                case .loaded(let image):
                    image
                        .resizable()
                case .failed:
                    Color.gray.opacity(0.3)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            }
            Text(movie.title)
                .font(.headline.weight(.black))
                .padding(.leading, 16)
                .padding(.bottom, 8)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .task {
            await vm.loadImage()
        }
    }
}

#if DEBUG
#Preview {
    let sampleMovie = Movie(
        id: 2661,
        title: "Batman",
        adult: false,
        backDropPath: "/s2JJkEcVz1Q4uLnNhWZwCcBjqMr.jpg",
        genreIds: [28, 35, 80],
        originalLanguage: "en",
        originalTitle: "Batman",
        overview: "The Dynamic Duo faces four super-villains who plan to hold the world for ransom with the help of a secret invention that instantly dehydrates people.",
        popularity: 4.5326,
        posterPath: "/zzoPxWHnPa0eyfkMLgwbNvdEcVF.jpg",
        releaseDate: "1966-07-30",
        video: false,
        voteAverage: 6.407
    )
    
    MovieBanner(movie: sampleMovie)
        .frame(height: 320)
}
#endif
