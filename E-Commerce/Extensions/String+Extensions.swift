//
//  String+Extensions.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 14.03.2025.
//
import UIKit

extension String {
    func toImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self) else { return nil }
        return UIImage(data: imageData)
    }
}
