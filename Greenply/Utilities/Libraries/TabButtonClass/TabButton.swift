//
//  TabButton.swift
//  DemoView
//
//  Created by Rupam Mitra on 19/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

@IBDesignable

class TabButton: UIView {

	@IBInspectable var image: String?
	@IBInspectable var text: String?

	@IBInspectable var fontName: String?
	@IBInspectable var fontSize: CGFloat = 12.0
	@IBInspectable var textColor: UIColor?
	var isFirstTime: Bool = false
	@IBInspectable var selectedImage: String?
	@IBInspectable var selectedTextColor: UIColor?
	@IBInspectable var selected: Bool = false {
		didSet {
			setNeedsDisplay()
		}
	}

	var didTap: (() -> ())?

	var label: UILabel?
	var imageView: UIImageView?

	override func draw(_ rect: CGRect) {

		if isFirstTime == false {
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center
			let color: UIColor = (selected ? selectedTextColor : textColor)!
			let attribute = [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont(name: fontName!, size: fontSize)!, NSParagraphStyleAttributeName: paragraphStyle]
			let attributedString = NSAttributedString(string: text!, attributes: attribute)

			if label == nil {
				label = UILabel(frame: CGRect(x: 0, y: self.frame.height - 20.0, width: self.frame.width, height: 20.0))
			}

			label!.attributedText = attributedString
			self.addSubview(label!)

			if imageView == nil {
				imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
			}
			imageView?.contentMode = .scaleAspectFit
			imageView!.center = CGPoint(x: self.frame.width / 2, y: label!.frame.minY - 15.0)
			imageView!.image = UIImage(named: (selected ? selectedImage! : image!))
			self.addSubview(imageView!)

			let button = UIButton(frame: self.bounds)
			button.addTarget(self, action: #selector(TabButton.actionTap), for: .touchUpInside)
			self.addSubview(button)
			isFirstTime = true
        }
        else {
            let color: UIColor = (selected ? selectedTextColor : textColor)!
           
            
            label!.textColor = color
            imageView!.image = UIImage(named: (selected ? selectedImage! : image!))

		}
	}

	func actionTap() {

		if selected == false {
			label!.textColor = selectedTextColor
			imageView!.image = UIImage(named: selectedImage!)
			selected = true
		} else {
			label!.textColor = textColor
			imageView!.image = UIImage(named: image!)
			selected = false
		}

		if didTap != nil {
			didTap!()
		}
	}
}
