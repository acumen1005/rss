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
    @State private var isJSONHintPresented = false
    @State private var buttonStatus: RoundRectangeButton.Status = .normal("Select File...")
    @State private var JSONText = ""
    
    @ObservedObject private var pickerViewModel: DocumentPickerViewModel
    
    init(viewModel: BatchImportViewModel) {
        self.viewModel = viewModel
        self.pickerViewModel = DocumentPickerViewModel()
    }
    
    var body: some View {
        VStack(spacing: 12) {
//            HStack {
//                Text("Show the JSON format")
//                    .foregroundColor(.white)
//                    .font(.headline)
//                    .fixedSize()
//                    .padding(.leading, 20)
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .fixedSize()
//                    .foregroundColor(.white)
//                    .padding(.trailing, 20)
//            }
//            .padding(.top, 8)
//            .padding(.bottom, 8)
//            .background(Color(0xFFBA5C))
//            .onTapGesture {
//                self.isJSONHintPresented.toggle()
//            }
            if isJSONHintPresented {
                Image("BatchImportImage")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width - 40, height: (UIScreen.main.bounds.width - 40)/1.6)
                    .cornerRadius(8)
            }
            TextView(text: $JSONText, textStyle: .constant(.body))
                .frame(height: 300)
                .border(Color.gray, width: 1.0)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            Spacer()
            RoundRectangeButton(status: $buttonStatus) { status in
                switch status {
                case .error:
                    print("import error !!!")
                case .normal:
                    print("normal")
                    self.isSheetPresented = true
                case .ok:
                    self.viewModel.batchInsert(JSONText: self.JSONText)
                    self.buttonStatus = .normal("Import Successfully !!!")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                        self.buttonStatus = .normal("Select File ...")
                    }
                }
            }
        }
        .sheet(isPresented: $isSheetPresented, content: {
            DocumentPicker(viewModel: self.pickerViewModel)
        })
        .onReceive(self.pickerViewModel.$jsonURL, perform: { output in
            guard let jsonURL = output else { return }
            guard let jsonStr = try? String(contentsOf: jsonURL, encoding: .utf8) else {
                return
            }
            self.JSONText = jsonStr
            self.buttonStatus = .ok("Import")
        })
        .padding(.top, 20)
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
