//
//  WebViewWrapper.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI
import Combine
import WebKit

class WKWebViewModel: ObservableObject {
    
    private var dataSource: RSSItemDataSource
    
    private var cancellable: AnyCancellable? = nil
    @Published var didFinishLoading: Bool = false
    @Published var link: String = ""
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var total: Double = 0.0 {
        didSet {
            progressHide = false
        }
    }
    @Published var progress: Double = 0.0 {
        didSet {
            if progress > 0 {
                progressHide = false
            }
        }
    }
    @Published var progressHide: Bool = true
    
    init (rssItem: RSSItem) {
        self.dataSource = DataSourceService.current.rssItem
        self.link = rssItem.url
        self.progress = rssItem.progress
        cancellable = AnyCancellable(
            $progress.removeDuplicates()
                .debounce(for: 0.1, scheduler: DispatchQueue.main)
                .sink { [weak self] p in
                    let item = self?.dataSource.readObject(rssItem)
                    item?.progress = p
                    self?.dataSource.setUpdateObject(item)
                    _ = self?.dataSource.saveUpdateObject()
        })
        
    }
    
    func apply(progress: Double) {
        guard total != 0 else {
            return
        }
        self.progress = min(max(progress / total, self.progress), 1.0)
    }
}

struct WKWebViewWrapper: UIViewRepresentable {
    
    class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        private var viewModel: WKWebViewModel

        init(_ viewModel: WKWebViewModel) {
            self.viewModel = viewModel
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.viewModel.didFinishLoading = true
            self.viewModel.canGoBack = webView.canGoBack
            self.viewModel.canGoForward = webView.canGoForward
            self.viewModel.total = Double(webView.scrollView.contentSize.height)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let contentOffsetY = scrollView.contentOffset.y + scrollView.frame.height
            self.viewModel.apply(progress: Double(contentOffsetY))
        }
    }

    @ObservedObject var viewModel: WKWebViewModel
    
    let webView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        self.webView.navigationDelegate = context.coordinator
        self.webView.scrollView.delegate = context.coordinator
        if let url = URL(string: viewModel.link) {
            self.webView.load(URLRequest(url: url))
        }
        return self.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        
    }
    
    func makeCoordinator() -> WKWebViewWrapper.Coordinator {
        return Coordinator(viewModel)
    }
}

struct WebViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        let simple = DataSourceService.current.rssItem.simple()
        return WKWebViewWrapper(viewModel: WKWebViewModel(rssItem: simple!))
    }
}
