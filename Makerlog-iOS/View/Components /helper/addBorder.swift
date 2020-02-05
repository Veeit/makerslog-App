//
//  addBorder.swift
//  INEZ
//
//  Created by Veit Progl on 03.11.19.
//  Copyright © 2019 Veit Progl. All rights reserved.
//

import SwiftUI

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
    }
}
