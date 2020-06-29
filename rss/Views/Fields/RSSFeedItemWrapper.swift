//
//  RSSItem.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/28.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import Combine
import FeedKit

class RSSFeedItemWrapper: ObservableObject, Identifiable {
    @Published var item: RSSFeedItem?
    
    init(item: RSSFeedItem) {
        self.item = item
    }
}

extension RSSFeedItemWrapper {
    static func == (lhs: RSSFeedItemWrapper, rhs: RSSFeedItemWrapper) -> Bool {
        return lhs.item == rhs.item
    }
}


