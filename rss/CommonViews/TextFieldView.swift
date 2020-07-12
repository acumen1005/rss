//
//  TextFieldView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/22.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct TextFieldView: View {
    
    var label: String
    var placeholder: String
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text("\(label)")
            TextField(placeholder, text: $text)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(label: "Feed URL", placeholder: "", text: Binding<String>.constant(""))
    }
}
