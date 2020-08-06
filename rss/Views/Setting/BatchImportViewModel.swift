//
//  BatchImportViewModel.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/6.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation

struct BatchImportModel: Codable {
    
    var url: String
    var title: String?
    var description: String?
    var imageUrl: String?

    func apply(in rss: RSS) {
        rss.title = title ?? ""
        rss.url = url
        rss.desc = description ?? ""
        rss.image = imageUrl ?? ""
    }
}


class BatchImportViewModel: NSObject, ObservableObject {
    
    let dataSource: RSSDataSource
    var start = 0
    
    init(dataSource: RSSDataSource) {
        self.dataSource = dataSource
        super.init()
    }
    
    func batchInsert(_ jsonURL: URL) {
        guard let jsonStr = try? String(contentsOf: jsonURL, encoding: .utf8) else {
            return
        }
        let models = parseJson2Model(jsonStr)
        for model in models {
            dataSource.discardNewObject()
            dataSource.prepareNewObject()
            if let newObject = dataSource.newObject {
                model.apply(in: newObject)
            }
        }
        _ = dataSource.saveNewObject()
    }
    
    func parseJson2Model(_ jsonStr: String) -> [BatchImportModel] {
        let jsonDecoder = JSONDecoder()
        guard let jsonData = jsonStr.data(using: .utf8) else {
            return []
        }
        let models = try? jsonDecoder.decode([BatchImportModel].self, from: jsonData)
        return models ?? []
    }
    
    func discardCreateContext() {
        self.dataSource.discardNewObject()
        self.dataSource.discardCreateContext()
    }
}
