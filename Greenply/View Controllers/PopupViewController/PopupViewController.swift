//
//  PopupViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
@objc protocol PopupEditProject {
    @objc optional func didTapSubmit(_ isTap: Bool)
    
}
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class PopupViewController: BaseViewController {
    
    @IBOutlet weak var viewMainBG: UIView!
   
    @IBOutlet weak var nsContSelectType: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var buttonSelectType: UIButton!
    var imageEditID: Int?
    var deleagteEditImage: PopupEditProject?
    var arrStypeType: [AnyObject]?
    var data: [AnyObject]?
    @IBOutlet weak var textViewDescription: JAPlaceholderTextView!
    
    @IBOutlet weak var buttonSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UISetup()
        // Do any additional setup after loading the view.
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
    
    func UISetup()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PopupViewController.tapDismissPopUp))
        self.viewMainBG.addGestureRecognizer(tapGesture)
        buttonSelectType.layer.cornerRadius = 5.0;
        buttonSelectType.layer.borderWidth = 0.8;
        buttonSelectType.layer.borderColor = UIBorderColor().cgColor
        
        // buttonSelectType.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(buttonSelectType.frame), 0, 0)
        
        // buttonSelectType.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
        textViewDescription.layer.cornerRadius = 5.0;
        textViewDescription.layer.borderWidth = 0.8;
        textViewDescription.layer.borderColor = UIBorderColor().cgColor
        viewBG.layer.cornerRadius = 7.0
        
        let imageSize: CGSize = buttonSelectType.imageView!.frame.size;
        let width =  IS_IPAD() ? buttonSelectType.frame.width : 248
        buttonSelectType.titleEdgeInsets = UIEdgeInsetsMake(0, IS_IPAD() ? -40 : -10, 0, 40)
        buttonSelectType.imageEdgeInsets = UIEdgeInsetsMake(0, width - imageSize.width - 5, 0,0)
    }
    
    internal class func showAddOrClearPopUp(_ sourceViewController: UIViewController, Title: String, showRoomButtonType: Bool, arrData: [AnyObject]?, imageID: Int?) {
        
        let viewController = otherStoryboard.instantiateViewController(withIdentifier: String(describing: PopupViewController.self)) as! PopupViewController
       
        viewController.presentAddOrClearPopUpWith(sourceViewController, Title: Title, showRoomButtonType: showRoomButtonType,arrData:arrData, imageValue: imageID!)
    }
    
    func presentAddOrClearPopUpWith(_ sourceController: UIViewController , Title: String, showRoomButtonType: Bool, arrData: [AnyObject]?, imageValue: Int?) {
       
        self.arrStypeType = arrData
        self.view.frame = sourceController.view.bounds
        labelTitle.text = Title
        self.imageEditID = imageValue
        //buttonSelectType.translatesAutoresizingMaskIntoConstraints = true
        if showRoomButtonType == true{
        nsContSelectType.constant = 45.0
    
        }
        else{
        nsContSelectType.constant = 0.0
       // buttonSelectType.hidden = true
        }
        
        buttonSelectType.setNeedsUpdateConstraints();
        buttonSelectType.setNeedsLayout();
       buttonSelectType.layoutIfNeeded()
      
        sourceController.view.addSubview(self.view)
        sourceController.addChildViewController(self)
        sourceController.view.bringSubview(toFront: self.view)
        presentAnimationToView()
        
    }
    
    // MARK: - Animation
    func presentAnimationToView() {
        viewMainBG.alpha = 0.0
        self.viewBG.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25, animations: {
            self.viewMainBG.alpha = 0.5
            self.viewBG.transform = CGAffineTransform.identity
        }) 
    }
    
    func dismissAnimate() {
//        if didRemove != nil {
//            didRemove!()
//        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewMainBG.alpha = 0.0
            self.viewBG.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }, completion: { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }) 
    }
    func tapDismissPopUp(){
        self.dismissAnimate()
    }
    
    func keyboardWillShow(_ notification: Foundation.Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewBG.transform = IS_IPAD() ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: -(keyboardSize.height / 2))
            }) 
        }
    }
    
    func keyboardWillHide(_ notification: Foundation.Notification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.transform = CGAffineTransform.identity
        }) 
    }
    
    @IBAction func actionSelectType(_ sender: UIButton) {
        self.view.endEditing(true)
        var arrValue = [String]()
        for value in self.arrStypeType! {
        
            let styleName = value["name"] as! String
            let styleTypeId = value["id"] as! String
            let stypeData = "\(styleName)+\(styleTypeId)"
            arrValue.append(stypeData)
        }
        GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrValue, position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
            
            let strValue = value as! String
        
           // self.data =  strValue.components(separatedBy: String(+))
         //self.data = (value as! String).components(separatedBy: "+")
            self.buttonSelectType.setTitle(self.data![0] as? String, for: UIControlState())
            print("Value\(value)")
        }
        
        
    }
    @IBAction func actionSave(_ sender: AnyObject) {
        
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
        self.dismissAnimate()
        // Call Api
        
        self.editImageApi()
    }
    // mark-  ValidateFields
    func ValidateFields() -> Bool
    {
        self.view.endEditing(true)
        let result = true
        if !(self.data?.count > 0){
            Toast.show(withMessage: SELECT_STYLE_TYPE)
            return false
        }
        else if self.textViewDescription.text == "" {
            Toast.show(withMessage: ENTER_DESCRIPTION)
            return false
        }
        
        return result
    }
 
}
// Api Calling
extension PopupViewController{
 // api calling
    
    func editImageApi(){
        APIHandler.handler.editProjectImage(self.imageEditID!, attribute_value_id: self.data![1] as? String, description: self.textViewDescription.text, success: { (response) in
            print("Response Edit Image\(response)")
        }) { (error) in
            
        }
    }

}
