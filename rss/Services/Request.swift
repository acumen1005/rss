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

func updateNewRSS(url: URL,
                  for rss: RSS,
                  completionHandler: @escaping ((Result<RSS, Error>) -> Void)) {
    rss.url = url.absoluteString
    let parser = FeedParser(URL: url)
    parser.parseAsync(queue: DispatchQueue.global()) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let feed):
                switch feed {
                case .atom(let atomFeed):
                    rss.title = atomFeed.title ?? ""
                    if let id = atomFeed.id, var url = URL(string: id), let icon = atomFeed.icon {
                        url.appendPathComponent(icon)
                        rss.image = url.absoluteString
                    }
                case .json(let jsonFeed):
                    rss.title = jsonFeed.title ?? ""
                    rss.desc = jsonFeed.description?.trimWhiteAndSpace ?? ""
                    rss.image = jsonFeed.icon ?? ""
                case .rss(let rssFeed):
                    rss.title = rssFeed.title ?? ""
                    rss.desc = rssFeed.description?.trimWhiteAndSpace ?? ""
                    rss.image = rssFeed.image?.url ?? ""
                }
                completionHandler(.success(rss))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
