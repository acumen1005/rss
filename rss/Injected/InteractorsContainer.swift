//
//  InteractorsContainer.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/1.
//  Copyright © 2020 acumen. All rights reserved.
//


extension DIContainer {
    struct Interactors {
        
        let rssSourcesInteractor: RSSSourcesInteractor
        
        static var stub: Self {
            .init(rssSourcesInteractor: SubRSSSourcesInteractor())
        }
    }
}
