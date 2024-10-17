//
//  CustomShape.swift
//  TabViewDemo
//
//  Created by Actor on 2024/10/17.
//
 
import SwiftUI

struct CustomTabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start from bottom left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Draw left side line
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        // Draw the arc on the right-hand side of the plus button
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        // Draw the bottom arc for the plus button
        let midX = rect.midX
        let radius: CGFloat = 40.0
        path.addArc(center: CGPoint(x: midX, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(180),
                    clockwise: false)
        
        // Finish at the bottom right corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }
}
