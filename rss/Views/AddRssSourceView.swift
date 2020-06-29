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
    
    var onDoneAction: ((String, String?) -> Void)?
    
    private var doneButton: some View {
        Button(action: {
            self.onDoneAction?(self.feedUrl, self.feedTitle)
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
    
    private var isVaildSource: Bool {
        return !feedUrl.isEmpty
    }
    
    @State private var feedUrl: String = ""
    @State private var feedTitle: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextFieldView(label: "Title", placeholder: "optinal", text: $feedTitle)
                TextFieldView(label: "Feed URL", placeholder: "", text: $feedUrl)
            }
            .navigationBarTitle("Add Source")
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    }
}

struct AddRssSource_Previews: PreviewProvider {
    static var previews: some View {
        AddRssSourceView()
    }
}
