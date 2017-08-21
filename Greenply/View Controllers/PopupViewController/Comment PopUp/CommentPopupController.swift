//
//  CommentPopupController.swift
//  Greenply
//
//  Created by Jitendra on 9/20/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class CommentPopupController: BaseViewController {
 @IBOutlet weak var viewBG: UIView!
 @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textViewComment: JAPlaceholderTextView!
    
    var didSubmitButton:((_ text: String, _ popUp: CommentPopupController?) -> ())?
    var didRemove:(() -> ())?
    
    @IBOutlet weak var textViewDescription: JAPlaceholderTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommentPopupController.tapDismissPopUp))
        self.viewBG.addGestureRecognizer(tapGesture)
        textViewDescription.layer.cornerRadius = 6.0
        textViewDescription.layer.borderWidth = 1.0
        textViewDescription.layer.borderColor = UIBorderColor().cgColor
        buttonSubmit.addTarget(self, action: #selector(CommentPopupController.buttonComments(_:)), for: UIControlEvents.touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentPopupController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(CommentPopupController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonComments(_ sender: UIButton) {
        self.view.endEditing(true)
        if textViewComment.text!.isBlank{
        Toast.show(withMessage: ENTER_COMMENT)
        }
        else{
            if didSubmitButton != nil {
            didSubmitButton!(textViewComment.text, self)
            }
        }
    }

    internal class func showAddOrClearPopUp(_ sourceViewController: UIViewController, didSubmit: @escaping ((_ text: String, _ popUp: CommentPopupController?) -> ()), didFinish: @escaping (() -> ())) {
        
        let commentPopVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: CommentPopupController.self)) as! CommentPopupController
        commentPopVC.didSubmitButton = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceViewController)
    }
    
     func presentAddOrClearPopUpWith(_ sourceController: UIViewController) {
     self.view.frame = sourceController.view.bounds
        sourceController.view.addSubview(self.view)
        sourceController.addChildViewController(self)
        sourceController.view.bringSubview(toFront: self.view)
        presentAnimationToView()
    }
    
    // MARK: - Animation
    func presentAnimationToView() {
        viewBG.alpha = 0.0
        self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0.5
            self.viewPopUp.transform = CGAffineTransform.identity
        }) 
    }
    
    func dismissAnimate() {
        
        if didRemove != nil {
            didRemove!()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0.0
            self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }, completion: { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }) 
    }
    
    func tapDismissPopUp(){
        if textViewComment.isFirstResponder {
            self.view.endEditing(true)
        } else {
            self.dismissAnimate()
        }
    }
    
    func keyboardWillShow(_ notification: Foundation.Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewPopUp.transform = IS_IPAD() ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: -(keyboardSize.height / 2))
            }) 
        }
    }
    
    func keyboardWillHide(_ notification: Foundation.Notification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewPopUp.transform = CGAffineTransform.identity
        }) 
    }
}
