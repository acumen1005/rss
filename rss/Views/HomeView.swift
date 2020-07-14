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
    
    enum SegmentItem: Int {
        case home
        case inbox
        
        var label: String {
            switch self {
            case .home: return "Home"
            case .inbox: return "Inbox"
            }
        }
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
    @State private var selectedSegment: SegmentItem = .home
    
    private var addSourceButton: some View {
        Button(action: {
            self.isSheetPresented = true
            self.sheetFeatureItem = .add
            self.beginCreateNewRSS()
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
    
    private func destinationView(_ rss: RSS) -> some View {
        RSSItemListView(source: rss)
            .environmentObject(self.rssDataSource)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker("Lists", selection: $selectedSegment) {
                        ForEach([SegmentItem.home, SegmentItem.inbox], id: \.self) {
                            Text($0.label).tag($0.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                if self.selectedSegment == SegmentItem.home {
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
                } else {
                    Text("Inbox")
                }
            }
            .navigationBarTitle("RSS")
            .navigationBarItems(trailing: trailingView)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .sheet(isPresented: $isSheetPresented, content: {
            if self.sheetFeatureItem == .add {
                AddRssSourceView(
                    rssModel: self.createRSSModel,
                    onDoneAction: self.commitCreateNewRSS,
                    onCancelAction: self.cancelCreateNewRSS)
                    .environmentObject(self.rssDataSource)
            } else if self.sheetFeatureItem == .set {
                SettingsView()
            }
        })
        .onAppear {
            
        }
    }
}

extension HomeView {
    
    func beginCreateNewRSS() {
        rssDataSource.discardNewObject()
        rssDataSource.prepareNewObject()
        createRSSModel.rss = rssDataSource.newObject
    }
    
    func commitCreateNewRSS() {
        rssDataSource.saveCreateContext()
    }
    
    func cancelCreateNewRSS() {
        rssDataSource.discardNewObject()
    }
    
    func deleteRSS() {
//        rssDataSource.de
    }
}

#if DEBUG

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

#endif
