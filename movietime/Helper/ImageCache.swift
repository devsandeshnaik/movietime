//
//  ImageCache.swift
//  movietime
//
//  Created by Sandesh Naik on 20/12/25.
//

import Foundation
import SwiftUI

/// Caches the fetched images to user dont have to fetch it again and again.
final class ImageCache {

    static let shared = ImageCache()
    private init() {}

    private var cache: [URL: Image] = [:]
    private let lock = NSLock()

    func image(_ url: URL) -> Image? {
        lock.lock()
        defer { lock.unlock() }
        return cache[url]
    }
    
    func store(_ image: Image, for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        cache[url] = image
    }
}
