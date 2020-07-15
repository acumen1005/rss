//
//  ImageServices.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/13.
//  Copyright © 2020 acumen. All rights reserved.
//

import UIKit
import CoreData
import Combine

public class ImageService {
    public static let shared = ImageService()

    public enum ImageError: Error {
        case decodingError
    }
    
    public func fetchImage(url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> UIImage? in
                return UIImage(data: data)
        }.catch { error in
            return Just(nil)
        }
        .eraseToAnyPublisher()
    }
}

public class ImageLoaderCache {
    public static let shared = ImageLoaderCache()
    
    private var loaders: NSCache<NSString, ImageLoader> = NSCache()
            
    public func loaderFor(path: String?) -> ImageLoader {
        let key = NSString(string: "\(path ?? "missing")")
        if let loader = loaders.object(forKey: key) {
            return loader
        } else {
            let loader = ImageLoader(path: path)
            loaders.setObject(loader, forKey: key)
            return loader
        }
    }
}

public final class ImageLoader: ObservableObject {
    public let path: String?
    
    public var objectWillChange: AnyPublisher<UIImage?, Never> = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()
    
    @Published public var image: UIImage? = nil
    
    public var cancellable: AnyCancellable?
        
    public init(path: String?) {
        self.path = path
        
        self.objectWillChange = $image.handleEvents(receiveSubscription: { [weak self] sub in
            self?.loadImage()
        }, receiveCancel: { [weak self] in
            self?.cancellable?.cancel()
        }).eraseToAnyPublisher()
    }
    
    private func loadImage() {
        guard let poster = path, let url = URL(string: poster), image == nil else {
            return
        }
        cancellable = ImageService.shared.fetchImage(url: url)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageLoader.image, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
