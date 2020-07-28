//
//  RSProgressView.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/28.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    
    var boardWidth: CGFloat = 20
    var font: Font = Font.system(size: 18)
    var color: Color = .red
    
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: boardWidth)
                .opacity(0.3)
                .foregroundColor(color)
            Circle()
                .trim(from: 0, to: CGFloat(min(1.0, self.progress)))
                .stroke(style: StrokeStyle(lineWidth: boardWidth, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270.0))
                .foregroundColor(color)
            Text(String(format: "%.1lf", min(self.progress, 1.0)))
                .font(font)
                .bold()
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                ProgressBar(font: Font.system(size: 20), color: .orange, progress: .constant(0.5))
                    .frame(width: 100, height: 100)
                    .padding(40.0)
                
                Spacer()
            }
        }
    }
}
