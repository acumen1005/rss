//
//  AppEnvironment.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation


class AppEnvironment: NSObject {
    
    static let prefix = "com.acumen.rss.app.environment"
    
    static let current = AppEnvironment()
    
    @UserDefault(key: "\(prefix).useSafari", default: true)
    var useSafari: Bool
}
