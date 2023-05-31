//
//  StyledNavigationController.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import Foundation
import UIKit

// MARK: - StyledNavigationController

public class StyledNavigationController: UINavigationController {

    // MARK: - Properties

    enum ButtonAppearanceType {
        case back, plain, done
    }

    var styledAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constants.Colours.paypayRed
        appearance.titleTextAttributes = getTitleTextAttributes()
        appearance.largeTitleTextAttributes = getLargeTitleTextAttributes()
        return appearance
    }

    // MARK: - Lifecylce

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    open override var childForStatusBarStyle: UIViewController? {
        return nil
    }

    public var prefersLargeTitles: Bool = false {
        didSet {
            navigationBar.prefersLargeTitles = prefersLargeTitles
        }
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setStyle()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setStyle()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStyle()
    }

    // MARK: - Methods

    private func setStyle() {
        navigationBar.tintColor = UIColor.white
        navigationBar.backgroundColor = Constants.Colours.paypayRed
        navigationBar.isTranslucent = false
        prefersLargeTitles = true

        navigationBar.standardAppearance = styledAppearance
        navigationBar.compactAppearance = styledAppearance
        navigationBar.scrollEdgeAppearance = styledAppearance
    }

    private func buttonAppearance(for type: ButtonAppearanceType) -> UIBarButtonItemAppearance {
        let buttonAppearance = UIBarButtonItemAppearance()
        let normalState = buttonAppearance.normal
        let selectedState = buttonAppearance.highlighted
        switch type {
        case .back:
            normalState.titleTextAttributes = getBackButtonTitleTextAttributes(for: .normal)
            selectedState.titleTextAttributes = getBackButtonTitleTextAttributes(for: .selected)
        case .done:
            normalState.titleTextAttributes = getDoneButtonTitleTextAttributes(for: .normal)
            selectedState.titleTextAttributes = getDoneButtonTitleTextAttributes(for: .selected)
        case .plain:
            normalState.titleTextAttributes = getDefaultButtonTitleTextAttributes(for: .normal)
            selectedState.titleTextAttributes = getDefaultButtonTitleTextAttributes(for: .selected)
        }
        return buttonAppearance
    }

    private func getTitleTextAttributes() -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    private func getLargeTitleTextAttributes() -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24),
                NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    private func getBackButtonTitleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key: Any] {
        switch state {
        case .selected:
            return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.white]
        default:
            return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }

    private func getDefaultButtonTitleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key: Any] {
        switch state {
        case .selected:
            return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.white]
        default:
            return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }

    private func getDoneButtonTitleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key: Any] {
        switch state {
        case .selected:
            return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.white]
        default:
            return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}
