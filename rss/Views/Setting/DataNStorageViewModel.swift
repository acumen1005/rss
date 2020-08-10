//
//  DataNStorageViewModel.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/10.
//  Copyright © 2020 acumen. All rights reserved.
//

import UIKit

class DataNStorageViewModel: NSObject, ObservableObject {
    
    let rssDataSource: RSSDataSource
    let rssItemDataSource: RSSItemDataSource
    
    @Published var rssCount: Int = 0
    @Published var rssItemCount: Int = 0
 
    init(rss: RSSDataSource, rssItem: RSSItemDataSource) {
        rssDataSource = rss
        rssItemDataSource = rssItem
        super.init()
    }
    
    func getRSSCount() {
        rssCount = rssDataSource.performFetchCount(RSS.requestDefaultObjects())
        print("getRSSCount = \(rssCount)")
    }
    
    func getRSSItemCount() {
        rssItemCount = rssItemDataSource.performFetchCount(RSSItem.requestDefaultObjects())
        print("getRSSItemCount = \(rssItemCount)")
    }
}
