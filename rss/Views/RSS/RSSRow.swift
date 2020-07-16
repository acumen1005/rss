//
//  SourceListRow.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/23.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct RSSRow: View {
    
    @ObservedObject var imageLoader: ImageLoader
    @ObservedObject var rss: RSS
    
    init(rss: RSS) {
        self.rss = rss
        self.imageLoader = ImageLoader(path: rss.image)
    }
    
    private func iconImageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
        .resizable()
        .frame(width: 60, height: 60, alignment: .center)
        .cornerRadius(4)
        .animation(.easeInOut)
    }
    
    private var pureTextView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(rss.title)
                .font(.headline)
            Text(rss.desc)
                .font(.subheadline)
                .foregroundColor(Color("footnoteColor"))
            Spacer()
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    if self.imageLoader.image != nil {
                        iconImageView(self.imageLoader.image!)
                        pureTextView
                    } else {
                        pureTextView
                    }
                }
                Spacer()
                Text(rss.createTimeStr)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

struct SourceListRow_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
