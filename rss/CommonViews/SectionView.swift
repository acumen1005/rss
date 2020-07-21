//
//  SectionView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct SectionView<Content: View>: View {
    
    var title: String?
    var description: String
    let content: () -> Content
    
    var body: some View {
        Group {
            #if os(iOS)
            Section(footer: Text(description)) {
                if title != nil {
                    Text(title!)
                        .font(.headline)
                }
                content()
            }
            #else
            Group {
                if let title = title {
                    Text(title).font(.title3).bold()
                }
                content()
                Text(description).font(.body).foregroundColor(.secondary)
                Divider()
            }
            #endif
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Section", description: "Description", content: { Text("Content") })
        .previewLayout(.sizeThatFits)
    }
}
