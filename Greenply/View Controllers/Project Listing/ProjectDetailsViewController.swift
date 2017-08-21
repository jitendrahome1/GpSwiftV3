//
//  ProjectDetailsViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 13/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: BaseViewController {

	var arrProjectDetailsImageList = [AnyObject]()
	var indexpath: IndexPath!
	@IBOutlet weak var collectionProjectDetails: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidLayoutSubviews() {
		collectionProjectDetails.scrollToItem(at: indexpath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
	}

	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = "Project Details (Portfolio)"
        setupCollectionView()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ProjectDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionProjectDetails.collectionViewLayout = layout
    }
    
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return arrProjectDetailsImageList.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProjectDetailsViewCollectionCell.self), for: indexPath) as! ProjectDetailsViewCollectionCell
        cell.actionLikeHandler = { (imageID,imageLikeStatus) in
      self.addPortfolioLike(forUserID: Globals.sharedClient.userID!, imageID: imageID, profileImage: cell.datasource as? ProfileImage)
        
        }
        cell.datasource = arrProjectDetailsImageList[indexPath.row]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionProjectDetails.frame.width, height: collectionProjectDetails.frame.height)
	}
}
// MARK: // Call API
extension ProjectDetailsViewController{
    func addPortfolioLike(forUserID userID:Int?, imageID:String?, profileImage: ProfileImage?){
        if profileImage?.porjectImageLikeStaus == false{
        APIHandler.handler.addPortfolioImageLike(forUserID: userID!, ImageID: imageID!, success: { (response) in
            let totalLikeCount = response?["likeCount"].intValue
            profileImage!.likeCount = String(describing: totalLikeCount)
            profileImage!.porjectImageLikeStaus = true
            debugPrint("portfolioLike Response==>\(response)")
            Toast.show(withMessage: LIKE_SUCCESSFULLY)
            self.collectionProjectDetails.reloadData()
            }, failure: { (error) in
                
        })
        }else{
            APIHandler.handler.portfolioImageDislike(forPortfolioImageID: Int(imageID!), success: { (response) in
                let totalLikeCount = response?["likeCount"].intValue
                profileImage?.likeCount = String(describing: totalLikeCount)
                profileImage?.porjectImageLikeStaus = false
                Toast.show(withMessage: DISLIKE_SUCCESSFULLY)
                    self.collectionProjectDetails.reloadData()
                },failure: { (error) in
                    
            })
       // Toast.show(withMessage: ALREDY_LIKED)
        }
    }
}
