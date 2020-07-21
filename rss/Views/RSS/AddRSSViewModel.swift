//
//  AddRSSSourceViewModel.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/15.
//  Copyright © 2020 acumen. All rights reserved.
//

import UIKit

class AddRSSViewModel: NSObject, ObservableObject {
    
    @Published var rss: RSS?
    
    let dataSource: RSSDataSource
    
    init(dataSource: RSSDataSource) {
        self.dataSource = dataSource
        
        super.init()
        beginCreateNewRSS()
    }
    
    func beginCreateNewRSS() {
        dataSource.discardNewObject()
        dataSource.prepareNewObject()
        rss = dataSource.newObject
    }
        
    func commitCreateNewRSS() {
        dataSource.saveCreateContext()
    }
        
    func cancelCreateNewRSS() {
        dataSource.discardCreateContext()
    }
}
