//
//  AddRssSource.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/22.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct AddRssSourceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var rssModel: RSSModel
    
    var onDoneAction: (() -> Void)?
    
    var onCancelAction: (() -> Void)?
    
    private var doneButton: some View {
        Button(action: {
            self.onDoneAction?()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
        }.disabled(!isVaildSource)
    }
    
    private var cancelButton: some View {
        Button(action: {
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
                        SourceDisplayView(rss: rssModel)
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
        rssModel.url = feedUrl
        fetchNewRSS(url: url) { result in
            switch result {
            case .success(let feed):
                switch feed {
                case .atom(let atomFeed):
                    self.rssModel.title = atomFeed.title ?? ""
                case .json(let jsonFeed):
                    self.rssModel.title = jsonFeed.title ?? ""
                    self.rssModel.desc = jsonFeed.description?.trimWhiteAndSpace ?? ""
                case .rss(let rssFeed):
                    self.rssModel.title = rssFeed.title ?? ""
                    self.rssModel.desc = rssFeed.description?.trimWhiteAndSpace ?? ""
                }
                
                self.hasFetchResult = true
            case .failure(let error):
                print("fetchDetail error = \(error)")
            }
        }
    }
}

struct AddRssSource_Previews: PreviewProvider {
    static var previews: some View {
//        AddRssSourceView()
        Text("")
    }
}
