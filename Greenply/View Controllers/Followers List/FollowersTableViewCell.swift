//
//  FollowersTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 31/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

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


class FollowersTableViewCell: BaseTableViewCell {

    let ImageLimt: Int = 4
	@IBOutlet weak var labelIdea: UILabel!
	@IBOutlet weak var labelDesignerType: UILabel!
	@IBOutlet weak var viewFollowers: UIView!
	@IBOutlet weak var imageFollowers: UIImageView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var buttonUnfollow: UIButton!
	@IBOutlet weak var buttonLikes: UIButton!
    var arrFollwingIdeaList = [AnyObject]()
	var totalRowCount: Int?
	var restImageCount: Int?
	@IBOutlet weak var collectionViewFollowers: UICollectionView!
	var arrIdeasImage = [AnyObject]()
	var actionUnfollowHandler: ((_ followerID: Int) -> ())?

	override var datasource: AnyObject? {
		didSet {
			if let name = ((datasource!["User"] as AnyObject)["name"] as AnyObject) as? String {
				labelName.text = name
			}
            arrFollwingIdeaList.removeAll()
			self.arrIdeasImage.removeAll()
        
            if let arrIdea = datasource!["Idea"] as? [AnyObject] {
                
                
           
            
                for value in arrIdea {
                    let idesListObj = IdeaListing(withDictionary: value as! [String : AnyObject])
                   self.arrFollwingIdeaList.append(idesListObj)
                }
                
                
                for dictImageList in arrIdea {
					let dict: [String: AnyObject] = dictImageList as! [String: AnyObject]
					self.arrIdeasImage.append(dict as AnyObject)
				}
				if self.arrIdeasImage.count > ImageLimt {
                   
					self.restImageCount = self.arrIdeasImage.count - ImageLimt
				
				}
                self.collectionViewFollowers.reloadData()
			}

            if let _ = ((datasource!["User"] as? AnyObject)?["images"]) as? AnyObject{
            
                
                let imageUrl = ((((datasource!["User"] as AnyObject) ["images"] as AnyObject)["display_profile"] as AnyObject)["medium"]) as? String
                
     
                if imageUrl != ""{
                    
                self.imageFollowers.setImage(withURL: URL(string:imageUrl!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                }
            }
            
//			if let ImageProfile = datasource!["User"]!!["images"]!!["cover_profile"] as? String {
//				
//
//			}
            let likeCount = (datasource!["User"] as AnyObject)["like_count"] as? Int!
            
            if likeCount > 0{
               buttonLikes.setTitle("\((datasource!["User"] as AnyObject)["like_count"]! as! Int)", for: UIControlState())
            }else{
                buttonLikes.setTitle("\(0)", for: UIControlState())
            }
			
            
		}
	}

	@IBAction func actionLike(_ sender: UIButton) {
        
	}
    
	@IBAction func actionUnfollow(_ sender: UIButton) {
		if actionUnfollowHandler != nil {
			actionUnfollowHandler!(Int(((datasource!["User"] as AnyObject)["id"] as? Int)!))
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		viewFollowers.layer.cornerRadius = IS_IPAD() ? 10 : 5
		viewFollowers.layer.borderWidth = IS_IPAD() ? 2 : 1
		viewFollowers.layer.borderColor = UIColor(red: 198.0 / 255.0, green: 220.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0).cgColor
		viewFollowers.layer.masksToBounds = true

		buttonUnfollow.layer.borderWidth = IS_IPAD() ? 2 : 1
		buttonUnfollow.layer.cornerRadius = IS_IPAD() ? 20.0 : 15.0
		buttonUnfollow.layer.borderColor = UIColor(red: 198.0 / 255.0, green: 220.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0).cgColor
		buttonUnfollow.layer.masksToBounds = true

		imageFollowers.layoutIfNeeded()
		imageFollowers.layer.cornerRadius = imageFollowers.frame.size.width / 2
		imageFollowers.layer.masksToBounds = true

		buttonLikes.setTitleColor(UIColor.black, for: UIControlState())
		buttonLikes.imageEdgeInsets = UIEdgeInsetsMake(4, IS_IPAD() ? 18 : 9, 36, 0)
		buttonLikes.titleEdgeInsets = UIEdgeInsetsMake(IS_IPAD() ? 30 : 22, IS_IPAD() ? -29 : -19, IS_IPAD() ? -2 : 1, IS_IPAD() ? 16 : 14)
	}
}

extension FollowersTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if self.arrIdeasImage.count >= ImageLimt {
			self.totalRowCount = ImageLimt
		}
		else {
			self.totalRowCount = self.arrIdeasImage.count
		}
		return self.totalRowCount!
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FollowersCollectionViewCell.self), for: indexPath) as! FollowersCollectionViewCell
	
        cell.datasource = self.arrIdeasImage[indexPath.row]
        if self.totalRowCount! - 1 == indexPath.row {
			cell.viewCoverTotalImage.isHidden = false
            if let imgCount = restImageCount{
               cell.labelTotalRestImage.text = "+" + String(imgCount)
            }else{
                cell.labelTotalRestImage.text = String("")
            }
        }
        else {
            cell.viewCoverTotalImage.isHidden = true
        }
		return cell
	}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let ideaListVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeaListingController.self)) as! IdeaListingController
       ideaListVC.arrIdeasList = self.arrFollwingIdeaList
        ideaListVC.eIdeaListApiCallStatus = .eNotCallIdeaListApi
        NavigationHelper.helper.contentNavController?.pushViewController(ideaListVC, animated: true)
    }
    
	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: IS_IPAD() ? 85 : 55, height: IS_IPAD() ? 85 : 55)
	}
}

