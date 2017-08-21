//
//  AllCommentsViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AllCommentsViewController: BaseViewController {
    
    @IBOutlet weak var buttonComments: UIButton!
    @IBOutlet weak var tblAllComments: UITableView!
    var isReportStatus: Bool?
    var ideaID: Int!
    var ideaUserID: Int!
    var dictLocal =  [String : AnyObject]()
    var arrAllCommentsList = [AnyObject]()
    var arrItemsList = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblAllComments.layer.cornerRadius = 5.0
        self.tblAllComments.estimatedRowHeight = 90.0
        self.tblAllComments.rowHeight = UITableViewAutomaticDimension;
       // let pan = UIPanGestureRecognizer(target: self, action: #selector(buttonMove))
        //buttonComments.addGestureRecognizer(pan)
        tblAllComments.layer.masksToBounds = true
        tblAllComments.layer.borderColor = UIBorderColor().cgColor
        tblAllComments.layer.borderWidth = 0.8
        self.makeLocalDict()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
        
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_All_Comments
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        if arrAllCommentsList.count > 0{
        self.tblAllComments.isHidden = false
        self.tblAllComments.reloadData()
        }
        else{
            self.tblAllComments.isHidden = true
            Toast.show(withMessage: NO_RECORDS_FOUND)
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    // Mark: Make A local Dict
    
    func makeLocalDict()
    {
        self.arrItemsList.removeAll()
        print("count\(self.arrAllCommentsList.count)")
        
        for index in 0..<self.arrAllCommentsList.count
        {
             let objComment  = self.arrAllCommentsList[index] as! Comments
            print("alertstatus\(objComment.commentReportAbus)")
            
            self.dictLocal = ["commentName": objComment.CommentsUserName! as AnyObject, "discription": objComment.commentsDetails! as AnyObject, "commentDate": objComment.commentDate! as AnyObject,"reportSpam": objComment.commentReportAbus! as AnyObject]
            self.arrItemsList.append(self.dictLocal as AnyObject)
        }
       
   
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        tblAllComments.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Load All Comments..
   
    
   // MARK:- Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrAllCommentsList.count
                return arrItemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllCommentsCell.self)) as! AllCommentsCell
        //cell.datasource = arrAllCommentsList[indexPath.row]
         cell.datasource = arrItemsList[indexPath.row]
      cell.buttonSpam.tag = indexPath.row
    cell.actionReportAbusHandler = {(indexValue) in
           
            
            let objCmmt = self.arrAllCommentsList[indexValue] as! Comments
            self.isReportStatus = objCmmt.commentReportAbus
            
          //  self.isReportStatus = isAbusStatus
            if self.isReportStatus == false{
                // call to api
                Helper.sharedClient.showAlertView(inViewControler: self, alertMessge: WANT_REPORT_ABUSE, indexValue: { (successIndex) in
                    if successIndex == 1{
                        self.reportAbusWith(forReportID:objCmmt.commentID, abuseType: kReportAbusComment, cell: cell, indexPath:indexValue)
                    }
                })
                
           
            }
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView!, heightForRowAtIndexPath indexPath: IndexPath!) -> CGFloat {
           return UITableViewAutomaticDimension
        
    }
    
    @IBAction func actionButtonComments(_ sender: AnyObject) {

        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true{
                
                if Globals.sharedClient.userID != self.ideaUserID!{
                    CommentPopupController.showAddOrClearPopUp(self, didSubmit: { (text, popUp) in
                        
                    APIHandler.handler.writeComment(forUser: INTEGER_FOR_KEY(kUserID), ideaID: self.ideaID, comment: text.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed), success: { (response) in
                            
                    
                            
                            
                            self.tblAllComments.isHidden = false
                            Toast.show(withMessage: COMMENT_SUCCESSFULLY)
                            let objComments = Comments(withDictionary: response!["IdeaComment"].dictionaryObject! as [String : AnyObject])
                            self.arrAllCommentsList.insert(objComments, at: 0)
                            self.makeLocalDict()
                            popUp?.dismissAnimate()
                            
                            self.tblAllComments.reloadData()
                            
                            
                        }) { (error) in
                            
                        }
                        
                    }) {
                        
                    }
                }
                else{
                   Toast.show(withMessage: USER_CAN_NOT_COMMENT)
                }
                
            }
        }
        
    }
    
    func buttonMove(_ pan: UIPanGestureRecognizer) {
        
        let loc = pan.location(in: self.view)
        self.buttonComments.center = loc
    }
}
extension AllCommentsViewController{
    // call report abus api
    
    // Working on Report abus.
    func reportAbusWith(forReportID typeID: Int?, abuseType: String?, cell: AllCommentsCell?, indexPath:Int?) {
        APIHandler.handler.reportAbuseWithTypeID(forTypeID: typeID!, abuse_type: abuseType!, success: { (response) in
             var tempDict = self.arrItemsList[indexPath!] as! [String: AnyObject]
            let reportSpamStatus = true
             tempDict["reportSpam"] = reportSpamStatus as AnyObject?
             self.arrItemsList[indexPath!] = tempDict as AnyObject
            print("Report Value==\(self.arrItemsList)")
           cell?.buttonSpam.setImage(UIImage(named: kReportAbusRedImage), for:.normal)
            //self.isReportStatus = true
            
        }) { (error) in
         Toast.show(withMessage: "You've already submitted a report for this item")
        }
    }
}

