//
//  ArchiveListView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/15.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct ArchiveListView: View {
    
    @ObservedObject var archiveListViewModel: ArchiveListViewModel
    
    @State private var selectedItem: RSSItem?
    @State var footer = "load more"
    
    init() {
        let dataSource = RSSItemDataSource(parentContext: Persistence.current.context)
        self.archiveListViewModel = ArchiveListViewModel(dataSource: dataSource)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.archiveListViewModel.items, id: \.self) { item in
                    RSSItemRow(wrapper: item)
                        .onTapGesture {
                            self.selectedItem = item
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        let item = self.archiveListViewModel.items[index]
                        self.archiveListViewModel.unarchive(item)
                    }
                }
                VStack(alignment: .center) {
                    Button(action: self.archiveListViewModel.loadMore) {
                        Text(self.footer)
                    }
                }
            }
            .sheet(item: $selectedItem, content: { item in
                SafariView(url: URL(string: item.url)!)
            })
            .onAppear {
                self.archiveListViewModel.fecthResults()
            }
            .navigationBarTitle("Archive")
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct ArchiveListView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveListView()
    }
}
