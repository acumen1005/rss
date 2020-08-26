//
//  String+Ext.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/24.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation

extension String {
    var trimHTMLTag: String {
        return replacingOccurrences(of:"<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var trimWhiteAndSpace: String {
        return replacingOccurrences(of: "\n", with: "")
    }
    
    func toPermissiveDate() -> Date? {
        return RFC822DateFormatter().date(from: self) ??
            (RFC3339DateFormatter().date(from: self) ??
            ISO8601DateFormatter().date(from: self))
    }
}
