//
//  UIImage+Extesions.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 14.03.2025.
//

import UIKit

extension UIImage {
    func toBase64(quality: CGFloat = 1.0) -> String? {
        guard let imageData = self.jpegData(compressionQuality: quality) else { return nil }
        return imageData.base64EncodedString()
    }
}
