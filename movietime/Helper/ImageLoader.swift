//
//  ImageLoader.swift
//  movietime
//
//  Created by Sandesh Naik on 20/12/25.
//

import Foundation
import SwiftUI
import Combine

protocol ImageLoaderProtocol {
    func loadImage(for path: URL, imageType: ImageCache.ImageType) async throws -> Image
}


enum LoadingError: Error {
    case FailedToLoad
}

/// Helps load the images from server, works along side image cache so no image is fetched if already available
final class ImageLoader: ImageLoaderProtocol {
    
    static let shared = ImageLoader()
    private init() { }
    
    func loadImage(for url: URL, imageType: ImageCache.ImageType = .poster) async throws -> Image {
        // Check cache first (both memory and disk)
        if let cachedImage = ImageCache.shared.image(for: url) {
            return cachedImage
        }
        
        // Download image
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let uiImage = UIImage(data: data) else {
            throw LoadingError.FailedToLoad
        }
        
        // Cache the image (will be downscaled based on type)
        ImageCache.shared.store(uiImage, for: url, imageType: imageType)
        
        // Return SwiftUI Image
        return Image(uiImage: uiImage)
    }
}
