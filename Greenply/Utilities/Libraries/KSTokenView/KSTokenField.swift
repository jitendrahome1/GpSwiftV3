//
//  KSTokenField.swift
//  KSTokenView
//
//  Created by Khawar Shahzad on 01/01/2015.
//  Copyright (c) 2015 Khawar Shahzad. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

enum KSTokenFieldState {
   case opened
   case closed
}


@objc protocol KSTokenFieldDelegate : UITextFieldDelegate {
   func tokenFieldShouldChangeHeight(_ height: CGFloat)
   @objc optional func tokenFieldDidSelectToken(_ token: KSToken)
   @objc optional func tokenFieldDidBeginEditing(_ tokenField: KSTokenField)
   @objc optional func tokenFieldDidEndEditing(_ tokenField: KSTokenField)
}


class KSTokenField: UITextField {
   
   // MARK: - Private Properties
   fileprivate var _cursorColor: UIColor = UIColor.gray {
      willSet {
         tintColor = newValue
      }
   }
   fileprivate var _setupCompleted: Bool = false
   fileprivate var _selfFrame: CGRect?
   fileprivate var _caretPoint: CGPoint?
   fileprivate var _placeholderValue: String?
   fileprivate var _placeholderLabel: UILabel?
   fileprivate var _state: KSTokenFieldState = .opened
   fileprivate var _minWidthForInput: CGFloat = 50.0
   fileprivate var _separatorText: String?
   fileprivate var _font: UIFont?
   fileprivate var _paddingX: CGFloat?
   fileprivate var _paddingY: CGFloat?
   fileprivate var _marginX: CGFloat?
   fileprivate var _marginY: CGFloat?
   fileprivate var _removesTokensOnEndEditing = true
   fileprivate var _scrollView = UIScrollView(frame: .zero)
   fileprivate var _scrollPoint = CGPoint.zero
    fileprivate var _direction: KSTokenViewScrollDirection = .vertical {
      didSet {
         if (oldValue != _direction) {
            updateLayout()
         }
      }
   }
   fileprivate var _descriptionText: String = "selections" {
      didSet {
         _updateText()
      }
   }
   
   // MARK: - Public Properties
   
   /// default is grayColor()
   var promptTextColor: UIColor = UIColor.gray
   
   /// default is grayColor()
   var placeHolderColor: UIColor = UIColor.gray
   
   /// default is 120.0. After maximum limit is reached, tokens starts scrolling vertically
   var maximumHeight: CGFloat = 50.0
   
   /// default is nil
   override var placeholder: String? {
      get {
         return _placeholderValue
      }
      set {
         super.placeholder = newValue
         if (newValue == nil) {
            return
         }
         _placeholderValue = newValue
      }
   }
   
   weak var parentView: KSTokenView? {
      willSet (tokenView) {
         if (tokenView != nil) {
            _cursorColor = tokenView!.cursorColor
            _paddingX = tokenView!.paddingX
            _paddingY = tokenView!.paddingY
            _marginX = tokenView!.marginX
            _marginY = tokenView!.marginY
            _direction = tokenView!.direction
            _font = tokenView!.font
            _minWidthForInput = tokenView!.minWidthForInput
            _separatorText = tokenView!.separatorText
            _removesTokensOnEndEditing = tokenView!.removesTokensOnEndEditing
            _descriptionText = tokenView!.descriptionText
            _setPromptText(tokenView!.promptText)
            
            if (_setupCompleted) {
               updateLayout()
            }
         }
      }
   }
   
   weak var tokenFieldDelegate: KSTokenFieldDelegate? {
      didSet {
         delegate = tokenFieldDelegate
      }
   }
   
   /// returns Array of tokens
   var tokens = [KSToken]()
   
   /// returns selected KSToken object
   var selectedToken: KSToken?
   
