//
//  OPMLParserTests.swift
//  rssTests
//
//  Created by 谷雷雷 on 2020/8/26.
//  Copyright © 2020 acumen. All rights reserved.
//

import UIKit
import XCTest

class OPMLParserTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func loadFile() -> String {
        let bundle = Bundle(for: OPMLParserTests.self)
        let filePath = bundle.path(forResource: "Subscriptions-test2", ofType: "opml")
        assert(filePath != nil, "opml file is not exist")
        return filePath!
    }
    
    func readContent(path: String) -> String {
        let rs = try! String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
        return rs
    }
    
    func testExample() throws {
        let path = loadFile()
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        let parser = OPMLParser(data: data)
        let result = parser.parse()
        switch result {
        case .success(let opml):
            print(opml)
        case .failure(let error):
            assertionFailure("\(error)")
            print("error = \(error)")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
