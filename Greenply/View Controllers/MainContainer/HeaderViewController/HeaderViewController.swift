//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/9/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
@objc protocol HeaderButtonDeleagte {
    @objc optional func didTapMenuButton(_ strButtonType: String)
}
import UIKit

class HeaderViewController: UIViewController {
    
    @IBOutlet weak var buttonSearch: UIButton!
    

    @IBOutlet weak var btnFiltter: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var nsConstBackBtnWidth: NSLayoutConstraint!
    var isHideSearchButton: Bool = true
    
    @IBOutlet weak var nsConstSechLeading: NSLayoutConstraint!
    @IBOutlet weak var nsConstNotiLeading: NSLayoutConstraint!
    @IBOutlet weak var nsContFilterLeding: NSLayoutConstraint!
    
    @IBOutlet weak var nsConstLblLeading: NSLayoutConstraint!

    @IBOutlet weak var nsConstFilterWidth: NSLayoutConstraint!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var leadingImgBorder: NSLayoutConstraint!
    @IBOutlet weak var imgBorder: UIImageView!
    @IBOutlet weak var lblNotification: UILabel!
    
    var strButtonType: String = ""
    var delegateButton: HeaderButtonDeleagte?
    override func viewDidLoad() {
        super.viewDidLoad()
   
        leadingImgBorder.constant = 0.0//imgBorder.frame.size.width
        NavigationHelper.helper.headerViewController = self
        textSearch.attributedPlaceholder = NSAttributedString(string: "Search",
                                                              attributes: [NSForegroundColorAttributeName: UIColor.white])
        // MARK:- Action
        buttonMenu.addTarget(self, action: #selector(self.didSelectMenuAction(_:)), for: .touchUpInside)
        buttonBack.addTarget(self, action: #selector(self.didBackAction(_:)), for: .touchUpInside)
        buttonNotification.addTarget(self, action: #selector(self.didNotificationAction(_:)), for: .touchUpInside)
        btnFiltter.addTarget(self, action: #selector(self.didFilterAction(_:)), for: .touchUpInside)
        buttonSearch.addTarget(self, action: #selector(self.didTapSearch(_:)), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        labelHeaderTitle.font = labelHeaderTitle.font.withSize(IS_IPAD() ? 26 : 18)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonSearch.isHidden = true
        labelHeaderTitle.alpha = 1.0
        textSearch.isHidden = true
        
    }
    
    func hideUnhideSearch() {
        self.textSearch.text = ""
        self.labelHeaderTitle.alpha = 1.0
        self.textSearch.isHidden = true
        
    }
    func didTapSearch(_ sender: UIButton) {
        
        if sender.isSelected {
            btnFiltter.isUserInteractionEnabled = true
            imgBorder.alpha = 1.0
            textSearch.resignFirstResponder()
            leadingImgBorder.constant = 0.0 // imgBorder.frame.size.width
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) in
                    self.labelHeaderTitle.alpha = 1.0
                    self.textSearch.isHidden = true
            })
            sender.isSelected = false
        } else {
            btnFiltter.isUserInteractionEnabled = false
            imgBorder.alpha = 1.0
            leadingImgBorder.constant = SCREEN_WIDTH  -  self.nsConstSechLeading.constant - (IS_IPAD() ? 220 : 180) //textSearch.frame.size.width
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                //self.leadingImgBorder.constant = 0.0
                
                }, completion: { (finished: Bool) in
                    self.labelHeaderTitle.alpha = 0
                    self.textSearch.isHidden = false
            })
            sender.isSelected = true
        }
    }
    
    func didSelectMenuAction(_ sender: UIButton)
    {
       
        if strButtonType == kPluseButton {
            self.delegateButton?.didTapMenuButton!(kPluseButton)
        } else if strButtonType == KHeaderTickButton {
            self.delegateButton?.didTapMenuButton!(KHeaderTickButton)
        }
        else {
            NavigationHelper.helper.openSidePanel(!NavigationHelper.helper.isOpen)
        }
        
    }
    
