//
//  UIStoryboard+Extensions.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import Foundation
import UIKit

extension UIStoryboard {

    class func named(_ name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }

    func controller<Controller>(class: Controller.Type) -> Controller where Controller: UIViewController {
        // swiftlint:disable:next force_cast
        return instantiateViewController(withIdentifier: String(describing: Controller.self)) as! Controller
    }
}
