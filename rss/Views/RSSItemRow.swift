//
//  RSSItemRow.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/24.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI
import FeedKit

struct RSSItemRow: View {
    
    let itemWrapper: RSSItem
    
    init(wrapper: RSSItem) {
        itemWrapper = wrapper
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(itemWrapper.title ?? "")
                .font(.headline)
            Text((itemWrapper.desc ?? "").trimHTMLTag.trimWhiteAndSpace)
                .font(.subheadline)
                .lineLimit(3)
                .foregroundColor(Color("footnoteColor"))
            Spacer()
            Text("\(itemWrapper.createTime?.string() ?? "")")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

struct RSSItemRow_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
