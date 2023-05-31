//
//  StyledTextField.swift
//  CurrencyConverterChallenge
//
//  Created by Ace Green on 2023-05-24.
//

import UIKit

// MARK: - StyledTextFieldDelegate

protocol StyledTextFieldDelegate: UITextFieldDelegate {
    func textFieldImageSelected()
}

// MARK: - StyledTextField

@IBDesignable
class StyledTextField: UITextField {

    // MARK: - IBInspectable

    @IBInspectable var image: UIImage? { didSet { updateView() }}
    @IBInspectable var padding: CGFloat = 0
    @IBInspectable var rightAligned: Bool = false { didSet { updateView() }}

    // MARK: - Delegates

    var styledTextFieldDelegate: StyledTextFieldDelegate? {
        return delegate as? StyledTextFieldDelegate
    }

    // MARK: - Properties
    var isTextFieldSelected: Bool = false

    // MARK: - Lifecylce methods
    required override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateView()
    }

    // MARK: - Methods

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += padding
        return textRect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= padding
        return textRect
    }

    private func setInsets(forBounds bounds: CGRect) -> CGRect {

        var totalInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        if let leftView = leftView { totalInsets.left += leftView.frame.origin.x }
        if let rightView = rightView { totalInsets.right += rightView.bounds.size.width }

        return bounds.inset(by: totalInsets)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }

    func updateView() {
        rightViewMode = UITextField.ViewMode.never
        rightView = nil
        leftViewMode = UITextField.ViewMode.never
        leftView = nil

        if let image = image {
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            button.tintColor = tintColor

            button.setTitleColor(UIColor.clear, for: .normal)
            button.addTarget(self, action: #selector(textFieldImageSelected(button:)), for: UIControl.Event.touchDown)
            button.isUserInteractionEnabled = true

            if rightAligned {
                rightViewMode = UITextField.ViewMode.always
                rightView = button
            } else {
                leftViewMode = UITextField.ViewMode.always
                leftView = button
            }
        }

        guard let placeholder = placeholder, let tintColor = tintColor else { return }
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [NSAttributedString.Key.foregroundColor: tintColor])
    }

    func setActive() {
        isTextFieldSelected = true
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = Constants.Colours.paypayRed
        animation.duration = 0.2
        layer.borderColor = Constants.Colours.paypayRed.cgColor

        let borderWidth: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = 0
        borderWidth.toValue = 2
        borderWidth.duration = 0.2
        layer.cornerRadius = 5
        layer.borderWidth = 2

        let group = CAAnimationGroup()
        group.animations = [animation, borderWidth]
        layer.add(group, forKey: nil)
    }

    func setInActive() {
        guard isTextFieldSelected else { return }
        let borderWidth: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = 2
        borderWidth.toValue = 1
        borderWidth.duration = 0.2
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.add(borderWidth, forKey: nil)

        isTextFieldSelected = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.subviews.forEach({$0.layer.removeAllAnimations()})
            self.layer.removeAllAnimations()
            self.layoutIfNeeded()
        }
    }

    @objc func textFieldImageSelected(button: UIButton) {
        self.styledTextFieldDelegate?.textFieldImageSelected()
    }
}
