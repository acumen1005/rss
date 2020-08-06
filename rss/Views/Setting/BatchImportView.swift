//
//  BatchImportView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/5.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct BatchImportView: View {
    
    let viewModel: BatchImportViewModel
    
    @State private var isSheetPresented = false
    
    @ObservedObject private var pickerViewModel: DocumentPickerViewModel
    
    init(viewModel: BatchImportViewModel) {
        self.viewModel = viewModel
        self.pickerViewModel = DocumentPickerViewModel()
    }
    
    var body: some View {
        VStack {
            Image("BatchImportImage")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40)/1.6)
                .cornerRadius(8)
            Spacer()
            Button(action: {
                self.isSheetPresented = true
            }) {
                Text("Select File ...")
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 48)
            .background(Color.blue)
            .cornerRadius(12)
        }
        .sheet(isPresented: $isSheetPresented, content: {
            DocumentPicker(viewModel: self.pickerViewModel)
        })
        .onReceive(self.pickerViewModel.$jsonURL, perform: { output in
            guard let jsonURL = output else { return }
            self.viewModel.batchInsert(jsonURL)
        })
        .padding(.bottom, 20)
        .onDisappear {
            self.viewModel.discardCreateContext()
        }
    }
}

struct BatchImportView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSource = DataSourceService.current.rss
        return BatchImportView(viewModel: BatchImportViewModel(dataSource: dataSource))
    }
}
