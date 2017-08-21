//
//  AllCommentsCell.swift
//  Greenply
//
//  Created by Jitendra on 9/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AllCommentsCell: BaseTableViewCell {

	@IBOutlet weak var lableCommentDate: UILabel!
	@IBOutlet weak var labelCommentName: UILabel!
//	var actionReportAbusHandler: ((CommentID: Int, isAbusStatus: Bool, indexValue: Int) -> ())?
    var actionReportAbusHandler: ((_ indexValue: Int) -> ())?
	@IBOutlet weak var labelCommentDiscrption: UILabel!
	@IBOutlet weak var buttonSpam: UIButton!
	var objCommentsList: Comments!
	var dictValue = [String: AnyObject]()
	override var datasource: AnyObject? {
		didSet {
//			objCommentsList = datasource as! Comments
//			labelCommentName.text = objCommentsList.CommentsUserName
//			let properString = objCommentsList.commentsDetails!.stringByRemovingPercentEncoding
//
//
//
//
//
//            let strCommentsdic =   properString?.trimString(forString: properString)
//                   labelCommentDiscrption.text = strCommentsdic?.stringSeparatedWith(forString: strCommentsdic!, separatedBy: "+")
//         //labelCommentDiscrption.text = properString!.condenseWhitespace(properString!)
//			lableCommentDate.text = NSDate.dateFromTimeInterval(objCommentsList.commentDate!).getFormattedStringWithFormat()
//            if objCommentsList.commentReportAbus == true{
//            self.buttonSpam.setImage(UIImage(named: kReportAbusRedImage), forState: .Normal)
//            }
//            else{
//            self.buttonSpam.setImage(UIImage(named: kReportAbusGreenImage), forState: .Normal)
//            }

			dictValue = datasource as! [String: AnyObject]
			labelCommentName.text = dictValue["commentName"] as? String
			let properString = (datasource!["discription"] as! String).removingPercentEncoding
            
             labelCommentDiscrption.text = properString?.stringSeparatedWith(forString: properString!, separatedBy: "+")

     // labelCommentDiscrption.text = properString
            
//			let strCommentsdic = properString?.trimString(forString: properString)
//			labelCommentDiscrption.text = strCommentsdic?.stringSeparatedWith(forString: strCommentsdic!, separatedBy: "+")
//			labelCommentDiscrption.text = properString!.condenseWhitespace(properString!)
			lableCommentDate.text = Date.dateFromTimeInterval((dictValue["commentDate"] as? Double)!).getFormattedStringWithFormat()
			if dictValue["reportSpam"] as! Bool == true {
				self.buttonSpam.setImage(UIImage(named: kReportAbusRedImage), for: UIControlState())
			}
			else {
				self.buttonSpam.setImage(UIImage(named: kReportAbusGreenImage), for: UIControlState())
			}

		}
	}

	@IBAction func actionReportAbus(_ sender: UIButton) {
		if actionReportAbusHandler != nil {
//			actionReportAbusHandler!(CommentID: objCommentsList.commentID!, isAbusStatus: objCommentsList.commentReportAbus!, indexValue: sender.tag) // For time
            
            actionReportAbusHandler!(sender.tag)
            
		}
	}

}
