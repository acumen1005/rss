//
//  RSSItemListView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/24.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI
import FeedKit


struct RSSItemListView: View {
    
    let rssSource: RSS
    
    @State private var selectedItem: RSSFeedItemWrapper?
    @State private var isSafariViewPresented = false
    
    @State private var items: [RSSFeedItem] = []
    
    init(source: RSS) {
        rssSource = source
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.items.map({ RSSFeedItemWrapper(item: $0) }), id: \.item?.title) { item in
                    RSSItemRow(wrapper: item)
                        .onTapGesture {
                            self.selectedItem = item
                    }
                }
            }
            .navigationBarTitle(rssSource.title ?? "")
        }.onAppear {
            let aUrl = URL(string: self.rssSource.url!)!
            let parser = FeedParser(URL: aUrl)
            parser.parseAsync(queue: DispatchQueue.global()) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let feed):
                        print(feed.rssFeed?.items ?? [])
                        self.items = feed.rssFeed?.items ?? []
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        .sheet(item: $selectedItem, content: { item in
            if let link = item.item?.link, let url = URL(string: link) {
                SafariView(url: url)
            }
        })
    }
}

struct RSSItemListView_Previews: PreviewProvider {
    static var previews: some View {
        RSSItemListView(source: RSS.simple())
    }
}
