//
//  ToolbarIcon.swift
//  Learning Journey 
//
//  Created by malhajri on 07/06/1448 AH.
//
import SwiftUI

/// Icon for toolbar buttons. iOS 26 draws the glass circle itself,
/// older versions use our own circle.
struct ToolbarIcon: View {
    let systemName: String
    var accent: Color? = nil

    var body: some View {
        if #available(iOS 26.0, *) {
            Image(systemName: systemName)
                .fontWeight(.semibold)
                .foregroundStyle(accent ?? Color.white)
        } else {
            CircleIcon(systemName: systemName, background: accent)
        }
    }
}
