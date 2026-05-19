//
//  Theme.swift
//  RickMorty
//

import UIKit
import SwiftUI

/// Centralized app theme colors and constants
enum Theme {
    /// Primary accent green color used throughout the app
    static let accentColor = UIColor(red: 0.2, green: 0.5, blue: 0.3, alpha: 1.0)

    /// SwiftUI version of the accent color
    static let accentSwiftUI = Color(red: 0.2, green: 0.5, blue: 0.3)

    /// Accent color at 10% opacity for backgrounds
    static let accentBackground = UIColor(red: 0.2, green: 0.5, blue: 0.3, alpha: 0.1)
}
