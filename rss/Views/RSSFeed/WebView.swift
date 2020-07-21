//
//  WebView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct WebView: View {
    
    enum FeatureItem {
        case goBack
        case goForward
        case archive(Bool)
        
        var icon: String {
            switch self {
            case .goBack: return "chevron.left"
            case .goForward: return "chevron.right"
            case .archive(let isArchived):
                return "tray.and.arrow.\(isArchived ? "up" : "down")"
            }
        }
    }
    
    @ObservedObject var rssItem: RSSItem
    var onGoBackAction: (() -> Void)?
    var onGoForwardAction: (() -> Void)?
    var onArchiveAction: (() -> Void)?
    
    var body: some View {
        VStack {
            WKWebViewWrapper(viewModel: WKWebViewModel(link: self.rssItem.url))
            HStack(alignment: .top, spacing: 30) {
                makeFeatureItemView(imageName: FeatureItem.goBack.icon, action: self.onGoBackAction)
                makeFeatureItemView(imageName: FeatureItem.goForward.icon, action: self.onGoForwardAction)
                Spacer()
                makeFeatureItemView(imageName: FeatureItem.archive(self.rssItem.isArchive).icon, action: self.onArchiveAction)
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
}

extension WebView {
    
    func makeFeatureItemView(imageName: String, action: (() -> Void)?) -> some View {
        Image(systemName: imageName)
            .frame(width: 50, height: 50, alignment: .center)
            .onTapGesture {
                action?()
        }
    }
}
