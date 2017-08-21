//
//  InfluencerList.swift
//  Greenply
//
//  Created by Jitendra on 10/7/16.
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


class Influencer: NSObject {
    
    var influencerUserName: String?
    var influencerCoverProfle: String?
    var influencerContactNo: String?
    var influencerLikeCount: Int?
    var influencerID: Int?
    var influencerAddress: String?
    var influencerCoverPicOriginal: String?
    var influencerCoverPicThumb: String?
    var influencerCoverPicMedium: String?
    var influencerViewCount: Int?
    var influencerTypeID: Int?
    var aboutUs: String?
    var influencerAccessToken: String?
    var influencerserviceArea: String?
    var influencerType: String?
    var influencerExperiences: String = ""
    var influencerTotalExperiences: String?
    var influencerEducations: String = ""
    var isFollowStatus: Bool?
    var isLikedStatus: Bool?
    var abusedStatus: Bool?
    var longitude: String?
    var latitude: String?
    var arrEducationList = [AnyObject]()
    var arrExperienceList = [AnyObject]()
    var influencerDistance: Double?
    var coverProfileImg: String?
    var displayProfileImg: String?
    var influencerCity: String?

    
    
    init(withDictionary dict:[String: AnyObject]) {
        
        self.influencerID = dict["id"] as? Int!
        self.influencerUserName = dict["name"] as? String
        let likeCout = dict["like_count"] as? Int
        if likeCout > 0{
            self.influencerLikeCount = dict["like_count"] as? Int
        }else{
            self.influencerLikeCount = 0
        }
        
        let distanceMiter = dict["distance"] as? Double
      
        if let _ = distanceMiter{
            var distanceKm =   distanceMiter!/1000
            self.influencerDistance = Double(distanceKm.roundToPlaces(2))
        }
        self.influencerAddress = dict["address"] as? String
        self.influencerContactNo = dict["contact_no"] as? String
        self.influencerAccessToken = dict["access_token"] as? String
        self.latitude = dict["latitude"] as? String
        self.longitude = dict["longitude"] as? String
        self.abusedStatus = dict["abused"] as? Bool
        if let _ = dict["city"]{
            self.influencerCity = dict["city"]!["name"] as? String
        }else{
            self.influencerCity = "N/A"
        }
        // image parse..
      if let _ = dict["images"]!["display_profile"]{
        self.displayProfileImg = ((dict["images"] as AnyObject)["display_profile"] as AnyObject)["medium"] as? String
        
    }
        
        if let _ = dict["images"]!["cover_profile"]{
            self.coverProfileImg = ((dict["images"] as AnyObject)["cover_profile"] as AnyObject)["medium"] as? String
           
        }
  
        self.isFollowStatus = dict["isFollwed"] as? Bool
        self.isLikedStatus = dict["isLiked"] as? Bool
        if let _ = dict["profile"]!["service_area"] {
           self.influencerserviceArea = Helper.sharedClient.checkNullValue(dict["profile"]!["service_area"] as? String as AnyObject, nillStringReplaceWith: "Service area not available") as? String
        }else{
           self.influencerserviceArea = "Service area not available"
        }
      
        self.influencerType = Helper.sharedClient.checkNullValue(((dict["profile"] as AnyObject)["influencer_type"] as AnyObject)["influencer_type"] as? String as AnyObject, nillStringReplaceWith: "N/A") as? String
        if dict["about_me"] as? String == "" {
            self.aboutUs = "N/A"
        } else {
            self.aboutUs = dict["about_me"] as? String
        }
        
        let expValue = dict["profile"]!["total_experience"] as? String
        if expValue == "0.00"{
            influencerTotalExperiences = "0"
        }else{
            influencerTotalExperiences = dict["profile"]!["total_experience"] as? String
        }
        
        
        
        
        self.influencerViewCount = Helper.sharedClient.checkNullValue(dict["view_count"] as? Int as AnyObject, nillStringReplaceWith: "0") as? Int
        self.influencerTypeID = ((dict["profile"] as AnyObject)["influencer_type"] as AnyObject)["influencer_type_id"] as? Int
        self.influencerCoverProfle = Helper.sharedClient.checkNullValue(dict["cover_profile"] as? String as AnyObject, nillStringReplaceWith: "") as? String
        
        // MARK:-  experiences
        let arrExpValue = dict["experiences"] as! [AnyObject]
        if arrExpValue.count > 0 {
            for index in 0..<arrExpValue.count {
                let dictExp = arrExpValue[index] as! [String: AnyObject]
                let objExprience = Experience(withDictionary: dictExp)
                self.arrExperienceList.append(objExprience)
            }
            
        }
        
        
        // MARK: - Education
        let arrEduResult = dict["educations"] as! [AnyObject]
        if arrEduResult.count > 0 {
            for index in 0..<arrEduResult.count {
                
                let dictEducation = arrEduResult[index] as! [String: AnyObject]
                let objEducation = Education(withDictionary: dictEducation)
                self.arrEducationList.append(objEducation)
            }
            
        }
        
    }
    
}



