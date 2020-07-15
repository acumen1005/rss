//
//  ArchiveListViewModel.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/15.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation


class ArchiveListViewModel: NSObject, ObservableObject {

    @Published var items: [RSSItem] = []
    
    let dataSource: RSSItemDataSource
    var start = 0
    
    init(dataSource: RSSItemDataSource) {
        self.dataSource = dataSource
        super.init()
    }
    
    func loadMore() {
        start = items.count
        fecthResults(start: start)
    }
    
    func fecthResults(start: Int = 0) {
        if start == 0 {
            items.removeAll()
        }
        dataSource.performFetch(RSSItem.requestArchiveObjects())
        if let objects = dataSource.fetchedResult.fetchedObjects {
            items.append(contentsOf: objects)
        }
    }
    
    func unarchive(_ item: RSSItem) {
        let updatedItem = dataSource.readObject(item)
        updatedItem.isArchive = false
        updatedItem.updateTime = Date()
        dataSource.setUpdateObject(updatedItem)
        
        let rs = dataSource.saveUpdateObject()
        switch rs {
        case .failed:
            print("----> \(#function) failed")
        case .saved:
            items.removeAll { item == $0 }
        case .unchanged:
            print("----> \(#function) unchanged")
        }
    }
    
}
