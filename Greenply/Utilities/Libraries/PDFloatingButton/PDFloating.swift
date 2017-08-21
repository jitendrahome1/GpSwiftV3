//
//  PDFloating.Swift
//  PDFloating
//
//  Created by Priyam Dutta on 27/08/16.
//  Copyright © 2016 Priyam Dutta. All rights reserved.
//

import UIKit

enum ButtonPosition {
	case center
	case topLeft
	case topRight
	case bottomLeft
	case bottomRight
	case midTop
	case midBottom
	case midLeft
	case midRight
}

func getRadian(_ degree: CGFloat) -> CGFloat {
	return CGFloat(degree * CGFloat(M_PI) / 180)
}

class PDFloating: UIButton {

	fileprivate let childButtonSize: CGFloat = 30.0
	fileprivate let delayInterval = 0.0
	fileprivate let duration = 0.25
	fileprivate let damping: CGFloat = 0.9
	fileprivate let initialVelocity: CGFloat = 0.9
	fileprivate var anchorPoint: CGPoint!

	fileprivate var xPadding: CGFloat = 10.0
	fileprivate var yPadding: CGFloat = 10.0
	fileprivate var buttonSize: CGFloat = 0.0
	fileprivate var childButtons = 0
	fileprivate var buttonPosition: ButtonPosition = .center
	fileprivate var childButtonsArray = [UIButton]()
	fileprivate var childLabelsArray = [UILabel]()
	fileprivate var imageArray = [String]()
	fileprivate var textArray = [String]()
	fileprivate var spacing: CGFloat = 40.0
	fileprivate var labelPadding: CGFloat = 20.0
	fileprivate var backView = UIView()

	var isOpen = false
	var buttonActionDidSelected: ((_ indexSelected: Int) -> ())!

