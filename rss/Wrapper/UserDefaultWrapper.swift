//
//  UserDefaultWrapper.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(key: String, default value: T) {
        self.key = key
        self.defaultValue = value
    }
    
    var wrappedValue: T {
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
    }
}
