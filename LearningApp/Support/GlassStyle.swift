//
//  GlassStyle.swift
//  MyApp
//
//  Created by malhajri on 07/06/1448 AH.
//
import SwiftUI

struct GlassModifier<S: Shape>: ViewModifier {
    let shape: S
    let tint: Color?
    let interactive: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(makeGlass(), in: shape)
        } else {
            content.background(shape.fill(.ultraThinMaterial))
        }
    }

    @available(iOS 26.0, *)
    private func makeGlass() -> Glass {
        var glass = Glass.regular
        if let tint = tint { glass = glass.tint(tint) }
        if interactive { glass = glass.interactive() }
        return glass
    }
}

extension View {
    func glassBackground<S: Shape>(_ shape: S, tint: Color? = nil, interactive: Bool = false) -> some View {
        modifier(GlassModifier(shape: shape, tint: tint, interactive: interactive))
    }
}