	convenience init(withPosition position: ButtonPosition, size: CGFloat, numberOfPetals: Int, images: [String], labelStrings: [String]) {

		self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
		self.layer.cornerRadius = size / 2.0

		childButtons = numberOfPetals
		buttonPosition = position
		imageArray = images
		textArray = labelStrings

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {

			switch position {
			case .topLeft:
				self.center = CGPoint(x: (self.superview?.frame)!.minX + (size / 2.0) + self.xPadding, y: (self.superview?.frame)!.minY + (size / 2.0) + self.yPadding)
			case .topRight:
				self.center = CGPoint(x: (self.superview?.frame)!.maxX - (size / 2.0) - self.xPadding, y: (self.superview?.frame)!.minY + (size / 2.0) + self.yPadding)
			case .bottomLeft:
				self.center = CGPoint(x: (self.superview?.frame)!.minX + (size / 2.0) + self.xPadding, y: (self.superview?.frame)!.maxY - (size / 2.0) - self.yPadding)
			case .bottomRight:
				self.center = CGPoint(x: (self.superview?.frame)!.maxX - (size / 2.0) - self.xPadding, y: (self.superview?.frame)!.maxY - (size / 2.0) - self.yPadding)
			case .midTop:
				self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.minY + (size / 2.0) + self.yPadding)
			case .midBottom:
				self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.maxY - (size / 2.0) - self.yPadding)
			case .midLeft:
				self.center = CGPoint(x: (self.superview?.frame)!.minX + (size / 2.0) + self.xPadding, y: (self.superview?.frame)!.midY)
			case .midRight:
				self.center = CGPoint(x: (self.superview?.frame)!.maxX - (size / 2.0) - (self.xPadding), y: (self.superview?.frame)!.midY)
			default:
				self.center = CGPoint(x: (self.superview?.frame)!.midX, y: (self.superview?.frame)!.midY)
			}
			self.anchorPoint = self.center
			self.createButtonsWithLabels(numberOfPetals)
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
//		backgroundColor = .brownColor()
		self.addTarget(self, action: #selector(self.animateChildButtons(_:)), for: .touchUpInside)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// Create Buttons
	fileprivate func createButtonsWithLabels(_ numbers: Int) {

		for index in 0..<numbers {
			let petal = UIButton(frame: CGRect(x: 0, y: 0, width: childButtonSize, height: childButtonSize))
			petal.center = self.center
			petal.layer.cornerRadius = childButtonSize / 2.0
//            petal.backgroundColor = UIColor.cyanColor()
			petal.setTitleColor(UIColor.black, for: UIControlState())
			petal.tag = index + 1
			if index < imageArray.count {
				petal.setBackgroundImage(UIImage(named: imageArray[index]), for: UIControlState())
			}
//            petal.setTitle(String(index), forState: UIControlState())
			petal.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)

			let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: childButtonSize))
			label.center = CGPoint(x: petal.frame.minX - (label.frame.width / 2.0) - labelPadding, y: petal.frame.midY)
			label.textAlignment = .right
//            label.alpha = 0.0
			label.isHidden = true
			label.textColor = .white
			label.font = PRIMARY_FONT(IS_IPAD() ? 18.0 : 15.0)
			if index < textArray.count {
				label.text = textArray[index]
			}
			self.superview?.addSubview(label)
			self.superview?.bringSubview(toFront: self)
			self.superview?.addSubview(petal)
			self.superview?.bringSubview(toFront: self)
			childButtonsArray.append(petal)
			childLabelsArray.append(label)
		}
	}

	// Present Buttons
	@IBAction func animateChildButtons(_ sender: UIButton) {
		scaleAnimate(sender)
		self.isUserInteractionEnabled = false
		if !isOpen {
			self.presentationFloatingButtons()
		} else {
			closeButtons()
		}
	}

	// Simple Scale
	fileprivate func scaleAnimate(_ sender: UIView) {
		UIView.animate(withDuration: self.duration, animations: {
			sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
		}, completion: { (complete) in
			UIView.animate(withDuration: self.duration, animations: {
				sender.transform = CGAffineTransform.identity
			})
		}) 
	}

	// Presentation
	fileprivate func presentationFloatingButtons() {
		createBack()
		for (index, item) in self.childButtonsArray.enumerated() {
			item.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
			childLabelsArray[index].isHidden = false
			childLabelsArray[index].transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
			UIView.animate(withDuration: self.duration, delay: self.delayInterval + (Double(index) / 10), usingSpringWithDamping: damping, initialSpringVelocity: initialVelocity, options: UIViewAnimationOptions(), animations: {
				self.childLabelsArray[index].alpha = 1.0
				self.childLabelsArray[index].transform = CGAffineTransform(translationX: 0, y: -CGFloat((CGFloat(item.tag) + self.spacing) * CGFloat(item.tag)))
				item.transform = CGAffineTransform(translationX: 0, y: -CGFloat((CGFloat(item.tag) + self.spacing) * CGFloat(item.tag)))
				}, completion: { (completion) in
				self.isOpen = true
				if index == self.childButtonsArray.count - 1 {
					self.isUserInteractionEnabled = true
				}
			})
		}
	}

	// Close Button
	@objc func closeButtons() {
		UIView.animate(withDuration: self.duration, animations: {
			for (index, item) in self.childButtonsArray.enumerated() {
				self.childLabelsArray[index].alpha = 0.0
				self.childLabelsArray[index].transform = CGAffineTransform.identity
				item.transform = CGAffineTransform.identity
			}
			}, completion: { (completion) in
			self.isOpen = false
			self.isUserInteractionEnabled = true
			self.backView.removeFromSuperview()
		})
	}

    func removeButton() {
        for item in self.childButtonsArray {
            item.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
	func createBack() {
		backView = UIView(frame: UIScreen.main.bounds)
		backView.backgroundColor = .black
		backView.alpha = 0.4
		backView.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector(PDFloating.closeButtons)))
		self.superview!.addSubview(backView)
		self.superview?.insertSubview(backView, belowSubview: childLabelsArray[0])
	}

	@IBAction func buttonAction(_ sender: UIButton) {
		if isOpen {
			closeButtons()
		}
		if buttonActionDidSelected != nil {
			buttonActionDidSelected(sender.tag - 1)
		}
	}

}
