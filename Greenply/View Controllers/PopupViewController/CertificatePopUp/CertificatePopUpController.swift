//
//  CertificatePopUpController.swift
//  Greenply
//
//  Created by Jitendra on 4/10/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class CertificatePopUpController: BaseViewController {

    @IBOutlet weak var imgCertificate: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    var imgNewSelected: UIImage?
    @IBOutlet weak var textAreaDesc: JAPlaceholderTextView!
    @IBOutlet weak var btnImgeSelect: UIButton!
    @IBOutlet weak var lblTtitle: UILabel!
    @IBOutlet weak var ContinerBG: UIView!
    var dictCertificateDetails: [String: AnyObject]?

    @IBOutlet weak var viewBG: UIView!
        var didRemove:(() -> ())?
    var didUpdateButton: ((_ forItems: [String:AnyObject]?,  _ popUp: CertificatePopUpController?) -> ())!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    @IBAction func actionButtonUpdate(_ sender: UIButton) {
        self.view.endEditing(true)
        if textAreaDesc.text!.isBlank{
            Toast.show(withMessage: ENTER_COMMENT)
        }
        else{
            if didUpdateButton != nil {
                let localDict = ["id":self.dictCertificateDetails!["id"]! ,"title": self.textAreaDesc.text as AnyObject, "certificate":self.imgCertificate.image!] 
              
                didUpdateButton!(localDict, self)
                
                self.dismissAnimate()
            }
        }
    
    }

    @IBAction func actionSelectImage(_ sender: UIButton) {
   GPImagePickerController.pickImage(onController: self, sourceRect: IS_IPAD() ? sender.frame : nil, didPick: { (image) in
    self.imgNewSelected = image
    self.imgCertificate.image = self.imgNewSelected
    }){
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uiSetup()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CertificatePopUpController.tapDismissPopUp))
        self.viewBG.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentPopupController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(CommentPopupController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        
    }
    
    func uiSetup(){
        self.imgCertificate.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        imgCertificate.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        imgCertificate.layer.borderColor = UIColor(red: 210.0 / 255.0, green: 210.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0).cgColor
        imgCertificate.layer.masksToBounds = true
        
        self.textAreaDesc.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        textAreaDesc.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        textAreaDesc.layer.borderColor = UIColor(red: 210.0 / 255.0, green: 210.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0).cgColor
        textAreaDesc.layer.masksToBounds = true
        self.addToolBar(self.textAreaDesc)
       
    }
    
    func addToolBar(_ textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
       // toolBar.barTintColor = UIColor.redColor()
        toolBar.barTintColor = UIColorRGB(57, g: 181, b: 74)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CertificatePopUpController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CertificatePopUpController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
      
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    
    // This Function Set the data in popup
    
    func setDetailsWith(forDictData dictData:[String: AnyObject]?){
        self.textAreaDesc.text = dictData!["title"] as? String
        
        let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
        backgroundQueue.async(execute: {
      
            self.imgCertificate.image = UIImage(named: "PlaceholderSquare")
        
            DispatchQueue.main.async(execute: {
                if dictData!["certificate"]!.isKind(of: UIImage.self){
                
                    
                    let imageURl = dictData!["certificate"] as! UIImage
                    
                    self.imgCertificate.image = imageURl
                    
                }
                    
                else{
                    let imageURl = dictData!["certificate"]!["medium"] as? String
                  self.imgCertificate.setImage(withURL: URL(string: imageURl!)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .crossDissolve(0.4))
                }
                
            })
            
        })
    }
}
// MARK:- User Define Function

extension CertificatePopUpController {
    // This Function show popup.
    internal class func showAddOrClearPopUp(_ sourceViewController: UIViewController,pDictItems: [String: AnyObject]?, didSubmit: @escaping ((_ forItems: [String:AnyObject]?, _ popUp: CertificatePopUpController?) -> ()), didFinish: @escaping (() -> ())) {
        debugPrint("items Details:\(pDictItems)")
        let certificatePopVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: CertificatePopUpController.self)) as! CertificatePopUpController
        certificatePopVC.didUpdateButton = didSubmit
        certificatePopVC.didRemove = didFinish

        certificatePopVC.presentAddOrClearPopUpWith(sourceViewController)
         certificatePopVC.dictCertificateDetails = pDictItems
            certificatePopVC.setDetailsWith(forDictData: pDictItems!)
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
       // viewBG.alpha = 0.0
        self.ContinerBG.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 1
            self.ContinerBG.transform = CGAffineTransform.identity
        }) 
    }
    
   // The Function Dismiss the pop
    func tapDismissPopUp(){
       self.view.endEditing(true)
         self.dismissAnimate()
    }
    func dismissAnimate() {
        
        if didRemove != nil {
            didRemove!()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0.0
            self.ContinerBG.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }, completion: { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }) 
    }
    
    // This Function heandal KeyBord
    func keyboardWillShow(_ notification: Foundation.Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25, animations: {
                self.ContinerBG.transform = IS_IPAD() ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: -(keyboardSize.height-60/2))
            }) 
        }
    }
    
    func keyboardWillHide(_ notification: Foundation.Notification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.ContinerBG.transform = CGAffineTransform.identity
        }) 
    }

}
