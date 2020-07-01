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
    
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    var body: some View {
        RSSSourcesList().inject(self.container)
    }
    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(self.rssObservable.items, id: \.self) { rss in
//                    NavigationLink(destination: RSSItemListView(source: rss)) {
//                        SourceListRow(rss: rss)
//                    }
//                }.onDelete { indexSet in
//                    if let index = indexSet.first {
//                        let item = self.rssObservable.items[index]
//                        self.rssObservable.delete(item)
//                        self.store.delete(item)
//                    }
//                }
//            }
//            .navigationBarTitle("RSS")
//            .navigationBarItems(trailing: trailingView)
//        }
//        .sheet(isPresented: $isSheetPresented, content: {
//            if self.sheetFeatureItem == .add {
//                AddRssSourceView(onDoneAction: { (url, title) in
//                    let rss = self.store.createAndSave(url: url, title: title)
//                    self.rssObservable.insert(head: rss)
//                })
//            } else if self.sheetFeatureItem == .set {
//
//            }
//
//        })
//        .onAppear {
//            self.rssObservable.append(contentsOf: self.store.items)
//        }
//    }
}

#if DEBUG

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
//        return HomeView().environmentObject(store)
        return Text("demo")
    }
}

#endif
