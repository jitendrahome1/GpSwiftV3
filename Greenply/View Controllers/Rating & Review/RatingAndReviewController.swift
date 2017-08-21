//
//  RatingAndReviewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 01/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class RatingAndReviewController: BaseViewController {
    
    @IBOutlet weak var tableRating: UITableView!
    var arrRatings = [AnyObject]()
    var dictRating: JSON?
    var objInfluencerItems: Influencer!
    var influncerID: Int?
    override func viewDidLoad() {
    super.viewDidLoad()
    self.initialUISetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_Rate_Review
        self.getRateAndReviewList()
        
    }
    
    // MARK:- initial setup
    func initialUISetup()
    {
        tableRating.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
//        tableRating.needsUpdateConstraints()
//        tableRating.estimatedRowHeight = 212
//        tableRating.rowHeight = UITableViewAutomaticDimension;
    }
    
    
    @IBAction func actionWriteReview(_ sender: AnyObject) {
    Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
        if isLogin == true{
            let writeReviewVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: WriteReviewController.self)) as! WriteReviewController
            //writeReviewVC.influncerID = self.influncerID
            writeReviewVC.objInfluencerList = self.objInfluencerItems
            NavigationHelper.helper.contentNavController!.pushViewController(writeReviewVC, animated: true)
        }
        }

    
    }
    
}

extension RatingAndReviewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return arrRatings.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: BaseTableViewCell?
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "RateTableViewProfileCell", for: indexPath) as? RateTableViewCell
            // (cell as! RateTableViewCell).distanceValue = self.objInfluencerItems.influencerDistance
            (cell as! RateTableViewCell).objInfluncerDetails = self.objInfluencerItems
            (cell as! RateTableViewCell).dataSource = self.dictRating
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "RateTableDetailsCell", for: indexPath) as? RateTableViewCell
            cell!.datasource = self.arrRatings[indexPath.row]
            (cell as! RateTableViewCell).labelDesc.text?.labelJustified((cell as! RateTableViewCell).labelDesc)
        }
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return IS_IPAD() ? 150 : 120
        } else {
            return IS_IPAD() ? 220 : 212
            //return UITableViewAutomaticDimension
        }
    }
}


extension RatingAndReviewController {
    func getRateAndReviewList() {
        APIHandler.handler.rateAndReview(forUser: self.objInfluencerItems.influencerID!, success: { (response) in
            self.arrRatings.removeAll()
            debugPrint("UserDetails Response -> \(response?["reviewlist"]["ratings"])")
             self.dictRating = response?["reviewlist"]
          print("Dictionary -> \(self.dictRating)")
            
            let notificationCount = response?["totalNotification"].intValue
            if notificationCount! > 0{
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(describing: notificationCount)
            }else{
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
            }
            if let _ = response?.dictionaryObject!["reviewlist"]{
            for value in (response?["reviewlist"]["ratings"].arrayObject!)! {
                    let RateListObj = Ratings(withDictionary: value as! [String : AnyObject])
                    self.arrRatings.append(RateListObj)
                }
                
            }
            self.tableRating.reloadData()
            }) { (error) in
                debugPrint("Error \(error)")
        }
    }
}


