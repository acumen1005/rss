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
        case archive
    }
    
    @ObservedObject var viewModel: RSSListViewModel
    
    @State private var selectedFeatureItem = FeaureItem.add
    @State private var isAddFormPresented = false
    @State private var isSettingPresented = false
    @State private var action: Int?
    @State private var isSheetPresented = false
    @State private var addRSSProgressValue = 1.0
    @State var sources: [RSS] = []
    
    private var archiveListView: some View {
        ArchiveListView(viewModel: ArchiveListViewModel(dataSource: DataSourceService.current.rssItem))
    }
    
    private var addSourceButton: some View {
        Button(action: {
            self.isSheetPresented = true
            self.selectedFeatureItem = .add
        }) {
            Image(systemName: "plus.circle")
                .imageScale(.medium)
        }
    }
    
    private var archiveButton: some View {
        Button(action: {
            self.action = 1
        }) {
            Image(systemName: "archivebox.fill")
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
            addSourceButton
            archiveButton
            Spacer()
            settingButton
        }.padding(24)
    }
    
    private let addRSSPublisher = NotificationCenter.default.publisher(for: Notification.Name.init("addNewRSSPublisher"))
    private let rssRefreshPublisher = NotificationCenter.default.publisher(for: Notification.Name.init("rssListNeedRefresh"))
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    List {
                        ForEach(viewModel.items, id: \.self) { rss in
                            NavigationLink(destination: self.destinationView(rss)) {
                                RSSRow(rss: rss)
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                self.viewModel.delete(at: index)
                            }
                        }
                    }
                    .navigationBarTitle("RSS", displayMode: .inline)
//                    .navigationBarHidden(true)
                }
                Spacer()
                if addRSSProgressValue > 0 && addRSSProgressValue < 1.0 {
                    LinerProgressBar(lineWidth: 3, color: .blue, progress: $addRSSProgressValue)
                        .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .leading)
                }
                trailingView
                    .frame(width: UIScreen.main.bounds.width, height: 49, alignment: .leading)
                NavigationLink(
                    destination: ArchiveListView(
                        viewModel: ArchiveListViewModel(
                            dataSource: DataSourceService.current.rssItem
                        )
                    ),
                    tag: 1,
                    selection: $action) {
                    EmptyView()
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
            } else if FeaureItem.archive == self.selectedFeatureItem {
                archiveListView
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
