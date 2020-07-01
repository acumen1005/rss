//
//  AppState.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/1.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation


struct AppState {
    var userData = UserData()
    var routing = ViewRouting()
    var system = System()
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
    }
}

extension AppState {
    struct UserData: Equatable {
        
    }
}

extension AppState {
    struct ViewRouting: Equatable {
        
    }
}

extension AppState {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.userData == rhs.userData && rhs.routing == rhs.routing && lhs.system == rhs.system
    }
}
