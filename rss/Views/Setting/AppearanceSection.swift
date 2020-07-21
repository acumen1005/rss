//
//  AppearacneSection.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct AppearanceSection: View {

    @Binding var isToggled: Bool
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 60) {
                VStack {
                    Image("default_image")
                    Text("Light")
                    Image(systemName: "checkmark.circle\(!isSelected ? "" : ".fill")")
                }
                .onTapGesture {
                    self.isSelected = false
                }
                VStack {
                    Image("default_image")
                    Text("Dark")
                    Image(systemName: "checkmark.circle\(isSelected ? "" : ".fill")")
                }
                .onTapGesture {
                    self.isSelected = true
                }
            }
            .padding(.top, 16)
            HStack(alignment: .center) {
                Toggle("Automatic", isOn: $isToggled)
            }
        }
    }
}

struct AppearacneSection_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSection(isToggled: .constant(true), isSelected: .constant(true))
    }
}
