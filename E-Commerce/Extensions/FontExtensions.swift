//
//  FontExtensions.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 05.03.2025.
//

import UIKit

enum CustomFont: String {
    case nunitoBlack = "NunitoSans-Black"
    case nunitoBlackItalic = "NunitoSans-BlackItalic"
    case nunitoBold = "NunitoSans-Bold"
    case nunitoBoldItalic = "NunitoSans-BoldItalic"
    case nunitoItalic = "NunitoSans-Italic"
    case nunitoLight = "NunitoSans-Light"
    case nunitoLightItalic = "NunitoSans-LightItalic"
    case nunito = "NunitoSans-Regular"
    case nunitoSemiBold = "NunitoSans-SemiBold"
    case nunitoSemiBoldItalic = "NunitoSans-SemiBoldItalic"
    case ralewayItalic = "Raleway-v4020-Italic"
    case ralewayBlack = "Raleway-v4020-Black"
    case ralewayBlackItalic = "Raleway-v4020-BlackItalic"
    case ralewayBold = "Raleway-v4020-Bold"
    case ralewayBoldItalic = "Raleway-v4020-BoldItalic"
    case ralewayLight = "Raleway-v4020-Light"
    case ralewayLightItalic = "Raleway-v4020-LightItalic"
    case ralewayMedium = "Raleway-v4020-Medium"
    case ralewayMediumItalic = "Raleway-v4020-MediumItalic"
    case raleway = "Raleway-v4020-Regular"
    case ralewaySemiBold = "Raleway-v4020-SemiBold"
    case ralewaySemiBoldItalic = "Raleway-v4020-SemiBoldItalic"
    case ralewayThin = "Raleway-v4020-Thin"
    case ralewayThinItalic = "Raleway-v4020-ThinItalic"
}

extension UIFont {
    /// Используем кастомный шрифт
    /// пример использования
    /// label.font = .custom(font: CustomFont.ralewayBlack, size: 17)
    static func custom(font: CustomFont, size: CGFloat) -> UIFont {
        UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

