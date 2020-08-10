//
//  RoundRectangeButton.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/10.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct RoundRectangeButton: View {
    
    @Binding var text: String
    let action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.white)
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 48)
        .background(Color.blue)
        .cornerRadius(12)
    }
}

struct RoundRectangeButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundRectangeButton(text: .constant("Select File...")) {
            
        }
    }
}
