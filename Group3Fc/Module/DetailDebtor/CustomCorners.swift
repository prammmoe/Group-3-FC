//
//  CustomCorners.swift
//  Group3Fc
//
//  Created by Mario Pandapotan Simarmata on 23/03/25.
//
import SwiftUI

struct CustomCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
