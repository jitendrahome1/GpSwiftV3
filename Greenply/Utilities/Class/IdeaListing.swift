//
//  IdeaListing.swift
//  Greenply
//
//  Created by Jitendra on 9/22/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class IdeaListing: NSObject {

	var IdeaID: Int?
	var IdeaUserID: Int?
	var ideaName: String?
	var ideaSlud: String?
	var ideaDescription: String?
	var metaDescription: String?
	// var ideaImage : String?
	var ideaImageThumb: String?
	var ideaImageOriginal: String?
	var ideaImageMedium: String?
	var ideaImageBig: String?
	var viewCount: Int?
	var likeCount: Int?
	var status: String?
	var deleteStatus: String?
	var createAt: String?
	var updateAt: String?
	var ideaURL: String?
	var roomValue: String?
	var styleType: String?
	var styleValue: String?
	var isFollowStatus: Bool?
	var isLikedStatus: Bool?
	var isPinnedStatus: Bool?
	var coverProfileImg: String?
	var displayProfileImg: String?
	var isReportAbusStatus: Bool?
    
     override init() {
    
    }
    init(forIdeaDetails response: JSON){
        
        print("Data \(response)")
        self.isReportAbusStatus = response["abused"].bool
        self.isFollowStatus = response["isFollowing"].bool
        self.isLikedStatus = response["isLiked"].bool
        self.isPinnedStatus = response["isPinned"].bool
        self.IdeaID = response["Idea"]["id"].intValue
        self.ideaDescription = response["Idea"]["description"].string
        self.ideaImageThumb = response["Idea"]["idea_image"]["thumb"].string
        self.ideaImageBig = response["Idea"]["idea_image"]["big"].string
        self.ideaImageMedium = response["Idea"]["idea_image"]["medium"].string
        self.ideaImageOriginal = response["Idea"]["idea_image"]["original"].string
        self.roomValue = response["Idea"]["attributeWithValue"]["room_type"]["value"].string
        self.styleValue = response["Idea"]["attributeWithValue"]["style_type"]["value"].string
        self.ideaName = response["Idea"]["idea_name"].string
        self.likeCount = response["Idea"]["like_count"].intValue
        self.viewCount = response["Idea"]["view_count"].intValue
        
        // image parse..
        if let _ = response["Idea"]["user"]["images"].dictionaryObject{
            self.coverProfileImg = response["Idea"]["user"]["images"]["cover_profile"]["medium"].string
            self.displayProfileImg = response["Idea"]["user"]["images"]["display_profile"]["medium"].string
        }
       
    }
    
	  init(withDictionary dict: [String: AnyObject]) {
        
   
		self.IdeaID = dict["id"] as? Int!
		self.IdeaUserID = dict["user_id"] as? Int!
		self.ideaDescription = dict["description"] as? String
		self.ideaName = dict["idea_name"] as? String
		self.ideaSlud = dict["idea_slug"] as? String
		if let metaDetails = dict["meta_description"]?.stringValue {
			self.metaDescription = metaDetails
		} else {
			self.metaDescription = ""
		}

		print("Dict VAlue\(dict)")
		if let _ = dict["attributeWithValue"]!["room_type"]! {
			self.roomValue = (((dict["attributeWithValue"] as AnyObject)["room_type"] as AnyObject)["value"]!! as? String)!
		}

		if let _ = dict["attributeWithValue"]!["style_type"]  {
			self.styleValue = (((dict["attributeWithValue"] as AnyObject)["style_type"] as AnyObject)["value"]!! as? String)!

		}
		// image parse..
		if let _ = dict["user"]!["images"] as? [String: AnyObject] {
			self.coverProfileImg = ((dict["user"]!["images"] as AnyObject)["cover_profile"] as AnyObject)["medium"] as? String
			self.displayProfileImg = (((dict["user"] as AnyObject)["images"] as AnyObject)["display_profile"] as AnyObject)["medium"] as? String
		}

		self.ideaImageThumb = dict["idea_image"]!["thumb"] as? String
		self.ideaImageMedium = dict["idea_image"]!["medium"] as? String
		self.ideaImageBig = dict["idea_image"]!["big"] as? String
		self.ideaImageOriginal = dict["idea_image"]!["original"] as? String
		self.likeCount = (dict["like_count"] as? Int)!
		self.viewCount = dict["view_count"] as? Int!
		self.ideaName = dict["idea_name"] as? String
        
        
    
    }
    
    

}

