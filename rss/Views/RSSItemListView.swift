//
//  RSSItemListView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/24.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI
import FeedKit
import Combine

struct RSSItemListView: View {
    
    var rssSource: RSS {
        return self.rssItemViewModel.rss
    }
    
    @EnvironmentObject var rssDataSource: RSSDataSource
    
    @ObservedObject var rssItemViewModel: RSSItemViewModel
    
    @State private var selectedItem: RSSItem?
    @State private var isSafariViewPresented = false
    @State private var start: Int = 0
    @State private var footer: String = "load more"
    @State var cancellables = Set<AnyCancellable>()
    
    init(viewModel: RSSItemViewModel) {
        self.rssItemViewModel = viewModel
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.rssItemViewModel.items, id: \.self) { item in
                    RSSItemRow(wrapper: item,
                               menu: self.contextmenuAction(_:))
                        .onTapGesture {
                            self.selectedItem = item
                    }
                }
                VStack(alignment: .center) {
                    Button(action: self.rssItemViewModel.loadMore) {
                        Text(self.footer)
                    }
                }
            }
            .navigationBarTitle(rssSource.title)
        }.onAppear {
            self.rssItemViewModel.fecthResults()
            self.rssItemViewModel.fetchRemoteRSSItems()
        }
        .sheet(item: $selectedItem, content: { item in
            SafariView(url: URL(string: item.url)!)
        })
    }
    
    func contextmenuAction(_ item: RSSItem) {
        rssItemViewModel.archiveOrCancel(item)
    }
}

struct RSSItemListView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
