//
//  Color+Ext.swift
//  rss
//
//  Created by 谷雷雷 on 2020/8/10.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    init(_ rgb: UInt, _ alpha: CGFloat = 1.0) {
        self.init(RGBColorSpace.sRGB,
              red: Double((rgb & 0xFF0000) >> 16) / 255.0,
              green: Double((rgb & 0x00FF00) >> 8) / 255.0,
              blue: Double(rgb & 0x0000FF) / 255.0, opacity: Double(alpha))
    }
}
