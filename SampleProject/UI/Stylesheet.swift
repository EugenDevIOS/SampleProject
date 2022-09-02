//
//  Stylesheet.swift
//

import UIKit

public enum Stylesheet {

    // MARK: - Screen

    enum Screen {
        static let screenSize: CGSize = {
            var nativeBounds = UIScreen.main.nativeBounds.size
            nativeBounds.width /= UIScreen.main.nativeScale
            nativeBounds.height /= UIScreen.main.nativeScale
            return nativeBounds
        }()
        static let screenScale: CGFloat = UIScreen.main.scale
        static let singlePixelSize: CGFloat = 1.0 / screenScale
    }

    // MARK: - Colors

    enum Color {
        static let background = UIColor(red: 220 / 255, green: 206 / 255, blue: 190 / 255, alpha: 1.0)
        static let white = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
        static let black = UIColor.black
        static let exploreButton = UIColor(red: 191 / 255, green: 46 / 255, blue: 14 / 255, alpha: 1.0)
    }

    // MARK: - Fonts

    enum FontFace: String {

        case terminalRegular = "TerminalDosis-Regular"
        case terminalBold = "TerminalDosis-Bold"

        static let terminal14 = terminalRegular.fontWithSize(14.0)
        static let terminal18 = terminalRegular.fontWithSize(18.0)
        static let navigationBold = terminalBold.fontWithSize(18.0)

    }

}

// MARK: - Helpers

extension Stylesheet.FontFace {

    func fontWithSize(_ size: CGFloat) -> UIFont {
        guard let actualFont: UIFont = UIFont(name: self.rawValue, size: size) else {
            debugPrint("Can't load fon with name!!! \(self.rawValue)")
            return UIFont.systemFont(ofSize: size)
        }
        return actualFont
    }

    static func printAvailableFonts() {
        for name in UIFont.familyNames {
            debugPrint("<<<<<<< Font Family: \(name)")
            for fontName in UIFont.fontNames(forFamilyName: name) {
                debugPrint("Font Name: \(fontName)")
            }
        }
    }

}
