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
    @EnvironmentObject var store: RSSStore
    
    var onDoneAction: ((String, String?, String?) -> Void)?
    
    
    private var doneButton: some View {
        Button(action: {
            self.onDoneAction?(self.feedUrl, self.detailFeedTitle, self.detailFeedDesc)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
        }.disabled(!isVaildSource)
    }
    
    private var cancelButton: some View {
        Button(action: {
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
    
    private var hasFetchResult: Bool {
        return !self.detailFeedTitle.isEmpty
            || !self.detailFeedDesc.isEmpty
            || !self.detailFeedURL.isEmpty
    }
    
    @State private var feedUrl: String = "https://36kr.com/feed"
    @State private var feedTitle: String = ""
    
    @State private var detailFeedTitle: String = ""
    @State private var detailFeedDesc: String = ""
    @State private var detailFeedURL: String = ""
    
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
                        TextFieldView(label: "Title", placeholder: "", text: $detailFeedTitle)
                        TextFieldView(label: "Description", placeholder: "", text: $detailFeedDesc)
                        TextFieldView(label: "Feed URL", placeholder: "", text: $detailFeedURL)
                            .disabled(true)
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
        fetchNewRSS(url: url, in: store) { result in
            switch result {
            case .success(let rss):
                self.detailFeedTitle = rss.title ?? ""
                self.detailFeedDesc = rss.desc ?? ""
                self.detailFeedURL = rss.url ?? ""
//                self.store.context.undo()
            case .failure(let error):
                print("fetchDetail error = \(error)")
            }
        }
    }
}

struct AddRssSource_Previews: PreviewProvider {
    static var previews: some View {
        AddRssSourceView()
    }
}
