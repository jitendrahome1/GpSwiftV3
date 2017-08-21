//
//  FollowerAndFollowing.swift
//  Greenply
//
//  Created by Jitendra on 9/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var userName: String?
    var userID: Int?
    var userEmail: String?
    var userContactNumber: String?
    var userLikeCount: Int?
    var userAddress: String?
    var userAboutUS: String?
    var UserViewCount: Int?
    var profileImage: String?
    var profileImageOriginal: String?
    var profileImageThumb: String?
    var profileImageMedium: String?
    var coverImage: String?
    var coverImageOriginal: String?
    var coverImageThumb: String?
    var coverImageMedium: String?
    var StateID: Int?
    var StateName: String?
    var CityID: Int?
    var CityName: String?
    var expYear: String?
    var expMonths: String?
    var name: String?
    var userType: String?
    var totalNotification: Int?
    var accessToken: String?
    var zipCode: String?
    var userBirthDate: Double?
    var arrExperienceList = [AnyObject]()
    var arrEducationList = [AnyObject]()
    var arrTraningList = [AnyObject]()
    var arrStateID = [AnyObject]()
    var arrCityID = [AnyObject]()
    var arrCertificationsList = [AnyObject]()
    var arrSkillsList = [AnyObject]()
    var arrAreaServed = [AnyObject]()
    var arrSkillID = [String]()
    var arrSkillName = [AnyObject]()
    var strTypalAttrValue: String?
    var loginUserType: String?
    var typialJobCostID: Int?
    override init() {
    
    }
    init(withDictionary dict: [String: AnyObject]) {
        
        userName = dict["username"] as? String
        accessToken = dict["access_token"] as? String
        self.loginUserType = dict["user_type"] as? String
        if let _ =  dict["attributeWithValue"]!["typical_job_cost"]{
      strTypalAttrValue = (((dict["attributeWithValue"] as! [String: AnyObject])["typical_job_cost"] as![String: AnyObject])["value"] as! String)
            
        typialJobCostID = (((dict["attributeWithValue"] as! [String: AnyObject])["typical_job_cost"] as![String: AnyObject])["value_id"] as! Int)
            
        }
        name = dict["name"] as? String
        userID = dict["id"] as? Int
        userEmail = dict["email"] as? String
        userContactNumber = dict["contact_no"] as? String
        userLikeCount = dict["like_count"] as? Int
        userAddress = dict["address"] as? String
        userAboutUS = dict["about_me"] as? String
        UserViewCount = dict["UserViewCount"] as? Int
        totalNotification = dict["totalNotification"] as? Int
        self.CityName = dict["city"]!["name"] as? String
        self.CityID = dict["city"]!["id"] as? Int
        self.StateName = dict["state"]!["name"] as? String
        self.StateID = dict["state"]!["id"] as? Int
        zipCode = dict["zip"] as? String
        if let birthdate = dict["birth_date"] {
            userBirthDate = birthdate as? Double
        } else {
            userBirthDate = Double("")
        }
        if let _ = dict["images"]!["display_profile"]{
        
            self.profileImageOriginal = (((dict["images"] as! [String: AnyObject])["display_profile"] as![String: AnyObject])["original"] as! String)
            
                self.profileImageMedium = (((dict["images"] as! [String: AnyObject])["display_profile"] as![String: AnyObject])["medium"] as! String)
                self.profileImageThumb = (((dict["images"] as! [String: AnyObject])["display_profile"] as![String: AnyObject])["thumb"] as! String)
            
        }
        
        if let _ = dict["images"]!["cover_profile"]{
     
            self.coverImageThumb = (((dict["images"] as! [String: AnyObject])["cover_profile"] as![String: AnyObject])["thumb"] as! String)
                 self.coverImageOriginal = (((dict["images"] as! [String: AnyObject])["cover_profile"] as![String: AnyObject])["original"] as! String)
              self.coverImageMedium = (((dict["images"] as! [String: AnyObject])["cover_profile"] as![String: AnyObject])["medium"] as! String)
        }
        
        if let _ = dict["profile"]!["influencer_type"]{
       
            
self.userType = (((dict["profile"] as! [String: AnyObject])["influencer_type"] as![String: AnyObject])["influencer_type"] as! String)
        }
        
        
        if let _ = dict["profile"]!["exp_year"]{
            
            
            
            self.expYear = String(dict["profile"]!["exp_year"] as! Int)
            self.expMonths = String(dict["profile"]!["exp_month"] as! Int)
        
        
        }
        
        
//        if let _ = dict["profile"]!["total_experience"]{
//            
//            
//            
//
//           
//            
//            
//            let arrTotlExp = totalExp!.componentsSeparatedByString(".")
//            
//            self.expYear = arrTotlExp[0]
//            let strMonth = arrTotlExp[1]
//            if strMonth != ""{
//                self.expMonths = String(strMonth[strMonth.startIndex.advancedBy(0)])
//                
//            }
//        
//        
//        
//        }
        
        //        if let arrAtribut = dict["attributeWithValue"] as! [AnyObject]{
        //
        //        }
        
//        // MARK:- geting Service Locations,
//        if let arrServiceLocations = dict["serviceLocations"]{
//            for index in 0..<arrServiceLocations.count {
//                self.arrStateID.append(arrServiceLocations[index]["id"] as! Int)
//                if let pCityInfo = arrServiceLocations[index]["cityLocations"]{
//                    for value in pCityInfo! as! [AnyObject]{
//                        arrCityID.append(value["id"]! as! Int)
//                    }
//                }
//            }
//        }
        
        
        
        // MARK:- geting Service Locations,
        if let arrServiceLocations : [AnyObject]  = dict["serviceLocations"] as? [AnyObject]   {
            for index in 0..<arrServiceLocations.count {
                
                self.arrAreaServed.append(arrServiceLocations[index] as AnyObject)
                

           
                
                
            }
        }
        
        
        
        
        
        // MARK:-  experiences
        let arrExpValue = dict["experiences"] as! [AnyObject]
        if arrExpValue.count > 0 {
            for index in 0..<arrExpValue.count {
                let dictExp = arrExpValue[index] as! [String: AnyObject]
                let objExprience = UserExperience(withDictionary: dictExp)
                self.arrExperienceList.append(objExprience)
            }
            
        }
        
        // MARK:-  Traning
        let arrTrainingValue = dict["trainings"] as! [AnyObject]
        if arrTrainingValue.count > 0 {
            for index in 0..<arrTrainingValue.count {
                let dictTraining = arrTrainingValue[index] as! [String: AnyObject]
                let objTraining = UserTraining(withDictionary: dictTraining)
                self.arrTraningList.append(objTraining)
            }
            
        }
        // MARK: - Education
        let arrEduResult = dict["educations"] as! [AnyObject]
        if arrEduResult.count > 0 {
            for index in 0..<arrEduResult.count {
                
                let dictEducation = arrEduResult[index] as! [String: AnyObject]
                let objEducation = UserEducation(withDictionary: dictEducation)
                self.arrEducationList.append(objEducation)
            }
            
        }
        // MARK: - certifications
        let arrCertifications = dict["certifications"] as! [AnyObject]
        if arrCertifications.count > 0 {
            for index in 0..<arrCertifications.count {
                
                let dictCertifications = arrCertifications[index] as! [String: AnyObject]
                let objCertifications = UserCertificates(withDictionary: dictCertifications)
                self.arrCertificationsList.append(objCertifications)
            }
            
        }
        // MARK: - Skill
        let arrSkill = dict["skills"] as! [AnyObject]
        if arrSkill.count > 0 {
            for index in 0..<arrSkill.count {
                let dictSkill = arrSkill[index] as! [String: AnyObject]
                
                let objTags = SkillTags(withDictionary: arrSkill[index] as! [String: AnyObject])
                
                self.arrSkillsList.append(objTags)

                
                
                //let dict = ["skillsID": dictSkill["skill_id"] as! Int, "skillsName":dictSkill["skill_name"] as! String]
               // self.arrSkillsList.append(dict)
                
//                let skillID = dictSkill["skill_id"] as! Int
//                
//                self.arrSkillID.append(String(skillID))
//                
//                self.arrSkillName.append(dictSkill["skill_name"] as! String)
            }
        }
    }
    

}

