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
        case close
        case goBack
        case goForward
        case archive(Bool)
        
        var icon: String {
            switch self {
            case .close: return "xmark"
            case .goBack: return "chevron.left"
            case .goForward: return "chevron.right"
            case .archive(let isArchived):
                return "tray.and.arrow.\(isArchived ? "up" : "down")"
            }
        }
    }
    
    @ObservedObject var viewModel: WKWebViewModel
    @ObservedObject var rssItem: RSSItem
    var webViewWrapper: WKWebViewWrapper
    var onArchiveClosure: (() -> Void)?
    var onCloseClosure: (() -> Void)?
    
    init(rssItem: RSSItem, onCloseClosure: @escaping (() -> Void), onArchiveClosure: (() -> Void)? = nil) {
        let viewModel = WKWebViewModel(rssItem: rssItem)
        self.rssItem = rssItem
        self.viewModel = viewModel
        self.onCloseClosure = onCloseClosure
        self.onArchiveClosure = onArchiveClosure
        self.webViewWrapper = WKWebViewWrapper(viewModel: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            webViewWrapper
            HStack(alignment: .top, spacing: 30) {
                if !self.viewModel.canGoBack {
                    makeFeatureItemView(
                        imageName: FeatureItem.close.icon,
                        disable: true,
                        action: self.onGoBackAction
                    )
                } else {
                    makeFeatureItemView(
                        imageName: FeatureItem.goBack.icon,
                        disable: true,
                        action: self.onGoBackAction
                    )
                }
                makeFeatureItemView(
                    imageName: FeatureItem.goForward.icon,
                    disable: !self.viewModel.canGoForward,
                    action: self.onGoForwardAction
                )
                makeFeatureItemView(imageName: FeatureItem.archive(self.rssItem.isArchive).icon, action: self.onArchiveClosure)
                
                if !self.viewModel.progressHide {
                    VStack(alignment: .center) {
                        ProgressBar(
                            boardWidth: 6,
                            font: Font.system(size: 12),
                            color: .orange, progress:
                            self.$viewModel.progress
                        )
                        .padding(10)
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                }
                Spacer()
            }
        }
    }
}

extension WebView {
    func onGoBackAction() {
        webViewWrapper.webView.goBack()
    }
    
    func onGoForwardAction() {
        webViewWrapper.webView.goForward()
    }
    
    func onCloseAction() {
//        webViewWrapper.webView.
        self.onCloseClosure?()
    }
}

extension WebView {
    
    func makeFeatureItemView(imageName: String, disable: Bool = false, action: (() -> Void)?) -> some View {
        Image(systemName: imageName)
            .foregroundColor(disable ? Color.gray : Color.white)
            .frame(width: 50, height: 50, alignment: .center)
            .onTapGesture {
                action?()
            }
            .disabled(disable)
    }
}

struct WebView_Previews: PreviewProvider {
    
    static var previews: some View {
        let simple = DataSourceService.current.rssItem.simple()
        return WebView(rssItem: simple!, onCloseClosure: {
            
        }, onArchiveClosure: {
            
        })
    }
}
