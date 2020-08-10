//
//  DataUnitView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/10.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct DataUnitView: View {
    
    enum ColorType {
        case blue
        case orange
        
        var gradient: Gradient {
            switch self {
            case .blue:
                return Gradient(colors: [Color(0x13ABD6), Color(0x0036FF)])
            case .orange:
                return Gradient(colors: [Color(0xF1C300), Color(0xF37102)])
            }
        }
    }
    
    let label: String
    @Binding var content: Int
    let colorType: ColorType
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack {
                    Text(label)
                }
                Spacer()
            }
            .padding(.top, 12)
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Text("items: \(content)")
                        .font(.footnote)
                }
            }
            .padding(.bottom, 12)
        }
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: colorType.gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                )
            )
        )
    }
}

struct DataUnitView_Previews: PreviewProvider {
    static var previews: some View {
        DataUnitView(label: "RSS", content: .constant(12), colorType: .blue)
            .frame(height: 120)
    }
}