    func didBackAction(_ sender: UIButton)
    {
        CDSpinner.hide()
        self.hideUnhideSearch()
        NavigationHelper.helper.openSidePanel(false)
        NavigationHelper.helper.contentNavController!.popViewController(animated: true)
        
    }
    func didNotificationAction(_ sender: UIButton)
    {
        NavigationHelper.helper.openSidePanel(false)
        debugPrint("controller \(NavigationHelper.helper.contentNavController!.viewControllers.last)")
        let notificationVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: NotificationViewController.self)) as! NotificationViewController
        // NavigationHelper.helper.currentViewController = notificationVC
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.contentNavController!.pushViewController(notificationVC, animated: true)
        
    }
    
    func didFilterAction(_ sender: UIButton) {
//        NavigationHelper.helper.openSidePanel(false)
//        MultiSelectionViewController.showMultipleSelectionView(self)
        
    }
    
    // MARK:- chnage button Image
    func addHeaderButton(_ addButtonName: String)
    {
        var image = UIImage()
        if addButtonName == kPluseButton {
            NavigationHelper.helper.enableSideMenuSwipe = false
            image = UIImage(named: kPluseImage)!
            buttonMenu.setImage(image, for: UIControlState())
            strButtonType = kPluseButton
        }
        else if addButtonName == KHeaderTickButton {
            NavigationHelper.helper.enableSideMenuSwipe = false
            image = UIImage(named: kHeaderTickImage)!
            buttonMenu.setImage(image, for: UIControlState())
            strButtonType = KHeaderTickButton
        } else {
            NavigationHelper.helper.enableSideMenuSwipe = true
            image = UIImage(named: kMenuImage)!
            buttonMenu.setImage(image, for: UIControlState())
            strButtonType = kPluseButton
            strButtonType = KMenuButton
        }
        
    }
    
    //    // MARK:- add plus button.
    func addPlusButton() {
        
        var imageBtn = UIImage()
        imageBtn = UIImage(named: "MenuIcon.png")!
        buttonMenu.setImage(imageBtn, for: UIControlState())
        NavigationHelper.helper.enableSideMenuSwipe = true
        // }
    }
    // MARK:- Add Search And Filter Button.
    func addSearchAndFiltterButton() {
        if NavigationHelper.helper.contentNavController!.viewControllers.containsObject(IdeaListingController).isPresent || NavigationHelper.helper.contentNavController!.viewControllers.containsObject(MeetAnExpertViewController).isPresent {
            btnFiltter.isUserInteractionEnabled = true
            btnFiltter.setImage(UIImage(named: "FilterIcon.png"), for: UIControlState())
        }
        else {
            btnFiltter.setImage(UIImage(named: "SearchIcone.png"), for: UIControlState())
        }
        
    }
    
    // MARK:- Set Header Bar Buttons Function
    func setHeaderBarButtonsWith(isHideBackButton: Bool, isHideFilterButton: Bool, isHidenotification: Bool, isHideMenuButton: Bool) {
        strButtonType = ""
        labelHeaderTitle.alpha = 1.0
        textSearch.isHidden = true
        self.addPlusButton()
        
        
        
        self.setHeaderBarButtonsWithIdeas(isHideBackButton: isHideBackButton, isHideFilterButton: isHideFilterButton, isHidenotification: isHidenotification, isHideMenuButton: isHideMenuButton, isHideSearchButton: self.isHideSearchButton)
    }
    
    // MARK:- Set Header Bar Button for Normal Controller
    
    func setHeaderBarButtonsWithIdeas(isHideBackButton: Bool, isHideFilterButton: Bool, isHidenotification: Bool, isHideMenuButton: Bool, isHideSearchButton: Bool) {
           strButtonType = ""
          self.addPlusButton()
        self.addSearchAndFiltterButton()
        //buttonSearch.hidden = true
        
        // New Code..
        
        // MARK:- Working on Header back button
        if isHideBackButton == true {
            self.buttonBack.isHidden = true
            self.nsConstLblLeading.constant = 0.0
        }
        if isHideBackButton == false {
            self.buttonBack.isHidden = false
            self.nsConstLblLeading.constant = 30
        }
        
        // MArk:-  Working on menu
        
        if isHideMenuButton == true {
            buttonMenu.isHidden = true
        }
        if isHideMenuButton == false {
            buttonMenu.isHidden = false
        }
        // Mark:- working on notification
        
        
        
        if isHidenotification == true {
            if INTEGER_FOR_KEY(kUserID) != 0 {
                lblNotification.isHidden = true
                buttonNotification.isHidden = true
                self.nsConstNotiLeading.constant = IS_IPAD() ? 15 : -10
                
                if isHideFilterButton == true {
                    self.btnFiltter.isHidden = true
                    //self.nsContFilterLeding.constant = 5
                    
                    if isHideSearchButton == true{
                        self.buttonSearch.isHidden = true
                        
                    }
                    if isHideSearchButton == false{
                        self.buttonSearch.isHidden = false
                        
                        self.nsConstSechLeading.constant = IS_IPAD() ? -35 : -45
                        
                    }
                    
                    
                    
                    
                }
                if isHideFilterButton == false {
                    self.btnFiltter.isHidden =  false
                    self.nsContFilterLeding.constant = -42
                    
                    if isHideSearchButton == true{
                        self.buttonSearch.isHidden = true
                        
                    }
                    if isHideSearchButton == false{
                        self.buttonSearch.isHidden = false
                        
                        self.nsConstSechLeading.constant = IS_IPAD() ? 15 : -10
                    }
                    
                    
                    
                }
            }
            else {
                lblNotification.isHidden = true
                buttonNotification.isHidden = true
                
                if isHideFilterButton == true {
                    self.btnFiltter.isHidden = true
                    self.nsContFilterLeding.constant = 5
                    
                    if isHideSearchButton == true{
                        self.buttonSearch.isHidden = true
                    }
                    if isHideSearchButton == false{
                        self.buttonSearch.isHidden = false
                        
                        self.nsConstSechLeading.constant = IS_IPAD() ? -30 : -45
                    }
                    
                }
                if isHideFilterButton == false {
                    self.btnFiltter.isHidden = false
                    self.nsContFilterLeding.constant = IS_IPAD() ? -30 : -42
                    
                    
                    if isHideSearchButton == true{
                        self.buttonSearch.isHidden = true
                    }
                    if isHideSearchButton == false{
                        self.buttonSearch.isHidden = false
                        self.nsConstSechLeading.constant = IS_IPAD() ? -30 : -45
                        
                    }
                }
            }
        }
        
        
        
        if isHidenotification == false {
            if INTEGER_FOR_KEY(kUserID) != 0 {
                lblNotification.isHidden = false
                buttonNotification.isHidden = false
                
                self.nsConstNotiLeading.constant =  0.0
                
                
                if isHideFilterButton == true {
                    self.btnFiltter.isHidden = true
                    //self.nsContFilterLeding.constant = 5
                    
                    if isHideSearchButton == true{
                        self.buttonSearch.isHidden = true
                        
                    }
                    if isHideSearchButton == false{
                        self.buttonSearch.isHidden = false
                        
                        self.nsConstSechLeading.constant = IS_IPAD() ? -40 : -35 // -50
                        
                    }
                    
                }
                if isHideFilterButton == false {
                    self.btnFiltter.isHidden = false
                    //self.nsContFilterLeding.constant = IS_IPAD() ? 15 : -10
                    
                    
                    if isHideSearchButton == true{
                        self.buttonSearch.isHidden = true
                    }
                    if isHideSearchButton == false{
                        self.buttonSearch.isHidden = false
                        self.nsConstSechLeading.constant = IS_IPAD() ? 0.0 :  0.0
                    }
                    
                }
                
                // Search Case
                
                
                
                
            }
            else {
                lblNotification.isHidden = true
                buttonNotification.isHidden = true
                
                if isHideFilterButton == true {
                    self.btnFiltter.isHidden = true
                    //self.nsContFilterLeding.constant = 5
                    
                    if isHideSearchButton == true{
                        self.buttonSearch.isHidden = true
                    }
                    if isHideSearchButton == false{
                        self.buttonSearch.isHidden = false
                        
                        self.nsConstNotiLeading.constant = IS_IPAD() ? -45 : -35
                        self.nsConstSechLeading.constant =  IS_IPAD() ? -45 : -40
                    }
                    
                    
                    
                    
                }
                if isHideFilterButton == false {
                    self.btnFiltter.isHidden = false
                    self.nsContFilterLeding.constant = 0.0
                    self.nsConstNotiLeading.constant = IS_IPAD() ? -45 : -35
                    if isHideSearchButton == true{
                        self.buttonSearch.isHidden = true
//                        self.nsConstSechLeading.constant =  IS_IPAD() ? -45 : -40
                    }
                    if isHideSearchButton == false{
                        self.buttonSearch.isHidden = false
                        self.nsConstSechLeading.constant = 0.0
                        
                    }
                    
                    
                    
                    
                }
            }
        }
        
  
        
    }
    
    }
