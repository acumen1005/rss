//
//  SettingsView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/15.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        
                    }) {
                        Text("")
                    }
                }
            }
            .listStyle(GroupedListStyle())

            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
