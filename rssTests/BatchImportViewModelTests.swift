//
//  BatchImportViewModelTests.swift
//  rssTests
//
//  Created by 谷雷雷 on 2020/8/6.
//  Copyright © 2020 acumen. All rights reserved.
//

import XCTest
import CoreData
import Combine

class BatchImportViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        let dataSource = DataSourceService.current.rss
        let viewModel = BatchImportViewModel(dataSource: dataSource)
        
        let jsonStr =
        """
        [
            {
                "url": "https://developer.apple.com/news/rss/news.rss",
                "title": "Apple Developer News",
                "description": "Apple Developer News",
                "imageUrl": "https://developer.apple.com/assets/elements/icons/app-clips/app-clips-256x256.png"
            },
            {
                "url": "https://www.apple.com/newsroom/rss-feed.rss",
                "title": "Apple Newsroom",
                "description": "Apple Newsroom",
                "imageUrl": "https://developer.apple.com/assets/elements/icons/app-clips/app-clips-256x256.png"
            },
        ]
        """
        
        let models = viewModel.parseJson2Model(jsonStr)
        assert(!models.isEmpty, "parse error !!!")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
