//
//  MoviePoster.swift
//  movietime
//
//  Created by Sandesh Naik on 21/10/25.
//

import SwiftUI
import Combine

@MainActor @Observable
class MoviePosterVM {
    
    enum Phase: Equatable {
        case idle, loading, loaded(Image), failed
    }
    
    var phase: Phase = .idle
    
    @ObservationIgnored
    var movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
    }
    
    func loadImage(_ forced: Bool = false) async {
        if(phase == .loading && forced == false) {
            return
        }
            phase = .loading
        guard let url = movie.posterURL else {
            phase = .failed
            return
        }
        do {
            let image = try await ImageLoader.shared.loadImage(for: url, imageType: .poster)
            phase = .loaded(image)
        } catch {
            phase = .failed
        }
    }
    
    
}

struct MoviePoster: View {
    var movie: Movie
    @State private var vm: MoviePosterVM
    
    init(movie: Movie) {
        self.movie = movie
        _vm = State(initialValue: MoviePosterVM(movie))
    }
    
    var body: some View {
        Group {
            switch vm.phase {
            case .idle, .loading :
                ProgressView()
            case .loaded(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failed:
                Image(systemName: "photo").foregroundStyle(.secondary)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .task { await vm.loadImage() }
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
    
    MoviePoster(movie: sampleMovie)
}
#endif
