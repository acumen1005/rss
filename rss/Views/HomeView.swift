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
    
    @ObservedObject var rssDataSource: RSSDataSource = {
        let dataSource = RSSDataSource(parentContext: Persistence.current.context)
        dataSource.performFetch(RSS.requestObjects())
        return dataSource
    }()
    
    @ObservedObject var rssItemDataSource = RSSItemDataSource(parentContext: Persistence.current.context)
    @ObservedObject private var createRSSModel = RSSModel()
    
    @State private var isAddFormPresented = false
    @State private var isSettingPresented = false
    @State private var isSheetPresented = false
    @State private var sheetFeatureItem: FeatureItem = .none
    @State private var archiveScale: Image.Scale = .medium
    
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
    
    private var homeListView: some View {
        NavigationView {
            List {
                ForEach(rssDataSource.fetchedResult.fetchedObjects ?? [], id: \.self) { rss in
                    NavigationLink(destination: self.destinationView(rss)) {
                        SourceListRow(rss: rss)
                    }
                    .tag("RSS")
                }
                .onDelete { indexSet in
                    if let index = indexSet.first,
                        let objects = self.rssDataSource.fetchedResult.fetchedObjects {
                        let object = objects[index]
                        self.rssDataSource.delete(object, saveContext: true)
                        self.rssDataSource.objectWillChange.send()
                    }
                }
            }
            .navigationBarTitle("RSS")
            .navigationBarItems(trailing: trailingView)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .sheet(isPresented: $isSheetPresented, content: {
            if self.sheetFeatureItem == .add {
                AddRSSSourceView(
                    viewModel: AddRSSSourceViewModel(dataSource: self.rssDataSource))
            } else if self.sheetFeatureItem == .set {
                SettingsView()
            }
        })
        .onAppear {

        }
    }
    
    private var archiveListView: some View {
        ArchiveListView()
    }
    
    private func destinationView(_ rss: RSS) -> some View {
        RSSItemListView(viewModel: RSSItemViewModel(rss: rss, dataSource: self.rssItemDataSource))
            .environmentObject(self.rssDataSource)
    }
    
    var body: some View {
        TabView {
            homeListView
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                            .imageScale(.medium)
                        Text("Home")
                    }
                }
            archiveListView
                .tabItem {
                    VStack {
                        Image(systemName: "archivebox.fill")
                            .imageScale(.medium)
                        Text("Archive")
                    }
                }
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
