//
//  ImageCache.swift
//  movietime
//
//  Created by Sandesh Naik on 20/12/25.
//

import Foundation
import SwiftUI
import UIKit

/// Caches the fetched images using a two-tier system:
/// - Memory cache (NSCache) for fast access
/// - Disk cache for persistence across app launches
/// Images are downscaled to optimal size to save disk space and improve performance
final class ImageCache: @unchecked Sendable {

    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let lock = NSLock()
    
    // Maximum dimensions for cached images (accounting for @3x displays)
    private let maxPosterWidth: CGFloat = 500 * 3  // 1500px for @3x displays
    private let maxBannerWidth: CGFloat = 1200 * 3 // 3600px for @3x displays
    
    private init() {
        // Set up cache directory in app's caches folder
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache", isDirectory: true)
        
        // Create cache directory if it doesn't exist
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        // Configure memory cache
        memoryCache.countLimit = 100 // Maximum 100 images in memory
        memoryCache.totalCostLimit = 100 * 1024 * 1024 // 100 MB memory limit
    }

    func image(for url: URL) -> Image? {
        lock.lock()
        defer { lock.unlock() }
        
        // Check memory cache first
        if let cachedImage = memoryCache.object(forKey: url as NSURL) {
            return Image(uiImage: cachedImage)
        }
        
        // Check disk cache
        if let diskImage = loadFromDisk(url: url) {
            // Store in memory cache for faster access next time
            memoryCache.setObject(diskImage, forKey: url as NSURL)
            return Image(uiImage: diskImage)
        }
        
        return nil
    }
    
    /// Store UIImage directly with optional downscaling
    func store(_ uiImage: UIImage, for url: URL, imageType: ImageType = .poster) {
        lock.lock()
        defer { lock.unlock() }
        
        // Downscale image based on type
        let scaledImage = downscale(uiImage, for: imageType)
        
        // Store in memory cache
        memoryCache.setObject(scaledImage, forKey: url as NSURL)
        
        // Store on disk asynchronously
        Task.detached { [weak self] in
            self?.saveToDisk(uiImage: scaledImage, url: url)
        }
    }
    
    func remove(at url: URL) {
        lock.lock()
        defer { lock.unlock() }
        
        // Remove from memory
        memoryCache.removeObject(forKey: url as NSURL)
        
        // Remove from disk
        let fileURL = diskCacheURL(for: url)
        try? fileManager.removeItem(at: fileURL)
    }
    
    func clearMemoryCache() {
        lock.lock()
        defer { lock.unlock() }
        memoryCache.removeAllObjects()
    }
    
    func clearDiskCache() {
        lock.lock()
        defer { lock.unlock() }
        
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func clearAllCache() {
        clearMemoryCache()
        clearDiskCache()
    }
    
    /// Get cache size information
    func getCacheSize() -> Int64 {
        guard let enumerator = fileManager.enumerator(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        
        var totalSize: Int64 = 0
        for case let fileURL as URL in enumerator {
            if let fileSize = try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                totalSize += Int64(fileSize)
            }
        }
        return totalSize
    }
    
    // MARK: - Private Helpers
    
    private func diskCacheURL(for url: URL) -> URL {
        let fileName = url.absoluteString
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return cacheDirectory.appendingPathComponent(fileName)
    }
    
    private func saveToDisk(uiImage: UIImage, url: URL) {
        // Use JPEG compression for smaller file sizes
        // Quality 0.8 provides good balance between quality and size
        guard let data = uiImage.jpegData(compressionQuality: 0.8) else { return }
        let fileURL = diskCacheURL(for: url)
        try? data.write(to: fileURL)
    }
    
    private func loadFromDisk(url: URL) -> UIImage? {
        let fileURL = diskCacheURL(for: url)
        guard let data = try? Data(contentsOf: fileURL),
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return uiImage
    }
    
    /// Downscale image to optimal size based on image type
    private func downscale(_ image: UIImage, for imageType: ImageType) -> UIImage {
        let maxWidth = imageType == .banner ? maxBannerWidth : maxPosterWidth
        
        // If image is already smaller than max width, return as-is
        guard image.size.width > maxWidth else {
            return image
        }
        
        // Calculate new size maintaining aspect ratio
        let scale = maxWidth / image.size.width
        let newHeight = image.size.height * scale
        let newSize = CGSize(width: maxWidth, height: newHeight)
        
        // Render downscaled image
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

// MARK: - Supporting Types

extension ImageCache {
    enum ImageType {
        case poster  // Smaller images (movie posters, thumbnails)
        case banner  // Larger images (banners, backdrops)
    }
}
