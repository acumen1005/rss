//
//  AddRssSource.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/22.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct AddRSSView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: AddRSSViewModel
    
    var onDoneAction: (() -> Void)?
    var onCancelAction: (() -> Void)?
    
    private var doneButton: some View {
        Button(action: {
            self.viewModel.commitCreateNewRSS()
            self.onDoneAction?()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
        }.disabled(!isVaildSource)
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.viewModel.cancelCreateNewRSS()
            self.onCancelAction?()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    private var sectionHeader: some View {
        HStack {
            Text("Input")
            Spacer()
            Button(action: self.fetchDetail) {
                Text("fetch")
            }
        }
    }
    
    private var isVaildSource: Bool {
        return !feedUrl.isEmpty
    }
    
    @State private var hasFetchResult: Bool = false
    
    @State private var feedUrl: String = "https://36kr.com/feed"
    @State private var feedTitle: String = ""
    
    init(viewModel: AddRSSViewModel,
         onDoneAction: (() -> Void)? = nil,
         onCancelAction: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onDoneAction = onDoneAction
        self.onCancelAction = onCancelAction
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: sectionHeader) {
                    TextFieldView(label: "Feed URL", placeholder: "", text: $feedUrl)
                }
                Section(header: Text("Display")) {
                    if !hasFetchResult {
                        Text("no result")
                    } else {
                        if viewModel.rss != nil {
                            RSSDisplayView(rss: viewModel.rss!)
                        }
                    }
                }
            }
            .navigationBarTitle("Add Source")
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    }
    
    func fetchDetail() {
        guard let url = URL(string: self.feedUrl) else {
            return
        }
        viewModel.rss?.url = feedUrl
        fetchNewRSS(url: url) { result in
            switch result {
            case .success(let feed):
                switch feed {
                case .atom(let atomFeed):
                    self.viewModel.rss?.title = atomFeed.title ?? ""
                    if let id = atomFeed.id, var url = URL(string: id), let icon = atomFeed.icon {
                        url.appendPathComponent(icon)
                        self.viewModel.rss?.image = url.absoluteString
                    }
                case .json(let jsonFeed):
                    self.viewModel.rss?.title = jsonFeed.title ?? ""
                    self.viewModel.rss?.desc = jsonFeed.description?.trimWhiteAndSpace ?? ""
                    self.viewModel.rss?.image = jsonFeed.icon ?? ""
                case .rss(let rssFeed):
                    self.viewModel.rss?.title = rssFeed.title ?? ""
                    self.viewModel.rss?.desc = rssFeed.description?.trimWhiteAndSpace ?? ""
                    self.viewModel.rss?.image = rssFeed.image?.url ?? ""
                }
                
                self.hasFetchResult = true
            case .failure(let error):
                print("fetchDetail error = \(error)")
            }
        }
    }
}
