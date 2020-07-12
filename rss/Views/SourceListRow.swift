//
//  SourceListRow.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/23.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct SourceListRow: View {
    
    @ObservedObject var rss: RSS
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
//            if rss.isFetched {
                Text(rss.title)
                    .font(.headline)
                Text(rss.desc)
                    .font(.subheadline)
                    .foregroundColor(Color("footnoteColor"))
                Spacer()
                Text(rss.createTimeStr)
                    .font(.footnote)
                    .foregroundColor(.gray)
//            } else {
//                Text("loading")
//                    .padding(.top, 8)
//                    .padding(.bottom, 8)
//            }
        }
    }
}

struct SourceListRow_Previews: PreviewProvider {
    static var previews: some View {
        SourceListRow(rss: RSS.simple()).frame(width: 100, height: 60, alignment: .leading)
    }
}
