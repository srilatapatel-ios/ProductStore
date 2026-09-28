//
//  ImageCache.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 28/09/26.
//

import CryptoKit
import UIKit

final class ImageCache {
    
    private let memoryCache = NSCache<NSURL, UIImage>()
    
    private let diskDirectory: URL
    
    init() {
        memoryCache.countLimit = 100
        // Approximately 50 MB memory limit.
        memoryCache.totalCostLimit = 50 * 1024 * 1024
        let cachesDirectory =
        FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0]
        diskDirectory = cachesDirectory
            .appendingPathComponent(
                "ProductStoreImageCache",
                isDirectory: true
            )
        try? FileManager.default.createDirectory(
            at: diskDirectory,
            withIntermediateDirectories: true
        )
    }
    
    // MARK: - Get
    
    func image(for url: URL) -> UIImage? {
        // 1. Memory cache
        if let image = memoryCache.object(forKey: url as NSURL) {
            print("🟢 IMAGE MEMORY CACHE HIT:", url.absoluteString)
            return image
        }
        // 2. Disk cache
        let fileURL = diskURL(for: url)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil}
        guard let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data)
        else {
            return nil
        }
        insertIntoMemoryCache(image, for: url)
        return image
    }
    // MARK: - Save
    
    func insert(_ image: UIImage, for url: URL) {
        insertIntoMemoryCache(image, for: url)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let fileURL = diskURL(for: url)
        do {
            try data.write(to: fileURL, options: .atomic)
            print(fileURL.path)
            
        } catch {
            print("DISK SAVE FAILED:", error)
        }
    }
    // MARK: - Memory Cache
    
    private func insertIntoMemoryCache(_ image: UIImage, for url: URL) {
        let cost = Int(image.size.width * image.size.height * 4)
        memoryCache.setObject(image, forKey: url as NSURL, cost: cost)
    }
    
    // MARK: - Disk
    
    private func diskURL(for url: URL) -> URL {
        let filename = SHA256.hash(data: Data(url.absoluteString.utf8))
            .compactMap { String(format: "%02x", $0) }.joined()
        return diskDirectory
            .appendingPathComponent(filename)
            .appendingPathExtension("jpg")
    }
    
    // MARK: - Clear
    
    func removeAll() {
        memoryCache.removeAllObjects()
        try? FileManager.default.removeItem(at: diskDirectory)
        try? FileManager.default.createDirectory(at: diskDirectory, withIntermediateDirectories: true)
    }
}