//Parse Certifications
class UserCertificates: NSObject {
    var pId: Int?
    var title: String?
    var certificateFile: String?
    var dictCertItemsList =  [String: AnyObject]()
    init(withDictionary dictExperience: [String: AnyObject]) {
        self.pId = (dictExperience["id"]! as? Int)!
        self.title = (dictExperience["title"]! as? String)!
        self.dictCertItemsList = (dictExperience["certificate"])! as! [String:AnyObject]
        self.certificateFile = (dictExperience["certificate"]!["medium"]! as? String)!
        
        
    }
}

// Parse Training
class UserTraining: NSObject {
    var training_name: String?
    var startDate: Double?
    var endDate: Double?
    var stream = ""
    var pId: Int?
    init(withDictionary dictExperience: [String: AnyObject]) {
        self.training_name = (dictExperience["training_name"]! as? String)!
        if let startDate = dictExperience["start_date"] as? Double {
            self.startDate = startDate
        }else{
               self.startDate =  Helper.sharedClient.dateStringToTimeStampFormat(dateformat: dictExperience["start_date"] as! String)
            
           
        }
        if let endDate = dictExperience["end_date"] as? Double {
            self.endDate = endDate
        }else{
           self.endDate = Helper.sharedClient.dateStringToTimeStampFormat(dateformat: dictExperience["end_date"] as! String)
        }
        self.pId = dictExperience["id"] as? Int
    }
    
}

// Parse Education.
class UserEducation: NSObject {
    var degreeName: String?
    var startDate: Double?
    var endDate: Double?
    var stream: String?
    var pId: Int?
    init(withDictionary dictEducations: [String: AnyObject]) {
        
        self.stream = (dictEducations["stream"]! as? String)!
        self.degreeName = (dictEducations["degree"]! as? String)!
        if let startDate = dictEducations["start_date"] as? Double {
            self.startDate = startDate
        }else{
            self.startDate =  Helper.sharedClient.dateStringToTimeStampFormat(dateformat: dictEducations["start_date"] as! String)
            
            
        }
        
        if let endDate = dictEducations["end_date"] as? Double {
            self.endDate = endDate
        }else{
            self.endDate = Helper.sharedClient.dateStringToTimeStampFormat(dateformat: dictEducations["end_date"] as! String)
        }
        self.pId = dictEducations["id"] as? Int
    }
}

// Parse Experience.
open class UserExperience: NSObject {
    var organisation_name: String?
    var startDate: Double?
    var endDate: Double?
    var stream = ""
    
    var pId: Int?
    init(withDictionary dictExperience: [String: AnyObject]) {
        
        self.organisation_name = (dictExperience["organisation_name"]! as? String)!
        if let startDate = dictExperience["start_date"] as? Double {
            self.startDate = startDate
        }else{
            self.startDate =  Helper.sharedClient.dateStringToTimeStampFormat(dateformat: dictExperience["start_date"] as! String)
            
            
        }
        
        if let endDate = dictExperience["end_date"] as? Double {
            self.endDate = endDate
        }else{
            self.endDate = Helper.sharedClient.dateStringToTimeStampFormat(dateformat: dictExperience["end_date"] as! String)
        }
        self.pId = dictExperience["id"] as? Int
        
    }
}

