//
//  GPExtentions.swift
//  Greenply
//
//  Created by Jitendra on 9/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import Foundation
import UIKit

extension String
{
	// MARK:- Trimming the whitespace from a string and check empty of string
	public var isBlank: Bool {
		get {
			let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
			return trimmed.isEmpty
		}
	}
    
    // Trim the String
    func trimString(forString myString: String?)->String
    {
    let trimmedString = myString!.trimmingCharacters(
        in: CharacterSet.whitespacesAndNewlines
        
    )
    return trimmedString
    }
    
    // This Function Remove extra space and new line both in string.
    func condenseWhitespace(_ string: String) -> String {
        let components = string.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        let  string = components.joined(separator: " ")
        return string
    }
    
    // This Function Separated the string with spical char
    
    func stringSeparatedWith(forString separatedString: String, separatedBy: String)->String{
        let splitArray = separatedString.components(separatedBy: separatedBy)
        
        var StrResult = ""
        for index in 0..<splitArray.count {
            StrResult = StrResult + (splitArray[index])
            if index < splitArray.count - 1 {
                StrResult = StrResult + " "
            }
        }
        return StrResult
    }
    
    
    
    //To check String is not null/NULL/nil.
    static func isSafeString(_ strOpt: AnyObject?) -> Bool {
        var returnVar = true
        if let tempStr = strOpt as? String {
            if tempStr.lowercased() == "null" || tempStr.lowercased() == "<null>" {
                returnVar = false
            }
        }
        else {
            returnVar = false
        }
        return returnVar
    }

    

	// MARK:- Verify email address is correct format or not.
	var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		let result = emailTest.evaluate(with: self)
		return result

	}
	// MARK:- Show Error Message
	func showErrorMessage(_ messge: String, textField: UITextField)
	{
		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = 0.07
		animation.repeatCount = 4
		animation.autoreverses = true
		animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
		animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
		textField.layer.add(animation, forKey: "position")
		let attributes = [
			NSForegroundColorAttributeName: UIColor.red,
			NSFontAttributeName: UIFont(name: FONT_NAME, size: 12)! // Note the !
		]
		textField.attributedPlaceholder = NSAttributedString(string: messge, attributes: attributes)
		textField.text = ""
	}

	func requiredHeight(forWidth width: CGFloat, andFont font: UIFont) -> CGFloat {

		let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byWordWrapping
		label.font = font
		label.text = self
		label.sizeToFit()
		return label.frame.height
	}

	func requiredWidth(forHeight height: CGFloat, andFont font: UIFont) -> CGFloat {

		let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byWordWrapping
		label.font = font
		label.text = self
		label.sizeToFit()
		return label.frame.width
	}

	// MARK: Label Justified
	func labelJustified(_ labelText: UILabel)
	{
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .justified
		paragraphStyle.firstLineHeadIndent = 0.001

		let mutableAttrStr = NSMutableAttributedString(attributedString: labelText.attributedText!)
		mutableAttrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, mutableAttrStr.length))
		labelText.attributedText = mutableAttrStr
	}
    
    //MARK: Random String
    static func randomString(_ length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        return string
    }
   func toDouble() -> Double? {
            return NumberFormatter().number(from: self)?.doubleValue
        }
    
    
   // This Function Match String
        
        func contains(_ find: String) -> Bool{
            return self.range(of: find) != nil
        }
        
        func containsIgnoringCase(_ find: String) -> Bool{
            return self.range(of: find, options: NSString.CompareOptions.caseInsensitive) != nil
        }
    
    

}

extension UILabel {

	open override func layoutSubviews() {
		super.layoutSubviews()
		if self.superview != nil && (self.superview?.isKind(of: UIActivityViewController.self))! {
			if self.superview!.isKind(of: UIButton.self) {
				if self.superview!.isKind(of: NSClassFromString("UINavigationButton")!) {
					self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
				}
             else {
					self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
				}
            }else if self.superview!.isKind(of: NSClassFromString("UIDatePickerContentView")!) {
              return
            }else {
				self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
			}
		}
	}
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }


}

//MARK: Array
extension Array where Element: Comparable {

	mutating func removeObject(_ object: Element) {
		if let index = self.index(of: object) {
			self.remove(at: index)
		}
	}

	mutating func removeObjects(_ objectArray: [Element])
	{
		for object in objectArray {
			self.removeObject(object)
		}
	}
}

extension Array {

	func containsObject(_ type: AnyClass) -> (isPresent: Bool, index: Int?) {
		for (index, item) in self.enumerated() {
			if (item as AnyObject).isKind(of: type) {
				return (true, index)
			}
		}
		return (false, nil)
	}
    
    
  
        
        func indexes<T: Equatable>(ofItemsNotEqualTo item: T) -> [Int]?  {
            var result: [Int] = []
            for (n, elem) in self.enumerated(){
                if elem as? T != item {
                    result.append(n)
                }
            }
            return result.isEmpty ? nil : result
        }
    
    
    
}

extension UIButton {
	// MARK Button and image alignment Like tabbar,
	func alignImageAndTitleVertically(_ padding: CGFloat) {
		let imageSize = self.imageView!.frame.size
		let titleSize = self.titleLabel!.frame.size
		let totalHeight = imageSize.height + titleSize.height + padding

		self.imageEdgeInsets = UIEdgeInsets(
			top: -(totalHeight - imageSize.height),
			left: 0,
			bottom: 0,
			right: -titleSize.width
		)

		self.titleEdgeInsets = UIEdgeInsets(
			top: 0,
			left: -imageSize.width,
			bottom: -(totalHeight - titleSize.height),
			right: 0
		)
	}

}

