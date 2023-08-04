//
//  OffsetKey.swift
//  Task Management
//
//  Created by Panchenko Oleg on 03.08.2023.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
