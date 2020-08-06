//
//  DocumentPicker.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/6.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

class DocumentPickerViewModel: ObservableObject {
    
    @Published var jsonURL: URL?
}

struct DocumentPicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        private var viewModel: DocumentPickerViewModel
        
        init(viewModel: DocumentPickerViewModel) {
            self.viewModel = viewModel
            super.init()
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.viewModel.jsonURL = urls.first
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            self.viewModel.jsonURL = nil
        }
    }
    
    @ObservedObject var viewModel: DocumentPickerViewModel
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        
        let picker = UIDocumentPickerViewController(documentTypes: ["public.json"], in: .import)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {

    }

    func makeCoordinator() -> DocumentPicker.Coordinator {
        return Coordinator(viewModel: viewModel)     
    }
}

struct DocumentPicker_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPicker(viewModel: DocumentPickerViewModel())
    }
}
