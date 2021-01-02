//
//  RoundRectangeButton.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/10.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct RoundRectangeButton: View {
    
    enum Status {
        case normal(String)
        case ok(String)
        case error(String)
        
        var backgroundColor: Color {
            switch self {
            case .normal:
                return .blue
            case .ok:
                return .green
            case .error:
                return .red
            }
        }
    }
    
    @Binding var status: Status
    let action: ((Status) -> Void)
    
    var text: String {
        switch status {
        case .normal(let msg):
            return msg
        case .ok(let msg):
            return msg
        case .error(let msg):
            return msg
        }
    }
    
    var body: some View {
        Button(action: {
            self.action(self.status)
        }) {
            Text(text)
                .foregroundColor(.white)
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 48)
        .background(status.backgroundColor)
        .cornerRadius(12)
    }
}

struct RoundRectangeButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundRectangeButton(status: .constant(.ok("Import"))) { _ in
            
        }
    }
}
