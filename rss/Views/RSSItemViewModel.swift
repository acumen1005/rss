//
//  RSSItemViewModel.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/12.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation

class RSSItemViewModel: NSObject, ObservableObject {
    
    @Published var items: [RSSItem] = []
    
    let dataSource: RSSItemDataSource
    let rss: RSS
    var start = 0
    
    init(rss: RSS, dataSource: RSSItemDataSource) {
        self.dataSource = dataSource
        self.rss = rss
        super.init()
    }
    
    func loadMore() {
        start = items.count
        fecthResults(start: start)
    }
    
    func fecthResults(start: Int = 0) {
        if start == 0 {
            items.removeAll()
        }
        dataSource.performFetch(RSSItem.requestObjects(rssUUID: rss.uuid!, start: start))
        if let objects = dataSource.fetchedResult.fetchedObjects {
            items.append(contentsOf: objects)
        }
    }
    
    func fetchRemoteRSSItems() {
        guard let url = URL(string: rss.url) else {
            return
        }
        guard let uuid = self.rss.uuid else {
            return
        }
        fetchNewRSS(url: url) { result in
            switch result {
            case .success(let feed):
                var items = [RSSItem]()
                switch feed {
                case .atom(let atomFeed):
                    items = atomFeed.entries?.map({ $0.asRSSItem(container: uuid, in: self.dataSource.createContext) }) ?? []
                case .json(let jsonFeed):
                    items = jsonFeed.items?.map({ $0.asRSSItem(container: uuid, in: self.dataSource.createContext) }) ?? []
                case .rss(let rssFeed):
                    items = rssFeed.items?.map({ $0.asRSSItem(container: uuid, in: self.dataSource.createContext) }) ?? []
                    var newItems = [RSSItem]()
                    for item in items {
                        if let fetchDate = self.rss.lastFetchTime, item.createTime < fetchDate {
                            continue
                        }
                        newItems.append(item)
                    }
                    self.rss.lastFetchTime = Date()
                    self.dataSource.saveUpdateContext()
                    
                    self.dataSource.saveCreateContext()
                    
                    self.fecthResults()
                }
                case .failure(let error):
                    print("feed error \(error)")
            }
        }
    }
}
