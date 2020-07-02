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
    
    enum FeatureItem: Int {
        case none
        case add
        case set
    }
    
    @EnvironmentObject var store: RSSStore

    @State private var isAddFormPresented = false
    @State private var isSettingPresented = false
    @State private var isSheetPresented = false
    @State private var sheetFeatureItem: FeatureItem = .none
    
    @ObservedObject private var rssObservable: RSSObservable = RSSObservable(items: [])
    
    private var addSourceButton: some View {
        Button(action: {
            self.isSheetPresented = true
            self.sheetFeatureItem = .add
        }) {
            Image(systemName: "plus.circle")
                .imageScale(.medium)
        }
    }

    private var settingButton: some View {
        Button(action: {
            self.isSheetPresented = true
            self.sheetFeatureItem = .set
        }) {
            Image(systemName: "gear")
                .imageScale(.medium)

        }
    }

    private var trailingView: some View {
        HStack(alignment: .top, spacing: 24) {
            settingButton
            addSourceButton
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
            .navigationBarItems(trailing: trailingView)
        }
        .sheet(isPresented: $isSheetPresented, content: {
            if self.sheetFeatureItem == .add {
                AddRssSourceView(onDoneAction: { (rss) in
                    self.rssObservable.insert(head: rss)
                    self.store.saveChanges()
                })
                .environmentObject(self.store)
            } else if self.sheetFeatureItem == .set {

            }
        })
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
