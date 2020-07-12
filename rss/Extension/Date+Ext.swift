//
//  Date+Ext.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/24.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation

extension Date {
    func string(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let f = DateFormatter()
        f.dateFormat = format
        return f.string(from: self)
    }
}