class Comments: NSObject {
	var status: Int?
	var commentID: Int?
	var commentedUserID: Int?
	var CommentsUserName: String?
	var commentsDetails: String?
	var commentIdeaID: Int?
	var commentDate: Double?
	var commentReportAbus: Bool?
	init(withDictionary dictComments: [String: AnyObject]) {
		self.status = dictComments["status"] as? Int!
		self.commentID = dictComments["id"] as? Int!
		self.commentedUserID = dictComments["user_id"] as? Int!
		self.CommentsUserName = dictComments["user_name"] as? String
		self.commentsDetails = dictComments["comment"] as? String
		self.commentIdeaID = dictComments["idea_id"] as? Int!
		self.commentDate = dictComments["created_at"] as? Double
		self.commentReportAbus = dictComments["abused"] as? Bool

	}
}

class Ratings: NSObject {
	var rating: Int?
	var comment: String?
	var createdAt: Int?
	var serviceTaken: String?
	var name: String?
	var title: String?

	init(withDictionary dictComments: [String: AnyObject]) {

		print("comments==>\(dictComments)")

		self.rating = dictComments["rating"] as? Int

		// self.comment  = Helper.sharedClient.checkNullValue(dictComments["description"] as? String, nillStringReplaceWith: "N/A") as? String

        if let _ = dictComments["description"]{
            let strComment = Helper.sharedClient.checkNullValue(dictComments["description"] as? String as AnyObject?, nillStringReplaceWith: "N/A") as? String
            let splitArray = strComment?.components(separatedBy: "+")
            
            var commentStr = ""
            for index in 0..<splitArray!.count {
                commentStr = commentStr + (splitArray![index])
                if index < splitArray!.count - 1 {
                    commentStr = commentStr + " "
                }
            }
            self.comment = commentStr
        }
		

		self.createdAt = Helper.sharedClient.checkNullValue(dictComments["created_at"] as? Int as AnyObject?, nillStringReplaceWith: "N/A") as? Int

		let serverValue = Helper.sharedClient.checkNullValue(dictComments["service_taken"] as? Int as AnyObject?, nillStringReplaceWith: "N/A") as? Int
		if serverValue == 0 {
			serviceTaken = "Service taken"
		} else {
			serviceTaken = "Service is not taken"
		}
        if let _ = dictComments["title"]{
            let strComment = Helper.sharedClient.checkNullValue(dictComments["title"] as? String as AnyObject?, nillStringReplaceWith: "N/A") as? String
            let splitArray = strComment?.components(separatedBy: "+")
            
            var commentTitle = ""
            for index in 0..<splitArray!.count {
                commentTitle = commentTitle + (splitArray![index])
                if index < splitArray!.count - 1 {
                    commentTitle = commentTitle + " "
                }
            }
           self.title = commentTitle
        }
		//self.title = Helper.sharedClient.checkNullValue(dictComments["title"] as? String, nillStringReplaceWith: "N/A") as? String
		self.name = Helper.sharedClient.checkNullValue(dictComments["review_by"]!["name"] as? String as AnyObject?, nillStringReplaceWith: "N/A") as? String

		// Helper.sharedClient.checkNullValue(dictComments["title"] as? String, nillStringReplaceWith: "N/A") as? String
		// self.comment = dictComments["comment"] as? String
		// self.createdAt = dictComments["created_at"] as? Int
		// self.serviceTaken = dictComments["service_taken"] as? Int
		// self.name = dictComments["review_by"]!["name"] as? String
	}
}

class InfluencerType: NSObject {
	var influencerType: String?
	var influencerTypeId: Int?
	init(withDictionary dictComments: [String: AnyObject]) {
		self.influencerType = dictComments["influencer_type"] as? String
		self.influencerTypeId = dictComments["influencer_type_id"] as? Int
	}
}


class MyPinList: NSObject {
    var pinID: String?
    var pinName: String?
    var pinImage: String?
    var pinThimbImage: String?
    var pinOriginalImage: String?
    var pinMediumImage: String?
    init(withDictionary dictComments: [String: AnyObject]) {
        self.pinID = dictComments["id"] as? String
        self.pinName = dictComments["name"] as? String
        self.pinImage = dictComments["image"] as? String
        self.pinThimbImage = dictComments["thumb"] as? String
        self.pinOriginalImage = dictComments["original"] as? String
        self.pinMediumImage = dictComments["medium"] as? String
    }
}




