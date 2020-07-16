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
    
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var isAddFormPresented = false
    @State private var isSettingPresented = false
    @State private var isSheetPresented = false
    @State private var archiveScale: Image.Scale = .medium
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    private var addSourceButton: some View {
        Button(action: {
            self.isSheetPresented = true
        }) {
            Image(systemName: "plus.circle")
                .imageScale(.medium)
        }
    }

    private var trailingView: some View {
        HStack(alignment: .top, spacing: 24) {
            addSourceButton
        }
    }
    
    private var homeListView: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.self) { rss in
                    NavigationLink(destination: self.destinationView(rss)) {
                        RSSRow(rss: rss)
                    }
                    .tag("RSS")
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        self.viewModel.delete(at: index)
                    }
                }
            }
            .navigationBarTitle("RSS")
            .navigationBarItems(trailing: trailingView)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .sheet(isPresented: $isSheetPresented, content: {
            AddRSSView(
                viewModel: AddRSSViewModel(dataSource: DataSourceService.current.rss),
                onDoneAction: self.onDoneAction)
        })
        .onAppear {
            self.viewModel.fecthResults()
        }
    }
    
    private func destinationView(_ rss: RSS) -> some View {
        RSSFeedListView(viewModel: RSSFeedViewModel(rss: rss, dataSource: DataSourceService.current.rssItem))
            .environmentObject(DataSourceService.current.rss)
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
            ArchiveListView()
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
    
    func onDoneAction() {
        self.viewModel.fecthResults()
    }
}

#if DEBUG

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}

#endif
