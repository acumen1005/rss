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

func fetchNewRSS(model: RSS? = nil, url: URL, in store: RSSStore,
                 completionHandler: @escaping ((Result<RSS, Error>) -> Void)) {
    let rss = model ?? RSS(context: store.context)
    let parser = FeedParser(URL: url)
    parser.parseAsync(queue: DispatchQueue.global()) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let feed):
                rss.update(from: feed)
                completionHandler(.success(rss))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}


fileprivate func appendNewRSSItem(items: [RSSItem], lastDate: Date?) -> [RSSItem] {
    let savingItems = items.filter { model -> Bool in
        guard let lastDate = lastDate, let date = model.createTime else {
            return true
        }
        return date > lastDate
    }
    print("new: \(savingItems.map({ $0.title }))")
    return savingItems
}

func syncNewRSSItem(model: RSS, url: URL?, start: Int = 0, in store: RSSItemStore,
                    completionHandler: @escaping ((Result<[RSSItem], Error>) -> Void)) {
    guard let url = url else {
        completionHandler(.failure(RSSError.invalidURL))
        return
    }
    let context = store.context
    let rss = model
    let parser = FeedParser(URL: url)
    parser.parseAsync(queue: DispatchQueue.global()) { result in
        DispatchQueue.main.async {
            var items = [RSSItem]()
            switch result {
            case .success(let feed):
                rss.update(from: feed)
                switch feed {
                case .atom(let atomFeed):
                    items = atomFeed.entries?.map({ $0.asRSSItem(container: rss.uuid!, in: context) }) ?? []
                case .json(let jsonFeed):
                    items = jsonFeed.items?.map({ $0.asRSSItem(container: rss.uuid!, in: context) }) ?? []
                case .rss(let rssFeed):
                    items = rssFeed.items?.map({ $0.asRSSItem(container: rss.uuid!, in: context) }) ?? []
                }
                items.sort(by: {
                    guard let a = $0.createTime, let b = $1.createTime else {
                        return true
                    }
                    return a > b
                })
                
                items.forEach { item in
                    print("\(item.createTime ?? Date())")
                }
                
                let savingItems = appendNewRSSItem(items: items, lastDate: rss.lastFetchTime)
                if let recentItem = items.first {
                    rss.lastFetchTime = recentItem.createTime
                    RSSStore().update(rss)
                }
                do {
                    try context.save()
                } catch let error {
                    print("error = \(error)")
                }
                completionHandler(.success(savingItems))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}


func fetchNewRSSItem(model: RSS, url: URL?, start: Int = 0, in store: RSSItemStore,
                     completionHandler: @escaping ((Result<[RSSItem], Error>) -> Void)) {
    var rs = [RSSItem]()
    do {
        rs = try store.fetchRSSItem(RSS: model, start: start, limit: 10)
        completionHandler(.success(rs))
    } catch let errror {
        print("error = \(errror)")
    }
}

