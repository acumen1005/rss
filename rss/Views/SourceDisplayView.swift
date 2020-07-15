//
//  SourceDisplayView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/2.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct SourceDisplayView: View {
    
    @ObservedObject var rss: RSS
    
    var body: some View {
        Group {
            TextFieldView(label: "Title", placeholder: "", text: $rss.title)
            TextFieldView(label: "Description", placeholder: "", text: $rss.desc)
            TextFieldView(label: "Feed URL", placeholder: "", text: $rss.url)
        }
    }
}

struct SourceDisplayView_Previews: PreviewProvider {
    static var previews: some View {
//        SourceDisplayView()
        Text("text")
    }
}
