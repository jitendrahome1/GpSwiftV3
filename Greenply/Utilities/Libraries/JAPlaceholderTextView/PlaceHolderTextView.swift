//
//  PlaceHolderTextView.swift
//  Greenply
//
//  Created by Jitendra on 17/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class PlaceHolderTextView: UITextView {
    var placeholderLabel = UILabel()
    var placeholderText: String?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       // self.createTextViewPlaceholder()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.createTextViewPlaceholder()
    }
    // MARK: - Create a placeholder lable for text view
    func createTextViewPlaceholder()
    {
          placeholderLabel = UILabel(frame: CGRect(x: 8, y: 3, width: self.bounds.width - 5, height: 24))
        placeholderLabel.text = placeholderText
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = UIFont(name: placeholderLabel.font.fontName, size: IS_IPAD() ? 22 : 15)
     placeholderLabel.textAlignment = NSTextAlignment.left
        self.delegate = self
        addSubview(placeholderLabel)
    }

}

extension PlaceHolderTextView: UITextViewDelegate
{
    // MARK:-UITextFieldDelegate method
    func textViewDidChange(_ textView: UITextView) {
      
        if !(textView.text.isEmpty){
          placeholderLabel.isHidden = true
        }else{
         placeholderLabel.isHidden = false
        }
    }
    
    // MARK:-UITextFieldDelegate method
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
}
}
