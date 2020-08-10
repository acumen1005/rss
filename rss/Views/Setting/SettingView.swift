//
//  SettingView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/21.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    
    enum ReadMode {
        case safari
        case webview
    }
    
    enum SettingItem: CaseIterable {
        case webView
        case darkMode
        case batchImport
        
        var label: String {
            switch self {
            case .webView: return "Read Mode"
            case .darkMode: return "Outlook"
            case .batchImport: return "Import RSS Sources"
            }
        }
    }
    
    @State private var isSelected: Bool = false
    
    var batchImportView: BatchImportView {
        let dataSource = DataSourceService.current.rss
        return BatchImportView(viewModel: BatchImportViewModel(dataSource: dataSource))
    }
    
    var dataNStorage: DataNStorageView {
        let storage = DataNStorageView()
        return storage
    }
    
    var body: some View {
        NavigationView {
            List {
                SectionView {
                    Group {
                        HStack {
                            Image(systemName: "safari")
                                .fixedSize()
                            Toggle("Use Safari", isOn: self.$isSelected)
                        }
                        HStack {
                            NavigationLink(destination: self.batchImportView) {
                                HStack {
                                    Image(systemName: "folder")
                                        .fixedSize()
                                    Text("Batch Import RSS Sources")
                                }
                            }
                        }
                    }
                }
                SectionView {
                    Group {
                        HStack {
                            NavigationLink(destination: self.dataNStorage) {
                                HStack {
                                    Image(systemName: "tray.full")
                                        .fixedSize()
                                    Text("Data and Storage")
                                }
                            }
                        }
                    }
                }
                SectionView {
                    Group {
                        HStack {
                            NavigationLink(destination: self.batchImportView) {
                                HStack {
                                    Image(systemName: "envelope")
                                        .fixedSize()
                                    Text("Github")
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
            .environment(\.horizontalSizeClass, .regular)
        }
        .onAppear {
            self.isSelected = AppEnvironment.current.useSafari
        }
        .onDisappear {
            AppEnvironment.current.useSafari = self.isSelected
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
