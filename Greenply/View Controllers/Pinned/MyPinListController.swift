//
//  MyPinListController.swift
//  Greenply
//
//  Created by Shatadru Datta on 21/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MyPinListController: BaseViewController {

    @IBOutlet weak var collectionViewPin: UICollectionView!
    var arrMyPinnedList = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MY_PINNED
        NavigationHelper.helper.tabBarViewController?.hideTabBar()
        super.viewWillAppear(animated)
        self.getPinList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MyPinListController: UICollectionViewDataSource, UICollectionViewDelegate {
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = IS_IPAD() ? 25.0 : 10.0
        collectionViewPin.collectionViewLayout = layout
    }
    
    // MARK: UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMyPinnedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MyPinListCollectionViewCell.self), for: indexPath) as! MyPinListCollectionViewCell
        cell.datasource = arrMyPinnedList[indexPath.row]
        cell.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        cell.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        cell.layer.borderColor = UIColorRGB(210.0, g: 210.0, b: 210.0)?.cgColor
        cell.layer.masksToBounds =  true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MyPinListCollectionViewCell
        let myPinDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MyPinnedDetailsController.self)) as! MyPinnedDetailsController
        let myPinDetailsObj = cell.datasource
        myPinDetailsVC.myPinDetailsObj = myPinDetailsObj as! MyPinList
        NavigationHelper.helper.contentNavController!.pushViewController(myPinDetailsVC, animated: true)
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)), height: (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)))
    }
}


extension MyPinListController {
    func getPinList() {
        arrMyPinnedList.removeAll()
        APIHandler.handler.getMyPinList({ (response) in
            debugPrint(response)
            if (response?["pins"].count)! > 0 {
                self.collectionViewPin.isHidden = false
                for value in (response?["pins"].arrayObject!)! {
                    let myPinListObj = MyPinList(withDictionary: value as! [String : AnyObject])
                    self.arrMyPinnedList.append(myPinListObj)
                }
                self.collectionViewPin.reloadData()
            } else {
                Toast.show(withMessage: NO_RECORDS_FOUND)
                self.collectionViewPin.isHidden = true
            }
            
            }) { (error) in
                debugPrint(error)
        }
    }
}