//MARK:- CALayer

extension CALayer {

	var borderUIColor: UIColor {
		set {
			self.borderColor = newValue.cgColor
		}

		get {
			return UIColor(cgColor: self.borderColor!)
		}
	}
}

//MARK: UIAlertController

extension UIAlertController {

	
    public class func showStandardAlertWithOnlyOK(_ title: String, alertText: String, selected_: @escaping (_ index: Int) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: alertText, preferredStyle: .alert)
//        alert.view.tintColor = DEFAULT_COLOR
		let doneAction = UIAlertAction(title: OK, style: .default) { (action) in
			selected_(0)
		}
		alert.addAction(doneAction)
		return alert
	}

	public class func showStandardAlertWith(_ title: String, alertText: String, selected_: @escaping (_ index: Int) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: alertText, preferredStyle: .alert)
//        alert.view.tintColor = DEFAULT_COLOR
		let cancelAction = UIAlertAction(title: CANCEL, style: .cancel) { (action) in
			selected_(0)
		}
		alert.addAction(cancelAction)
		let doneAction = UIAlertAction(title: OK, style: .default) { (action) in
			selected_(1)
		}
		alert.addAction(doneAction)
		return alert
	}

	public class func showStandardAlertWith(_ title: String, alertText: String, positiveButtonText: String?, negativeButtonText: String?, selected_: @escaping (_ index: Int) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: alertText, preferredStyle: .alert)
		// alert.view.tintColor = DEFAULT_COLOR
		let cancelAction = UIAlertAction(title: negativeButtonText, style: .cancel) { (action) in
			selected_(0)
		}
		alert.addAction(cancelAction)
		let doneAction = UIAlertAction(title: positiveButtonText, style: .default) { (action) in
			selected_(1)
		}
		alert.addAction(doneAction)
		return alert
	}

	public class func showStandardActionSheetWith(_ title: String, messageText: String, arrayButtons: [String], selectedIndex: @escaping (_ index: Int) -> ()) -> UIAlertController {
		let actionSheet = UIAlertController(title: title, message: messageText, preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: CANCEL, style: .cancel) { (action) in

		}
		actionSheet.addAction(cancelAction)
		for (index, item) in arrayButtons.enumerated() {
			let buttonAction = UIAlertAction(title: item, style: .default, handler: { (action) in
				selectedIndex(index)
			})
			actionSheet.addAction(buttonAction)
		}
		return actionSheet
	}

	public class func showStandardAlertWithTextField(_ title: String, alertText: String, selected_: @escaping (_ index: Int, _ email: String) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: alertText, preferredStyle: .alert)
		alert.addTextField { (textField) in
			textField.placeholder = "Enter email"
			textField.keyboardType = .emailAddress
		}
//        alert.view.tintColor = DEFAULT_COLOR
		let cancelAction = UIAlertAction(title: CANCEL, style: .default) { (action) in
			selected_(0, "")
		}
		alert.addAction(cancelAction)
		let doneAction = UIAlertAction(title: OK, style: .default) { (action) in
			selected_(1, alert.textFields![0].text!)
		}
		alert.addAction(doneAction)
		return alert
	}
}

//MARK: -  NSDate
extension Date {

	func dateToStringWithCustomFormat(_ format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.timeZone = TimeZone.autoupdatingCurrent
		return dateFormatter.string(from: self)
	}

	static func dateFromTimeInterval(_ timeInterval: Double) -> Date {
		// Convert to Date
		return Date(timeIntervalSince1970: timeInterval)
	}

	func getFormattedStringWithFormat() -> String? {
		return "\(getDay())\(getDateSuffixForDate()!) \(getThreeCharacterMonth()) '\(getTwoDigitYear())"
	}

	func getDateSuffixForDate() -> (String?) {
		let ones = getDay() % 10
		let tens = (getDay() / 10) % 10
		if (tens == 1) {
			return "th"
		} else if (ones == 1) {
			return "st"
		} else if (ones == 2) {
			return "nd"
		} else if (ones == 3) {
			return "rd"
		} else {
			return "th"
		}
	}

	func getDay() -> (Int) {
		let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		let components = (calendar as NSCalendar?)?.components(.day, from: self)
		return components!.day!
	}

	func getMonth() -> (String) {
		let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		let components = (calendar as NSCalendar?)?.components(.month, from: self)
		let dateFormatter = DateFormatter()
		return dateFormatter.monthSymbols[(components?.month)! - 1]
	}

	func getThreeCharacterMonth() -> (String) {
		return getMonth().substring(to: getMonth().characters.index(getMonth().startIndex, offsetBy: 3))
	}

	func getYear() -> (Int) {
		let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		let components = (calendar as NSCalendar?)?.components(.year, from: self)
		return components!.year!
	}

	func getTwoDigitYear() -> (Int) {
		return getYear() % 100
	}
    
   static func convertTimeStampToDate(_ timeInterval: Double)->String{
        let date = Date(timeIntervalSince1970: timeInterval)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM, YYYY"
        let dateString = dayTimePeriodFormatter.string(from: date)
        return dateString
    }
    
    // Convert  birth-
    static func convertTimeStampToBirthDate(_ timeInterval: Double)->String{
        let date = Date(timeIntervalSince1970: timeInterval)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd-MM-YYYY"
        let dateString = dayTimePeriodFormatter.string(from: date)
        return dateString
    }
    
    static func getTimeStamp() -> String{
    return "\(Date().timeIntervalSince1970 * 1000)"
  
    }
    
}
extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.remove(at: index!)
        }
    }
}


