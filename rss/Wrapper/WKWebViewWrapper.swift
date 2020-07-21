//
//  WebViewWrapper.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI
import WebKit

class WKWebViewModel: ObservableObject {
    
    @Published var didFinishLoading: Bool = false
    @Published var link: String = ""
    
    init (link: String) {
        self.link = link
    }
}

struct WKWebViewWrapper: UIViewRepresentable {
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WKWebViewModel

        init(_ viewModel: WKWebViewModel) {
            self.viewModel = viewModel
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            //print("WebView: navigation finished")
            self.viewModel.didFinishLoading = true
        }
    }

    @ObservedObject var viewModel: WKWebViewModel
    
    let webView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        self.webView.navigationDelegate = context.coordinator
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
        WKWebViewWrapper(viewModel: WKWebViewModel(link: "https://www.baidu.com"))
    }
}
