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
    
    var onDoneAction: ((RSS) -> Void)?
    
    
    private var doneButton: some View {
        Button(action: {
            self.onDoneAction?(self.createdRSS)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
        }.disabled(!isVaildSource)
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            self.store.context.reset()
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
    
    @State private var createdRSS: RSS = RSS(context: Persistence.current.context)
    
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
                        SourceDisplayView(rss: $createdRSS)
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
        createdRSS.url = self.feedUrl
        fetchNewRSS(model: createdRSS, url: url, in: store) { result in
            switch result {
            case .success(let rss):
                self.createdRSS = rss
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
