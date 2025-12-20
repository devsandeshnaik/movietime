//
//  ImageLoader.swift
//  movietime
//
//  Created by Sandesh Naik on 20/12/25.
//

import Foundation
import SwiftUI

@Observable
final class ImageLoader {
    
    var image: Image?
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    
    func load() async {
        // check if image exists in cache
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
    
}
