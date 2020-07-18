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

    @State private var archiveScale: Image.Scale = .medium
    
    private var homeListView: some View {
        RSSListView(viewModel: RSSListViewModel(dataSource: DataSourceService.current.rss))
    }
    
    private var archiveListView: some View {
        ArchiveListView(viewModel: ArchiveListViewModel(dataSource: DataSourceService.current.rssItem))
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

extension HomeView {
}

#if DEBUG

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

#endif
