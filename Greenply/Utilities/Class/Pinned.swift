//
//  MyPinned.swift
//  Greenply
//
//  Created by Jitendra on 9/22/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class Pinned: NSObject {
    var IdeaID:     Int!
    var UserID:     String!
    var projectName: String?
    var pinnedSlud: String?
    var pinnedDescription: String?
    var metaDescription: String?
   // var ideaImage : String?
    
    var ideaImageThumb : String?
    var ideaImageOriginal : String?
    var ideaImageMedium : String?
    var ideaImageBig : String?
    
    var viewCount:  Int?
    var likeCount: Int?
    var status: String?
    var deleteStatus: String?
    var createAt : String?
    var updateAt: String?
    var ideaURL: String?
    var roomValue: String?
    var styleType: String?
    var styleValue: String?
    
    init(withDictionary dict: [String: AnyObject]) {
        self.IdeaID = dict["id"] as? Int!
        self.pinnedDescription = dict["description"] as? String
        self.projectName = dict["idea_name"] as? String
        self.pinnedSlud = dict["idea_slug"] as? String
        if let metaDetails = dict["meta_description"]?.stringValue{
            self.metaDescription = metaDetails
        }else{
            self.metaDescription = ""
        }
        
        self.roomValue = (((dict["attributeWithValue"] as AnyObject)["room_type"] as AnyObject)["value"]!! as? String)!
        
        self.styleValue = (((dict["attributeWithValue"] as AnyObject)["style_type"] as AnyObject)["value"]!! as? String)!
        
        self.ideaImageThumb = dict["idea_image"]!["thumb"] as? String
        self.ideaImageMedium = dict["idea_image"]!["medium"] as? String
        self.ideaImageBig = dict["idea_image"]!["big"] as? String
        self.ideaImageOriginal = dict["idea_image"]!["original"] as? String
        //self.ideaImage = dict["idea_image"] as? String
        self.likeCount = (dict["like_count"] as? Int)!
        self.viewCount = dict["view_count"] as? Int!
        self.projectName = dict["idea_name"] as? String
    }
    


}
