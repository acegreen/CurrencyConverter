//
//  UIImage+Extensions.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import UIKit

extension String {

    func toImage(fontSize: CGFloat = 20, bgColor: UIColor = UIColor.clear, imageSize: CGSize? = nil) -> UIImage? {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let imageSize = imageSize ?? self.size(withAttributes: attributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        bgColor.set()
        let rect = CGRect(origin: .zero, size: imageSize)
        UIRectFill(rect)
        self.draw(in: rect, withAttributes: [.font: font])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
