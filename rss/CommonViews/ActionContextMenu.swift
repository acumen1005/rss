//
//  ActionContextMenu.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/15.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct ActionContextMenu: View {
    
    private var label: String
    private var systemName: String
    
    var onAction: (() -> Void)?
    
    init(label: String, systemName: String, onAction: (() -> Void)? = nil) {
        self.label = label
        self.systemName = systemName
        self.onAction = onAction
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.onAction?()
            }) {
                HStack {
                    Text(self.label)
                    Image(systemName: self.systemName)
                        .imageScale(.small)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ActionContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        ActionContextMenu(label: "Archive", systemName: "tray.and.arrow.down")
    }
}
