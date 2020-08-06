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
    
    @ObservedObject var itemWrapper: RSSItem
    
    var contextMenuAction: ((RSSItem) -> Void)?
    
    init(wrapper: RSSItem, menu action: ((RSSItem) -> Void)? = nil) {
        itemWrapper = wrapper
        contextMenuAction = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(itemWrapper.title)
                .font(.headline)
            Text(itemWrapper.desc.trimHTMLTag.trimWhiteAndSpace)
                .font(.subheadline)
                .lineLimit(3)
                .foregroundColor(Color("footnoteColor"))
            Spacer()
            HStack(spacing: 10) {
                if itemWrapper.progress >= 1.0 {
                    Text("DONE")
                        .font(.footnote)
                        .foregroundColor(.orange)
                } else if itemWrapper.progress > 0 {
                    Text(String(format: "%.1lf %%", itemWrapper.progress * 100))
                        .font(.footnote)
                        .foregroundColor(.orange)
                }
                Text("\(itemWrapper.createTime?.string() ?? "")")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer(minLength: 10)
                if itemWrapper.isArchive {
                    Image(systemName: "tray.and.arrow.down.fill")
                }
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
        .contextMenu {
            ActionContextMenu(
                label: itemWrapper.isArchive ? "unarchive" : "archive",
                systemName: "tray.and.arrow.\(itemWrapper.isArchive ? "up" : "down")",
                onAction: {
                    self.contextMenuAction?(self.itemWrapper)
            })
        }
    }
}

struct RSSFeedRow_Previews: PreviewProvider {
    static var previews: some View {
        let simple = DataSourceService.current.rssItem.simple()
        return RSSItemRow(wrapper: simple!)
    }
}
