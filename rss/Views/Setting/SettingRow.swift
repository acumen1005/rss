//
//  SettingRow.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct SettingRow: View {
    
    @Binding var isToggled: Bool
    
    var body: some View {
        Section(header: Text("APPEARANCE")) {
            VStack {
                HStack {
                    Image("default_image")
                    Text("test")
                }
                HStack(alignment: .center) {
                    Toggle("Automatic", isOn: $isToggled)
                }
            }
        }
    }
}

struct SettingRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingRow(isToggled: .constant(true))
    }
}