   // MARK: - Constructors
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      _setupTokenField()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      _setupTokenField()
   }
   
   
   // MARK: - Methods
   
   // MARK: - Setup
   fileprivate func _setupTokenField() {
      text = ""
      autocorrectionType = UITextAutocorrectionType.no
      autocapitalizationType = UITextAutocapitalizationType.none
      contentVerticalAlignment = UIControlContentVerticalAlignment.top
      returnKeyType = UIReturnKeyType.done
      text = KSTextEmpty
      backgroundColor = UIColor.white
      clipsToBounds = true
      _state = .closed
      
      _setScrollRect()
      _scrollView.backgroundColor = UIColor.clear
      
      _scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIResponder.becomeFirstResponder))
      gestureRecognizer.cancelsTouchesInView = false
      _scrollView.addGestureRecognizer(gestureRecognizer)
      _scrollView.delegate = self
      addSubview(_scrollView)
      
      addTarget(self, action: #selector(KSTokenField.tokenFieldTextDidChange(_:)), for: UIControlEvents.editingChanged)
   }
   
   fileprivate func _setScrollRect() {
      _scrollView.frame = CGRect(x: _leftViewRect().width, y: 0, width: frame.width - _leftViewRect().width, height: frame.height)
   }
   
   override func draw(_ rect: CGRect) {
      _selfFrame = rect
      _setupCompleted = true
      _updateText()
      
      // Fix the bug which doesn't update the UI when _selfFrame is not set.
      // https://github.com/khawars/KSTokenView/issues/11
      
      if (tokens.count > 0) {
         updateLayout()
      }
   }
   
   // MARK: - Add Token
   /**
   Create and add new token
   
   - parameter title: String value
   
   - returns: KSToken object
   */
   func addTokenWithTitle(_ title: String) -> KSToken? {
      return addTokenWithTitle(title, tokenObject: nil)
   }
   
   /**
   Create and add new token with custom object
   
   - parameter title:       String value
   - parameter tokenObject: Any custom object
   
   - returns: KSToken object
   */
   func addTokenWithTitle(_ title: String, tokenObject: AnyObject?) -> KSToken? {
      let token = KSToken(title: title, object: tokenObject)
      return addToken(token)
   }
   
   /**
   Add new token
   
   - parameter token: KSToken object
   
   - returns: KSToken object
   */
   func addToken(_ token: KSToken) -> KSToken? {
      if (token.title.characters.count == 0) {
         token.title = "Untitled"
      }
      
      if (!tokens.contains(token)) {
         token.addTarget(self, action: #selector(KSTokenField.tokenTouchDown(_:)), for: .touchDown)
         token.addTarget(self, action: #selector(KSTokenField.tokenTouchUpInside(_:)), for: .touchUpInside)
         tokens.append(token)
         _insertToken(token)
      }
      
      return token
   }
   
   fileprivate func _insertToken(_ token: KSToken, shouldLayout: Bool = true) {
      _scrollView.addSubview(token)
      _scrollView.bringSubview(toFront: token)
      token.setNeedsDisplay()
      if shouldLayout == true {
         updateLayout()
      }
   }
   
   //MARK: - Delete Token
   /*
   **************************** Delete Token ****************************
   */
   
   /**
   Deletes a token from view
   
   - parameter token: KSToken object
   */
   func deleteToken(_ token: KSToken) {
      removeToken(token)
   }
   
   /**
   Deletes a token from view, if any token is found for custom object
   
   - parameter object: Custom object
   */
   func deleteTokenWithObject(_ object: AnyObject?) {
      if object == nil {return}
      for token in tokens {
         if (token.object!.isEqual(object)) {
            removeToken(token)
            break
         }
      }
   }
   
   /**
   Deletes all tokens from view
   */
   func forceDeleteAllTokens() {
      tokens.removeAll(keepingCapacity: false)
      for token in tokens {
         removeToken(token, removingAll: true)
      }
      updateLayout()
   }
   
   /**
   Deletes token from view
   
   - parameter token:       KSToken object
   - parameter removingAll: A boolean to describe if removingAll tokens
   */
   func removeToken(_ token: KSToken, removingAll: Bool = false) {
      if token.isEqual(selectedToken) {
         deselectSelectedToken()
      }
      token.removeFromSuperview()
      
      let index = tokens.index(of: token)
      if (index != nil) {
         tokens.remove(at: index!)
      }
      if (!removingAll) {
         updateLayout()
      }
   }
   
   
   //MARK: - Layout
   /*
   **************************** Layout ****************************
   */
   
   /**
   Untokenzies the layout
   */
   func untokenize() {
      if (!_removesTokensOnEndEditing) {
         return
      }
      _state = .closed
      for subview in _scrollView.subviews {
         if subview is KSToken {
            subview.removeFromSuperview()
         }
      }
      updateLayout()
   }
   
   /**
   Tokenizes the layout
   */
   func tokenize() {
      _state = .opened
      for token: KSToken in tokens {
         _insertToken(token, shouldLayout: false)
      }
      updateLayout()
   }
   
   /**
   Updates the tokenView layout and calls delegate methods
   */
   func updateLayout(_ shouldUpdateText: Bool = true) {
      if (parentView == nil) {
         return
      }
      _caretPoint = _layoutTokens()
      deselectSelectedToken()
      
      if (shouldUpdateText) {
         _updateText()
      }
      
      if _caretPoint != .zero {
         let tokensMaxY = _caretPoint!.y
         
         if (frame.size.height != tokensMaxY) {
            tokenFieldDelegate?.tokenFieldShouldChangeHeight(tokensMaxY)
         }
      }
   }
   
   /**
   Layout tokens
   
   - returns: CGPoint maximum position values
   */
   fileprivate func _layoutTokens() -> CGPoint {
      if (_selfFrame == nil) {
         return .zero
      }
      if (_state == .closed) {
         return CGPoint(x: _marginX!, y: _selfFrame!.size.height)
      }
      
      if (_direction == .horizontal) {
         return _layoutTokensHorizontally()
      }
      
      var lineNumber = 1
      let leftMargin = _leftViewRect().width
      let rightMargin = _rightViewRect().width
      let tokenHeight = _font!.lineHeight + _paddingY!;
      
      var tokenPosition = CGPoint(x: _marginX!*2, y: _marginY!)
      
      for token: KSToken in tokens {
         let width = KSUtils.getRect(token.title as NSString, width: bounds.size.width, font: _font!).size.width + ceil(_paddingX!*2+1)
         let tokenWidth = min(width, token.maxWidth)
         
         // Add token at specific position
         if ((token.superview) != nil) {
            if (tokenPosition.x + tokenWidth + _marginX! + leftMargin > bounds.size.width - rightMargin) {
               lineNumber += 1;
               tokenPosition.x = _marginX!
               tokenPosition.y += (tokenHeight + _marginY!);
            }
            
            token.frame = CGRect(x: tokenPosition.x, y: tokenPosition.y, width: tokenWidth, height: tokenHeight)
            tokenPosition.x += tokenWidth + _marginX!;
         }
      }
      
      // check if next token can be added in same line or new line
      if ((bounds.size.width) - (tokenPosition.x + _marginX!) - leftMargin < _minWidthForInput) {
         lineNumber += 1;
         tokenPosition.x = _marginX!
         tokenPosition.y += (tokenHeight + _marginY!);
      }
      
      var positionY = (lineNumber == 1 && tokens.count == 0) ? _selfFrame!.size.height: (tokenPosition.y + tokenHeight + _marginY!)
      _scrollView.contentSize = CGSize(width: _scrollView.frame.width, height: positionY)
      if (positionY > maximumHeight) {
         positionY = maximumHeight
      }
      
      _scrollView.frame.size = CGSize(width: _scrollView.frame.width, height: positionY)
      scrollViewScrollToEnd()
      
      return CGPoint(x: tokenPosition.x + leftMargin, y: positionY)
   }
   
   
   /**
   Layout tokens horizontally
   
   - returns: CGPoint maximum position values
   */
   fileprivate func _layoutTokensHorizontally() -> CGPoint {
      let leftMargin = _leftViewRect().width
      let tokenHeight = _font!.lineHeight + _paddingY!;
      
      var tokenPosition = CGPoint(x: _marginX!, y: _marginY!)
      
      for token: KSToken in tokens {
         let width = KSUtils.getRect(token.title as NSString, width: bounds.size.width, font: _font!).size.width + ceil(_paddingX!*2+1)
         let tokenWidth = min(width, token.maxWidth)
         
         if ((token.superview) != nil) {
            token.frame = CGRect(x: tokenPosition.x, y: tokenPosition.y, width: tokenWidth, height: tokenHeight)
            tokenPosition.x += tokenWidth + _marginX!;
         }
      }
      
      let offsetWidth = ((tokenPosition.x + _marginX! + _leftViewRect().width) > (frame.width - _minWidthForInput)) ? _minWidthForInput : 0
      _scrollView.contentSize = CGSize(width: max(_scrollView.frame.width, tokenPosition.x + offsetWidth), height: frame.height)
      scrollViewScrollToEnd()
      
      return CGPoint(x: min(tokenPosition.x + leftMargin, frame.width - _minWidthForInput), y: frame.height)
   }
   
   /**
   Scroll the tokens to end
   */
   func scrollViewScrollToEnd() {
      var bottomOffset: CGPoint
      switch _direction {
      case .vertical:
         bottomOffset = CGPoint(x: 0, y: _scrollView.contentSize.height - _scrollView.bounds.height)
      case .horizontal:
         bottomOffset = CGPoint(x: _scrollView.contentSize.width - _scrollView.bounds.width, y: 0)
      }
      _scrollView.setContentOffset(bottomOffset, animated: true)
   }
   
   //MARK: - Text Rect
   /*
   **************************** Text Rect ****************************
   */
   
   fileprivate func _textRectWithBounds(_ bounds: CGRect) -> CGRect {
      if (!_setupCompleted) {return .zero}
      if (tokens.count == 0 || _caretPoint == nil) {
         return CGRect(x: _leftViewRect().width + _marginX!, y: (bounds.size.height - font!.lineHeight)*0.5, width: bounds.size.width-5, height: bounds.size.height)
      }
      
      if (tokens.count != 0 && _state == .closed) {
         return CGRect(x: _leftViewRect().maxX + _marginX!, y: (_caretPoint!.y - font!.lineHeight - (_marginY!)), width: (frame.size.width - _caretPoint!.x - _marginX!), height: bounds.size.height)
      }
      return CGRect(x: _caretPoint!.x, y: (_caretPoint!.y - font!.lineHeight - (_marginY!)), width: (frame.size.width - _caretPoint!.x - _marginX!), height: bounds.size.height)
   }
   
   override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
      return CGRect(x: _marginX!, y: (_selfFrame != nil) ? (_selfFrame!.height - _leftViewRect().height)*0.5: (bounds.height - _leftViewRect().height)*0.5, width: _leftViewRect().width, height: _leftViewRect().height)
   }
   
   override func textRect(forBounds bounds: CGRect) -> CGRect {
      return _textRectWithBounds(bounds)
   }
   
   override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return _textRectWithBounds(bounds)
   }
   
   override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return _textRectWithBounds(bounds)
   }
   
   fileprivate func _leftViewRect() -> CGRect {
      if (leftViewMode == .never ||
         (leftViewMode == .unlessEditing && isEditing) ||
         (leftViewMode == .whileEditing && !isEditing)) {
            return .zero
      }
      return leftView!.bounds
   }
   
   fileprivate func _rightViewRect() -> CGRect {
      if (rightViewMode == .never ||
         rightViewMode == .unlessEditing && isEditing ||
         rightViewMode == .whileEditing && !isEditing) {
            return .zero
      }
      return rightView!.bounds
   }
   
   fileprivate func _setPromptText(_ text: String?) {
      if (text != nil) {
         var label = leftView
         if !(label is UILabel) {
            label = UILabel(frame: .zero)
            label?.frame.origin.x += _marginX!
            (label as! UILabel).textColor = promptTextColor
            leftViewMode = .always
         }
         
         (label as! UILabel).text = text
         (label as! UILabel).font = font
         (label as! UILabel).sizeToFit()
         leftView = label
         
      } else {
         leftView = nil
      }
      _setScrollRect()
   }
   
   
   //MARK: - Placeholder
   /*
   **************************** Placeholder ****************************
   */
   
   fileprivate func _updateText() {
      if (!_setupCompleted) {return}
      _initPlaceholderLabel()
      
      switch(_state) {
      case .opened:
         text = KSTextEmpty
         break
         
      case .closed:
         if tokens.count == 0 {
            text = KSTextEmpty
            
         } else {
            var title = KSTextEmpty
            for token: KSToken in tokens {
               title += "\(token.title)\(_separatorText!)"
            }
            
            if (title.characters.count > 0) {
               title = title.substring(with: (title.characters.index(title.startIndex, offsetBy: 0) ..< title.characters.index(title.endIndex, offsetBy: -_separatorText!.characters.count)))
            }
            
            let width = KSUtils.widthOfString(title, font: font!)
            if width + _leftViewRect().width > bounds.width {
               text = "\(tokens.count) \(_descriptionText)"
            } else {
               text = title
            }
         }
         break
      }
      _updatePlaceHolderVisibility()
   }
   
   fileprivate func _updatePlaceHolderVisibility() {
      if tokens.count == 0 && (text == KSTextEmpty || text!.isEmpty) {
         _placeholderLabel?.text = _placeholderValue!
         _placeholderLabel?.isHidden = false
         
      } else {
         _placeholderLabel?.isHidden = true
      }
   }
   
   fileprivate func _initPlaceholderLabel() {
      let xPos = _marginX!
      if (_placeholderLabel == nil) {
         _placeholderLabel = UILabel(frame: CGRect(x: xPos, y: 0, width: _selfFrame!.width - xPos - _leftViewRect().size.width, height: 30))
         _placeholderLabel?.textColor = placeHolderColor
         _scrollView.addSubview(_placeholderLabel!)
         
      } else {
         _placeholderLabel?.frame.origin.x = xPos
      }
   }
   
   
   //MARK: - Token Gestures
   //__________________________________________________________________________________
   //
   func isSelectedToken(_ token: KSToken) -> Bool {
      if token.isEqual(selectedToken) {
         return true
      }
      return false
   }
   
   
   func deselectSelectedToken() {
      selectedToken?.isSelected = false
      selectedToken = nil
   }
   
   func selectToken(_ token: KSToken) {
      if (token.sticky) {
         return
      }
      for token: KSToken in tokens {
         if isSelectedToken(token) {
            deselectSelectedToken()
            break
         }
      }
      
      token.isSelected = true
      selectedToken = token
      tokenFieldDelegate?.tokenFieldDidSelectToken?(token)
   }
   
   func tokenTouchDown(_ token: KSToken) {
      if (selectedToken != nil) {
         selectedToken?.isSelected = false
         selectedToken = nil
      }
   }
   
   func tokenTouchUpInside(_ token: KSToken) {
      selectToken(token)
   }
   
   override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
      if (touch.view == self) {
         deselectSelectedToken()
      }
      return super.beginTracking(touch, with: event)
   }
   
   func tokenFieldTextDidChange(_ textField: UITextField) {
      _updatePlaceHolderVisibility()
   }
   
   // MARK: - Other Methods
   
   func paddingX() -> CGFloat? {
      return _paddingX
   }
   
   func tokenFont() -> UIFont? {
      return _font
   }
   
   func objects() -> NSArray {
      let objects = NSMutableArray()
      for object: AnyObject in tokens {
         objects.add(object)
      }
      return objects
   }
   
   override func becomeFirstResponder() -> Bool {
      super.becomeFirstResponder()
      tokenFieldDelegate?.tokenFieldDidBeginEditing?(self)
      return true
   }
   
   override func resignFirstResponder() -> Bool {
      tokenFieldDelegate?.tokenFieldDidEndEditing?(self)
      return super.resignFirstResponder()
   }
   
}


//MARK: - UIScrollViewDelegate
//__________________________________________________________________________________
//
extension KSTokenField : UIScrollViewDelegate {
   func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      _scrollPoint = scrollView.contentOffset
   }
   
   func scrollViewDidScroll(_ aScrollView: UIScrollView) {
      text = KSTextEmpty
      updateCaretVisiblity(aScrollView)
   }
   
   func updateCaretVisiblity(_ aScrollView: UIScrollView) {
      let scrollViewHeight = aScrollView.frame.size.height;
      let scrollContentSizeHeight = aScrollView.contentSize.height;
      let scrollOffset = aScrollView.contentOffset.y;
      
      if (scrollOffset + scrollViewHeight < scrollContentSizeHeight - 10) {
         hideCaret()
         
      } else if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight - 10) {
         showCaret()
      }
   }
   
   func hideCaret() {
      tintColor = UIColor.clear
   }
   
   func showCaret() {
      tintColor = _cursorColor
   }
}
