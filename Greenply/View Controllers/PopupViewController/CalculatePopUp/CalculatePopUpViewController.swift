//
//  CalculatePopUpViewController.swift
//  Greenply
//
//  Created by Jitendra on 4/17/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class CalculatePopUpViewController: BaseViewController {

    @IBOutlet weak var viewBGTotalLable: UIView!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var lblAdhensiveCost: UILabel!
    @IBOutlet weak var lblFurnitureCost: UILabel!
    @IBOutlet weak var lblLobourCost: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var btnOk: UIButton!
    var didSubmitButton:((_ text: String, _ popUp: CalculatePopUpViewController?) -> ())?

     var didRemove:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBGTotalLable.layer.cornerRadius = 6.0
        viewBGTotalLable.layer.borderWidth = 1.0
        viewBGTotalLable.layer.borderColor = UIColor.green.cgColor
          NavigationHelper.helper.enableSideMenuSwipe = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CalculatePopUpViewController.tapDismissPopUp))
        self.viewBG.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionTapOk(_ sender: UIButton) {
    self.dismissAnimate()
    }
   
    internal class func showAddOrClearPopUp(_ sourceViewController: UIViewController, pDictValue:[String: AnyObject], didFinish: @escaping (() -> ())) {
        
        let calculatePopVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: CalculatePopUpViewController.self)) as! CalculatePopUpViewController
     //   calculatePopVC.didSubmitButton = didSubmi

        NavigationHelper.helper.enableSideMenuSwipe = false
        calculatePopVC.didRemove = didFinish
        calculatePopVC.presentAddOrClearPopUpWith(sourceViewController)
        let furnitureCost = (pDictValue["value"] as! Int) - ((pDictValue["adhesive"] as! Int) + (pDictValue["labour"] as! Int))
        
        calculatePopVC.lblFurnitureCost.text = "\u{20B9} \(String(furnitureCost))"
        calculatePopVC.lblAdhensiveCost.text = "\u{20B9} \(String(pDictValue["adhesive"] as! Int))"
        calculatePopVC.lblLobourCost.text = "\u{20B9} \(String(pDictValue["labour"] as! Int))"
        let totalAmout = String((furnitureCost) + (pDictValue["labour"] as! Int) + (pDictValue["adhesive"] as! Int))
        let rupee = "\u{20B9} \(totalAmout)"
        calculatePopVC.lblTotalValue.text = rupee
        
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
       // self.viewBG.backgroundColor = UIColor.clearColor()().colorWithAlphaComponent(0.5)
        self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25, animations: {
            
           // [parentView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
           // self.viewBG.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
           self.viewBG.alpha = 0.5
            self.viewPopUp.transform = CGAffineTransform.identity
        }) 
    }
}


// MARk: User Define Function
extension CalculatePopUpViewController {
    
    func dismissAnimate() {
         // NavigationHelper.helper.enableSideMenuSwipe = true
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
        self.dismissAnimate()
        }
    

}
