//
//  SourceListView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/23.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct RSSListView: View {
    
    enum FeaureItem {
        case setting
        case add
    }
    
    @ObservedObject var viewModel: RSSListViewModel
    
    @State private var selectedFeatureItem = FeaureItem.add
    @State private var isAddFormPresented = false
    @State private var isSettingPresented = false
    @State private var isSheetPresented = false
    @State private var addRSSProgressValue = 0.0
    @State var sources: [RSS] = []
    
    private var addSourceButton: some View {
        Button(action: {
            self.isSheetPresented = true
            self.selectedFeatureItem = .add
        }) {
            Image(systemName: "plus.circle")
                .imageScale(.medium)
        }
    }
    
    private var settingButton: some View {
        Button(action: {
            self.isSheetPresented = true
            self.selectedFeatureItem = .setting
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
    
    private let addRSSPublisher = NotificationCenter.default.publisher(for: Notification.Name.init("addNewRSSPublisher"))
    private let rssRefreshPublisher = NotificationCenter.default.publisher(for: Notification.Name.init("rssListNeedRefresh"))
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.items, id: \.self) { rss in
                        Section {
                            NavigationLink(destination: self.destinationView(rss)) {
                                RSSRow(rss: rss)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            self.viewModel.delete(at: index)
                        }
                    }
                }
                .navigationBarTitle("RSS", displayMode: .inline)
                .navigationBarItems(trailing: trailingView)
                
                if addRSSProgressValue > 0 && addRSSProgressValue < 1.0 {
                    LinerProgressBar(lineWidth: 3, color: .blue, progress: $addRSSProgressValue)
                        .padding(.top, 2)
                }
            }
        }
        .onReceive(addRSSPublisher, perform: { output in
            guard
                let userInfo = output.userInfo,
                let total = userInfo["total"] as? Double else { return }
            self.addRSSProgressValue += 1.0/total
        })
        .onReceive(rssRefreshPublisher, perform: { output in
            self.viewModel.fecthResults()
        })
        .sheet(isPresented: $isSheetPresented, content: {
            if FeaureItem.add == self.selectedFeatureItem {
                AddRSSView(
                    viewModel: AddRSSViewModel(dataSource: DataSourceService.current.rss),
                    onDoneAction: self.onDoneAction)
            } else if FeaureItem.setting == self.selectedFeatureItem {
                SettingView()
            }
        })
        .onAppear {
            self.viewModel.fecthResults()
        }
    }
}

extension RSSListView {
    
    func onDoneAction() {
        self.viewModel.fecthResults()
    }
    
    private func destinationView(_ rss: RSS) -> some View {
        RSSFeedListView(viewModel: RSSFeedViewModel(rss: rss, dataSource: DataSourceService.current.rssItem))
            .environmentObject(DataSourceService.current.rss)
    }
    
}

struct RSSListView_Previews: PreviewProvider {
    static let viewModel = RSSListViewModel(dataSource: DataSourceService.current.rss)

    static var previews: some View {
        RSSListView(viewModel: self.viewModel)
    }
}
