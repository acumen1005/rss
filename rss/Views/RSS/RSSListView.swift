//
//  SourceListView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/23.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct RSSListView: View {
    
    @State var sources: [RSS] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sources, id: \.self) { rss in
                    RSSRow(rss: rss)
                }
            }
        }
    }
}

struct SourceListView_Previews: PreviewProvider {
    static var previews: some View {
        RSSListView()
    }
}
