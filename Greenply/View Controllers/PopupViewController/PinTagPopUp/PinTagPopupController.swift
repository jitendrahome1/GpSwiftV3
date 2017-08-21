//
//  PinTagPopupController.swift
//  Greenply
//
//  Created by Shatadru Datta on 10/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class PinTagPopupController: BaseViewController {

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tagViewDesc: KSTokenView!
    
    var list = [String]()
    var isSearch: Bool?
    var arrTagsResult = [AnyObject]()
    var arrAllTagsID = [AnyObject]()
    var arrSkils = [AnyObject]()
    
    var didSubmitButton:((_ text: String, _ popUp: PinTagPopupController?) -> ())?
    var didRemove:(() -> ())?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllSkillsList()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommentPopupController.tapDismissPopUp))
        self.viewBG.addGestureRecognizer(tapGesture)
        tagViewDesc.layer.cornerRadius = 6.0
        tagViewDesc.layer.borderWidth = 1.0
        tagViewDesc.layer.borderColor = UIBorderColor().cgColor
        buttonSubmit.addTarget(self, action: #selector(CommentPopupController.buttonComments(_:)), for: UIControlEvents.touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tagViewDesc.delegate = self
        tagViewDesc.searchResultSize = self.view.frame.size
        tagViewDesc.checkPinTag = true
        NotificationCenter.default.addObserver(self, selector: #selector(CommentPopupController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(CommentPopupController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func buttonComments(_ sender: UIButton) {
        self.view.endEditing(true)
        Toast.show(withMessage: ENTER_TAG)
    }
    
    internal class func showAddOrClearPopUp(_ sourceViewController: UIViewController, didSubmit: @escaping ((_ text: String, _ popUp: PinTagPopupController?) -> ()), didFinish: @escaping (() -> ())) {
        
        let pinTagPopVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: PinTagPopupController.self)) as! PinTagPopupController
        pinTagPopVC.didSubmitButton = didSubmit
        pinTagPopVC.didRemove = didFinish
        pinTagPopVC.presentAddOrClearPopUpWith(sourceViewController)
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
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }) 
    }
    
    func tapDismissPopUp(){
        self.dismissAnimate()
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


//MARK:- Api Call SkillList
extension PinTagPopupController {
    func getAllSkillsList() {
        APIHandler.handler.getSkillList({ (response) in
            
            self.arrTagsResult = response!["Skill"].arrayObject! as [AnyObject]
            if self.arrTagsResult.count > 0 {
                for value in (response?["Skill"].arrayObject!)! {
                    let objTags = SkillTags(withDictionary: value as! [String: AnyObject])
                    self.arrSkils.append(objTags)
                    self.list.append(objTags.skillName!)
                }
                debugPrint("AddIdeaTags ==>\(self.arrSkils)")
            }
        }) { (error) in
        }
    }
}




//MARK:- Token View
extension PinTagPopupController: KSTokenViewDelegate {
    func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        var data: Array<String> = []
        for value: String in list {
            if value.lowercased().range(of: string.lowercased()) != nil {
                data.append(value)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        let idea = (object as! String).components(separatedBy: "+")
        return idea[0]
    }
    
    func tokenView(_ tokenView: KSTokenView, didAddToken token: KSToken) {
        if isSearch == true {
            self.getTagsID(self.arrTagsResult, keySearch: String(describing: token))
            
        }
        isSearch = false
        
        debugPrint(token)
    }
    
    func tokenView(_ token: KSTokenView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.isSearch = true
        
    }
    
    func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
        self.removeTagsID(self.arrTagsResult, keySearch: String(describing: token))
        debugPrint(token)
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldChangeAppearanceForToken token: KSToken) -> KSToken? {
        self.arrAllTagsID.append(token)
        return token
    }
    
    func getTagsID(_ pArry: [AnyObject], keySearch: String)
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        let dict = filteredArray.first
        
        if let dictFilter = dict {
            if let _ = dict!["id"] {
                self.arrAllTagsID.append(dictFilter["id"] as! Int as AnyObject)
            }
        }
    }
    
    
    // Remove Tags
    func removeTagsID(_ pArry: [AnyObject], keySearch: String)
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        let dict = filteredArray.first
        
        if let dictFilter = dict {
            if let _ = dict!["id"] {
                let index = dictFilter["id"] as! Int
                self.arrAllTagsID.removeObject(index)
            }
        }
    }
}




