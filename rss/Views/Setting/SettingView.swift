//
//  SettingView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    
    enum ReadMode {
        case safari
        case webview
    }
    
    enum SettingItem: CaseIterable {
        case webView
        case darkMode
        
        var label: String {
            switch self {
            case .webView: return "Read Mode"
            case .darkMode: return "Outlook"
            }
        }
    }
    
    @State private var isSelected: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                ForEach([SettingItem.webView], id: \.self) { _ in
                    SectionView(description: "If you want to read feed with WebView, Open it, Have fun! :]") {
                        Toggle("Use Safari", isOn: self.$isSelected)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
        .onAppear {
            self.isSelected = AppEnvironment.current.useSafari
        }
        .onDisappear {
            AppEnvironment.current.useSafari = self.isSelected
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