//Parse Certifications
class Certificates: NSObject {
    var id: Int?
    var title: String?
    var certificateFile: String?
    init(withDictionary dictExperience: [String: AnyObject]) {
        self.id = (dictExperience["id"]! as? Int)!
        self.title = (dictExperience["title"]! as? String)!
           self.certificateFile = (dictExperience["certificate"]!["medium"]! as? String)!
        
       
    }
}

// Parse Training
class Training: NSObject {
    var training_name: String?
    var startDate: Double?
    var endDate: Double?
    init(withDictionary dictExperience: [String: AnyObject]) {
        self.training_name = (dictExperience["training_name"]! as? String)!
        if let startDate = dictExperience["end_date"] as? Double {
            self.startDate = startDate
        }
        if let endDate = dictExperience["end_date"] as? Double {
            self.endDate = endDate
        }

    }
    
}

// Parse Education.
class Education: NSObject{
    var degreeName: String?
    var startDate: Double?
    var endDate: Double?
    var stream: String?
    init(withDictionary dictEducations: [String: AnyObject]) {
        
        self.stream = (dictEducations["stream"]! as? String)!
        self.degreeName = (dictEducations["degree"]! as? String)!
        if let startDate = dictEducations["end_date"] as? Double {
            self.startDate = startDate
        }
        
        if let endDate = dictEducations["end_date"] as? Double {
            self.endDate = endDate
        }

        
        
    }
}

// Parse Experience.
class Experience: NSObject{
    var organisation_name: String?
    var startDate: Double?
    var endDate: Double?
    init(withDictionary dictExperience: [String: AnyObject]) {
        
        
        self.organisation_name = (dictExperience["organisation_name"]! as? String)!
        if let startDate = dictExperience["end_date"] as? Double {
            self.startDate = startDate
        }
        
        if let endDate = dictExperience["end_date"] as? Double {
            self.endDate = endDate
        }
    }
}


//Notification List
class Notification: NSObject{
    var notification_id: Int?
    var notification_title: String?
    var date: Int?
    var notification_type: String?
    var desc: String?
    var eventType: String?
    var eventID: Int?
    init(withDictionary dict: [String: AnyObject]) {
        

        self.notification_id = (dict["notification_type_id"]! as? Int)!
      
        //print("UserNMe \(dict["user"]!["username"])")
        
        if let _ = dict["user"]!["username"] as? String{
          self.notification_title = (dict["user"]!["username"]! as? String)!
        }
        if let _ = dict["event_type"]! as? String
        {
            self.eventType = dict["event_type"]! as? String
        }
        if let _ = dict["event_id"]! as? Int{
            self.eventID = dict["event_id"]! as? Int
        }
        self.date = (dict["created"]! as? Int)!
        //            self.notification_type = (dictExperience["notification_type"]! as? String)!
        self.desc = (dict["notification_text"]! as? String)!
        
    }
}


//UserFilterAttribute
class UserFilterAttribute: NSObject {
    var id: Int?
    var name: String?
    var value_Code: String?
    var count: Int?
    var dictAttibute = [String: AnyObject]()
    var status: Bool = false
    init(withDictionary dict: [String : AnyObject]) {
        self.id = (dict["id"]! as? Int)!
        self.name = (dict["name"]! as? String)!
        self.value_Code = (dict["value_code"]! as? String)!
        self.count = (dict["count"]! as? Int)!
       // self.dictAttibute = ["id":self.id!, "name": self.name!, "value_Code": self.value_Code!, "count": self.count!, "buttonStatus":status]
        
    }
}


//HeaderFilterAttribute
class HeaderFilterAttribute: NSObject {
    var id: Int?
    var attribute_name: String?
    init(withDictionary dict: [String: AnyObject]) {
        self.id = dict["id"] as? Int!
        self.attribute_name = dict["attribute_name"] as? String!
    }
}


