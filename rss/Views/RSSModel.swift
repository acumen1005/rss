//
//  RSSModel.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/11.
//  Copyright © 2020 acumen. All rights reserved.
//

import UIKit

class RSSModel: ObservableObject {
    weak var rss: RSS? {
        didSet {
            title = rss?.title ?? ""
            desc = rss?.desc ?? ""
            createTime = rss?.createTime ?? Date()
            url = rss?.url ?? ""
        }
    }
    
    @Published var title = "" {
        didSet { rss?.title = title }
    }
    
    @Published var desc = "" {
        didSet { rss?.desc = desc }
    }
    
    @Published var createTime = Date() {
        didSet { rss?.createTime = createTime }
    }
    
    @Published var url = "" {
        didSet { rss?.url = url }
    }
}
