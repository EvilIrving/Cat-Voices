//
//  Extension.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

// 新增扩展
import SwiftUI

// MARK: - Color Extension
extension Color {
    // Light Theme Colors
    static let light50 : Color? = Color(hex: "#fafee8")
    static let light100 : Color? = Color(hex: "#f2fec3")
    static let light200 : Color? = Color(hex: "#ecff89")
    static let light300 : Color? = Color(hex: "#e6fe46")
    static let light400 : Color? = Color(hex: "#e6fb14")
    static let light500 : Color? = Color(hex: "#e0eb07")
    static let light600 : Color? = Color(hex: "#d3cc03")
    static let light700 : Color? = Color(hex: "#a28f06")
    static let light800 : Color? = Color(hex: "#86700d")
    static let light900 : Color? = Color(hex: "#725b11")
    static let light950 : Color? = Color(hex: "#423106")

    // Dark Theme Colors
    static let dark50 : Color? = Color(hex: "#edfee7")
    static let dark100 : Color? = Color(hex: "#d8fbcc")
    static let dark200 : Color? = Color(hex: "#b2f79f")
    static let dark300 : Color? = Color(hex: "#82ef67")
    static let dark400 : Color? = Color(hex: "#59e239")
    static let dark500 : Color? = Color(hex: "#38cb1a")
    static let dark600 : Color? = Color(hex: "#25a010")
    static let dark700 : Color? = Color(hex: "#1f7a11")
    static let dark800 : Color? = Color(hex: "#1e6014")
    static let dark900 : Color? = Color(hex: "#1b5215")
    static let dark950 : Color? = Color(hex: "#092d06")

    // Helper method to create Color from hex
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (1, 1, 1, 1)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
