//
//  JAPlaceholderTextView.swift
//  TextViewPlaceholder
//
//  Created by Jitendra on 9/2/16.
//  Copyright © 2016 Jitendra. All rights reserved.
//

import UIKit
@IBDesignable
class JAPlaceholderTextView: UITextView {

	// MARK: - Private Zone
	var placeholderLabel = UILabel()
	var labelHeight = CGFloat()
	var labelWidth: CGFloat = 250.0
	let fontSize: CGFloat = 20.0
	var xPadding = CGFloat()
	var yPadding = CGFloat()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self.createTextViewPlaceholder()
	}
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)

		self.createTextViewPlaceholder()
	}
	// MARK:- Used For set the Placeholder text
	@IBInspectable var placeholder: String = "" {
		didSet {
			if !self.hasText {
				placeholderLabel.text = placeholder
			}
		}
	}
	// MARK:- placeholder Padding for X  axis
	@IBInspectable var paddingX: CGFloat = 0 {
		didSet {
			xPadding = paddingX
			placeholderLabel.frame.origin.x = xPadding
		}
	}
	// MARK: - placeholder Padding for Y  axis
	@IBInspectable var paddingY: CGFloat = 0 {
		didSet {
			yPadding = paddingX
			placeholderLabel.frame.origin.y = paddingY
		}
	}
	// MARK: - Set placeholder Color
	@IBInspectable var placeholderTextColor: UIColor? {
		didSet {
			placeholderLabel.textColor = placeholderTextColor
		}
	}
	override internal var font: UIFont! {
		didSet {
			if placeholderFont == nil {
				placeholderLabel.font = font
				let size = text.size(attributes: [NSFontAttributeName: font])
				labelHeight = size.height
				placeholderLabel.frame.size.height = labelHeight
			}
		}
	}
	// MARK: - Set placeholder Font and size
	@IBInspectable var placeholderFont: UIFont? {
		didSet {
			placeholderLabel.font = placeholderFont
			placeholderLabel.font = placeholderLabel.font.withSize(fontSize)
		}
	}
	// MARK: - Create a placeholder lable for text view
	func createTextViewPlaceholder()
	{
		placeholderLabel = UILabel(frame: CGRect(x: xPadding, y: 0, width: labelWidth, height: labelHeight))
		placeholderLabel.text = placeholder
		placeholderLabel.textColor = placeholderTextColor
		placeholderLabel.font = placeholderFont
		placeholderLabel.font = placeholderLabel.font.withSize(fontSize)
		self.delegate = self
		self.addSubview(placeholderLabel)
	}

	override var text: String! {
		didSet {
          
            placeholderLabel.isHidden = true
            
			
		}
	}
}

extension JAPlaceholderTextView: UITextViewDelegate
{
	// MARK:-UITextFieldDelegate method
	func textViewDidChange(_ textView: UITextView) {
		if !textView.hasText {
			placeholderLabel.isHidden = false
		}
		else {
			placeholderLabel.isHidden = true
		}
	}

	// MARK:-UITextFieldDelegate method
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		return true
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if range.location == 0 {
			if (text == " " || text == "\n") {
               // placeholderLabel.hidden = false
               // placeholderLabel.frame.origin.y = -40
                
				return false
			}
            else{
                //placeholderLabel.frame.origin.y = -40
                  //placeholderLabel.hidden = true
            }
		} else {
			return true
		}
		return true
	}
    
}
