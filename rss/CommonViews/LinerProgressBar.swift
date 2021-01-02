//
//  LinerProgressBar.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/10.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI

struct LineGraph: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addLines([
                .init(x: 0, y: 0),
                .init(x: rect.width, y: 0)
            ])
        }
    }
}

struct LinerProgressBar: View {
    
    var lineWidth: CGFloat = 2
    var color: Color = .red
    
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            LineGraph()
                .stroke(style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .opacity(0.3)
            
            LineGraph()
                .trim(from: 0, to: CGFloat(min(1, self.progress)))
                .stroke(style: StrokeStyle(lineWidth: self.lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
        }
    }
}

struct LinerProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                LinerProgressBar(color: .orange, progress: .constant(0.5))
                    .frame(height: 100)
                    .padding(40.0)
                
                Spacer()
            }
        }
    }
}
