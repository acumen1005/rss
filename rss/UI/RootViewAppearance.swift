//
//  RootViewAppearance.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/1.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct RootViewAppearance: ViewModifier {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var isActive: Bool = false
    let inspection = PassthroughSubject<((AnyView) -> Void), Never>()
    
    func body(content: Content) -> some View {
        content
            .onReceive(stateUpdate) { self.isActive = $0 }
            .onReceive(inspection) { callback in
                callback(AnyView(self.body(content: content)))
            }
    }
    
    private var stateUpdate: AnyPublisher<Bool, Never> {
        injected.appState.updates(for: \.system.isActive)
    }
}
