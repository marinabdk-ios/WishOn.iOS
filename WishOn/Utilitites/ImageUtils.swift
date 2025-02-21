//
//  ImageUtils.swift
//  WishOn
//
//  Created by Mari Budko on 21.02.2025.
//

import Foundation
import UIKit

class ImageUtils {
    static func fixOrientation(for image: UIImage) -> UIImage {
            if image.imageOrientation == .up {
                return image
            }

            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: image.size))
            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            return normalizedImage
        }
}
