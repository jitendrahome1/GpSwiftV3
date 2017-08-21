//
//  InfluencerCallPopUpViewController.swift
//  Greenply
//
//  Created by Jitendra on 5/4/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class InfluencerCallPopUpViewController: BaseViewController {

    @IBOutlet weak var viewMainBG: UIView!
    
    @IBOutlet weak var viewPopUpBG: UIView!
    
    @IBOutlet weak var lblPhoneNo: UILabel!
    
    @IBOutlet weak var lblExtenstionNo: UILabel!
    
    @IBOutlet weak var btnCall: UIButton!
        var didRemove:(() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.enableSideMenuSwipe = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CalculatePopUpViewController.tapDismissPopUp))
        self.viewMainBG.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionCall(_ sender: UIButton) {
      
        Toast.show(withMessage: CALL_FEATURE)
        self.dismissAnimate()
    }
    internal class func showAddOrClearPopUp(_ sourceViewController: UIViewController, pDictValue:[String: AnyObject], didFinish: @escaping (() -> ())) {
        let influncerCallPopUp = otherStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerCallPopUpViewController.self)) as! InfluencerCallPopUpViewController
        //   calculatePopVC.didSubmitButton = didSubmi
        
        NavigationHelper.helper.enableSideMenuSwipe = false
        influncerCallPopUp.didRemove = didFinish
        influncerCallPopUp.presentAddOrClearPopUpWith(sourceViewController)
        influncerCallPopUp.lblExtenstionNo.text = pDictValue["value"] as? String
    
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
        viewMainBG.alpha = 0.0
        self.viewPopUpBG.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25, animations: {
            self.viewMainBG.alpha = 0.5
            self.viewPopUpBG.transform = CGAffineTransform.identity
        }) 
        
}

}
// MARk: User Define Function
extension InfluencerCallPopUpViewController {
    
    func dismissAnimate() {
        // NavigationHelper.helper.enableSideMenuSwipe = true
        if didRemove != nil {
            didRemove!()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewMainBG.alpha = 0.0
            self.viewPopUpBG.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }, completion: { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }) 
    }
    
    func tapDismissPopUp(){
        self.dismissAnimate()
    }
    
    
}

