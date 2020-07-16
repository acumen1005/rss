//
//  RSSActions.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/29.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import Combine
import FeedKit

func fetchNewRSS(url: URL,
                 completionHandler: @escaping ((Result<Feed, Error>) -> Void)) {
    let parser = FeedParser(URL: url)
    parser.parseAsync(queue: DispatchQueue.global()) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let feed):
                completionHandler(.success(feed))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
