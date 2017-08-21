//
//  JATextField.swift
//  Greenply
//
//  Created by Jitendra on 9/1/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
@IBDesignable
class JATextField: UITextField {

	var iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: IS_IPAD() ? 60 : 50, height: IS_IPAD() ? 70 : 50))
	var padding: UIEdgeInsets = UIEdgeInsets()

	// MARK: - Used for placeholder Pading
	@IBInspectable var leftPading: CGFloat = 0
	{
		didSet {
			padding = UIEdgeInsets(top: 0, left: (iconImageView.frame).width + leftPading, bottom: 0, right: 5);
		}
	}
	// MARK: - Used for corner Redius.
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			layer.cornerRadius = cornerRadius
			self.clipsToBounds = true
		}
	}
	// MARK: - Used for Set Image Icon
	@IBInspectable var image: UIImage? {
		didSet {
			self.leftViewMode = UITextFieldViewMode.always
			// iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: IS_IPAD() ? 60 : 45, height: self.frame.height))
			iconImageView.image = image
			self.leftView = iconImageView
		}
	}
	// MARK:- Used For Border Width
	@IBInspectable var BorderWidth: CGFloat = 0 {
		didSet {
			self.layer.borderWidth = BorderWidth
		}
	}
	// MARK:- Used For Border Color
	@IBInspectable var borderColor: UIColor? {
		didSet {
			self.layer.borderColor = borderColor?.cgColor
		}
	}
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}

	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
}


extension JATextField
{
	// MARK:- UITextFieldDelegate method
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
