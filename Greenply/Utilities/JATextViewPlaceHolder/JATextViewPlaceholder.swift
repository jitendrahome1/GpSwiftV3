//
//  JATextViewPlaceholder.swift
//  TextViewPlaceholder
//
//  Created by Jitendra on 9/2/16.
//  Copyright © 2016 Jitendra. All rights reserved.
//

import UIKit
@IBDesignable
class JATextViewPlaceholder: UITextView {
    
    // MARK: - Private Zone
    var placeholderLable = UILabel()
    var lableHight = CGFloat()
    var lableWidth: CGFloat = 250.0
    let fontSize: CGFloat = 20.0
    var xPadding = CGFloat()
    var yPadding =  CGFloat()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.createTextViewPlaceholder()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.createTextViewPlaceholder()
    }
    //MARK;- Used For set the Placeholder text
    @IBInspectable var placeholder: String = "" {
        didSet {
            placeholderLable.text = placeholder
        }
    }
    //MARK;- placeholder Padding for X  axis
    @IBInspectable var paddingX: CGFloat = 0 {
        didSet {
            xPadding = paddingX
            placeholderLable.frame.origin.x = xPadding
        }
    }
    // MARK: - placeholder Padding for Y  axis
    @IBInspectable var paddingY: CGFloat = 0 {
        didSet {
            yPadding = paddingX
            placeholderLable.frame.origin.y = paddingY
        }
    }
    // MARK: - Set placeholder Color
    @IBInspectable var placeholderTextColor: UIColor? {
        didSet {
            placeholderLable.textColor = placeholderTextColor
        }
    }
    override internal var font: UIFont! {
        didSet {
            if placeholderFont == nil {
                placeholderLable.font = font
                let size = text.sizeWithAttributes([NSFontAttributeName:font])
                lableHight = size.height
                placeholderLable.frame.size.height = lableHight
            }
        }
    }
    // MARK: - Set placeholder Font and size
    @IBInspectable var placeholderFont: UIFont? {
        didSet {
            placeholderLable.font = placeholderFont
            placeholderLable.font = placeholderLable.font.fontWithSize(fontSize)
            }
    }
    // MARK: - Create a placeholder lable for text view
    func createTextViewPlaceholder()
    {
        placeholderLable = UILabel(frame: CGRectMake(xPadding, yPadding,lableWidth,lableHight))
        placeholderLable.text = placeholder
        placeholderLable.textColor = placeholderTextColor
        placeholderLable.font = placeholderFont
        placeholderLable.font = placeholderLable.font.fontWithSize(fontSize)
        self.delegate = self
        addSubview(placeholderLable)
    }
}

extension JATextViewPlaceholder: UITextViewDelegate
{   //MARK:-UITextFieldDelegate method
    func textViewDidChange(textView: UITextView) {
        if !textView.hasText() {
            placeholderLable.hidden = false
        }
        else {
            placeholderLable.hidden = true
        }
    }
}
