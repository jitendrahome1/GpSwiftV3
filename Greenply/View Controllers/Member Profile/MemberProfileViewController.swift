//
//  MemberProfileViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MemberProfileViewController: BaseTableViewController {

	@IBOutlet weak var labelName: UILabel!;
	@IBOutlet weak var labelAddress: UILabel!
	@IBOutlet weak var imageMeetAnExpert: UIImageView!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelViews: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    
	@IBOutlet weak var collectionViewIdeas: UICollectionView!
	@IBOutlet weak var labelAboutNameDesc: UILabel!
    
    @IBOutlet weak var viewCollectionIdeas: UIView!
    @IBOutlet weak var viewCollectionName: UIView!
    
    @IBOutlet weak var buttonFollowing: UIButton!
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageBackgroundProf: UIImageView!
    
    @IBOutlet weak var imageBar1: UIImageView!
    @IBOutlet weak var imageBar2: UIImageView!
    @IBOutlet weak var imageBar3: UIImageView!

    @IBOutlet weak var buttonReportAbus: UIButton!
	override func viewDidLoad() {
		super.viewDidLoad()
        
        self.tableView.backgroundView = nil
        
        imageBar1.alpha = IS_IPAD() ? 1 : 0
        imageBar2.alpha = IS_IPAD() ? 1 : 0
        imageBar3.alpha = IS_IPAD() ? 1 : 0
        
        imageProfile.backgroundColor = UIColor.brown
        imageProfile.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        imageProfile.layer.borderColor = UIColor(red: 130.0/255.0, green: 185.0/255.0, blue: 55.0/255.0, alpha: 1.0).cgColor
        imageProfile.layer.cornerRadius = IS_IPAD() ? imageProfile.frame.size.width/2 : 110/2
        imageProfile.layer.masksToBounds = true
        
        buttonFollowing.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        buttonFollowing.layer.borderColor = UIColor(red: 82.0/255.0, green: 202.0/255.0, blue: 99.0/255.0, alpha: 1.0).cgColor
        buttonFollowing.layer.cornerRadius = IS_IPAD() ? 20.0 : 15.0
        buttonFollowing.layer.masksToBounds = true
        
        viewCollectionIdeas.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        viewCollectionIdeas.layer.cornerRadius = IS_IPAD() ? 15.0 : 5.0
        viewCollectionIdeas.layer.borderColor = UIColor(red: 224.0/255.0, green: 226.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
        viewCollectionIdeas.layer.masksToBounds = true
        
        viewCollectionName.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        viewCollectionName.layer.cornerRadius = IS_IPAD() ? 15.0 : 5.0
        viewCollectionName.layer.borderColor = UIColor(red: 224.0/255.0, green: 226.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
        viewCollectionName.layer.masksToBounds = true
        
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    
@IBAction func actionReportAbus(_ sender: UIButton) {

    }
}


extension MemberProfileViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return IS_IPAD() ? 308 : 252
        case 1:
            return IS_IPAD() ? 96 : 80
        case 2:
            return IS_IPAD() ? 268 : 250
        case 3:
            return IS_IPAD() ? 200 : 200
        default:
            return 0
        }
    }
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
}


extension MemberProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {

	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MemberProfileCollectionViewCell.self), for: indexPath) as! MemberProfileCollectionViewCell
        cell.datasource = "test" as AnyObject?
		return cell
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: IS_IPAD() ? 250 : 200, height: IS_IPAD() ? 170 : 150)
	}

}
