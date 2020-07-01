//
//  RSSSourcesList.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/1.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct RSSSourcesList: View {
    
    enum FeatureItem: Int {
        case none
        case add
        case set
    }
    
    @Environment(\.injected) private var injected: DIContainer
    
    @State private var isAddFormPresented = false
    @State private var isSettingPresented = false
    @State private var isSheetPresented = false
    @State private var sheetFeatureItem: FeatureItem = .none
    
    @State private var sources: [RSS] = []
    
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
                ForEach(self.sources, id: \.self) { rss in
                    NavigationLink(destination: RSSItemListView(source: rss)) {
                        SourceListRow(rss: rss)
                    }
                }.onDelete { indexSet in
                }
            }
            .navigationBarTitle("RSS")
            .navigationBarItems(trailing: trailingView)
        }
        .sheet(isPresented: $isSheetPresented, content: {
            if self.sheetFeatureItem == .add {
                AddRssSourceView(onDoneAction: { (url, title) in
                    self.insert(url: url, title: title, desc: "")
                })
            } else if self.sheetFeatureItem == .set {

            }
        })
        .onAppear() {
            self.reloadDate()
        }
    }
}

extension RSSSourcesList {
    func reloadDate() {
        injected.interactors.rssSourcesInteractor
            .load(sources: $sources)
    }
    
    func insert(url: String, title: String?, desc: String?) {
        injected.interactors.rssSourcesInteractor
            .store(url: url, title: title, desc: desc)
    }
    
    func insert(rss: RSS) {
        injected.interactors.rssSourcesInteractor
            .store(source: rss)
    }
}

struct RSSSourcesList_Previews: PreviewProvider {
    static var previews: some View {
        RSSSourcesList()
    }
}
