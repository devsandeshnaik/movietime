//
//  ImageLoader.swift
//  movietime
//
//  Created by Sandesh Naik on 20/12/25.
//

import Foundation
import SwiftUI
import Combine

@Observable
final class ImageLoader {
    var image: Image?
    
    @ObservationIgnored
    let url: URL?
    let shouldMock: Bool
    
    init(url: URL?, shouldMock: Bool = false) {
        self.url = url
        self.shouldMock = shouldMock
    }
    
    func load() async {
        if shouldMock {
            loadMockImage()
        }
        guard let url else { return }
        if let cachedImage = ImageCache.shared.image(url) {
            image = cachedImage
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                ImageCache.shared.store(image, for: url)
                self.image = image
            }
        } catch {
            print("Image load failed:", error)
        }
    }
    
    private func loadMockImage() {
        image = Image("movie_poster")
    }
}
