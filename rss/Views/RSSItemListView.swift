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
    
    let store = RSSItemStore()
    
    @State private var selectedItem: RSSItem?
    @State private var isSafariViewPresented = false
    @State private var items: [RSSItem] = []
    @State private var start: Int = 0
    @State private var footer: String = "load more"
    
    init(source: RSS) {
        rssSource = source
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.items, id: \.self) { item in
                    RSSItemRow(wrapper: item)
                        .onTapGesture {
                            self.selectedItem = item
                    }
                }
                VStack(alignment: .center) {
                    Button(action: self.loadMore) {
                        Text(self.footer)
                    }
                }
            }
            .navigationBarTitle(rssSource.title)
        }.onAppear {
            fetchNewRSSItem(model: self.rssSource, url: self.rssSource.rssURL, start: self.start, in: self.store) { result in
                switch result {
                case .success(let items):
                    self.items = items
                case .failure(let error):
                    print(error)
                }
            }
            syncNewRSSItem(model: self.rssSource, url: self.rssSource.rssURL, in: self.store) { result in
                switch result {
                case .success(let items):
                    self.items.insert(contentsOf: items, at: 0)
                case .failure(let error):
                    print(error)
                }
            }
        }
        .sheet(item: $selectedItem, content: { item in
            SafariView(url: URL(string: item.url)!)
        })
    }
    
    func loadMore() {
        self.start += self.items.count
        fetchNewRSSItem(model: self.rssSource, url: self.rssSource.rssURL, start: self.start, in: self.store) { result in
            switch result {
            case .success(let items):
                self.items.append(contentsOf: items)
                if items.isEmpty {
                    self.footer = "no data"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct RSSItemListView_Previews: PreviewProvider {
    static var previews: some View {
        RSSItemListView(source: RSS.simple())
    }
}
