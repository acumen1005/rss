//
//  HomeView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/22.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI
import FeedKit

struct HomeView: View {
    
    @EnvironmentObject var store: RSSStore
    
    @State private var isAddFormPresented = false
    @State private var isSourceListPresented = false
    
    @ObservedObject private var rssObservable: RSSObservable = RSSObservable(items: [])
    
    private var addSourceButton: some View {
        Button(action: {
            self.isAddFormPresented = true
        }) {
            Text("Add")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.rssObservable.items, id: \.self) { rss in
                    NavigationLink(destination: RSSItemListView(source: rss)) {
                        SourceListRow(rss: rss)
                    }
                }.onDelete { indexSet in
                    if let index = indexSet.first {
                        let item = self.rssObservable.items[index]
                        self.rssObservable.delete(item)
                        self.store.delete(item)
                    }
                }
            }
            .navigationBarTitle("RSS")
            .navigationBarItems(trailing: addSourceButton)
        }
        .sheet(isPresented: $isAddFormPresented) {
            AddRssSourceView(onDoneAction: { (url, title) in
                let rss = self.store.create(url: url, title: title)
                self.rssObservable.append(rss)
            })
        }
        .onAppear {
            self.rssObservable.append(contentsOf: self.store.items)
        }
    }
}

#if DEBUG

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

#endif
