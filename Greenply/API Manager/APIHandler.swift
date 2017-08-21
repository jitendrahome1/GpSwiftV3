//
//  GPAPIHandler.swift
//  Greenply
//
//  Created by Jitendra on 9/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIHandler: NSObject {
    static let handler = APIHandler()
    fileprivate override init() { }
    
    
    
    // MARK:- General Login
    func login(email: String?, password: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        
        let params = ["LoginForm": ["email": email!, "password": password!, "device_type": "iOS", "device_token": String(describing: Helper.sharedClient.deviceID)]]
        
        APIManager.manager.postRequestJSON(LOGIN, parameters: params as [String : AnyObject]?, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    // MARK:- User Registration
    func userRegistration(username: String?, password: String?, email: String?, contact_no: String?, cityID: Int?, stateID:Int?, pincode: String?, socialID: String?, socialType: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
//        let params = ["User": ["name": username!, "email": email!, "password": password!, "contact_no": contact_no!, "user_type": "seeker", "status": "1", "address": city!, "city": city!, "zip": pincode!, "social_id": socialID!, "social_type": socialType!]]
        
        
           let params = ["User": ["name": username!, "email": email!, "password": password!, "contact_no": contact_no!, "user_type": "seeker", "address": cityID!, "city": cityID!, "state": stateID!, "zip": pincode!, "social_id": socialID!, "social_type": socialType!]]
        
        APIManager.manager.postRequestJSON(USER_REGISTRATION, parameters: params as [String : AnyObject]?, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
               success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
         //let statusCode = response["statusCode"].intValue
            
            failure(error)
        }
    }
    
    // MARK:- User Forgot And Reset Password
    func forgotAndResetPassword(_ email: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        let params = ["User": ["email": email!]]
        
        APIManager.manager.postRequestJSON(FORGOT_RESET_PASSWORD, parameters: params as [String : AnyObject]?, headers: nil, success: { (response) in
            
            let statusCode = response?["statusCode"].intValue
            
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    // MARK:- verify OTP Forgot password
    func verifyOTPForgotPassword(forUser userID: Int?, otp: String?, password: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        let params = ["User": ["otp": otp!, "password": password!]]
        
        APIManager.manager.putRequestJSON(VERIFY_FORGOT_PASSWORD_OTP(forUser: userID!), parameters: params as [String : AnyObject]?, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    // MARK:- verify OTP USE Registration
    func verifyOTPUserRegistration(forUser userID: Int?, otp: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        let params = ["User": ["otp": otp!]]
        APIManager.manager.putRequestJSON(VERIFY_REGISTRATION_OTP(forUser: userID!), parameters: params as [String : AnyObject]?, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- verify OTP USE Registration
    func resendOTP(forUser userID: Int?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        APIManager.manager.putRequestJSON(RESEND_OTP(forUser: userID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- Change password
    func changePassword(forUser userID: Int?, old_password: String?, new_password: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        let params = ["User": ["old_password": old_password!, "password": new_password!]]
        
        APIManager.manager.putRequestJSON(CHANGE_PASSWORD(forUser: userID!), parameters: params as [String : AnyObject]?, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- InfluencerUserType
    func userType(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(INFLUENCER_TYPE, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
       Toast.show(withMessage: SOMETHING_WRONG)
        }
    }
    
    // MARK:- UserFilterAttribute
    func userFilterAttribute(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(FILTER_ATTRIBUTE, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    
    // MARK:- InfluencerFilter
    func influencerFilter(forUser user_type: String?, influencer_type: String?, influencer_filter: String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
        let cityId = OBJ_FOR_KEY(kCityId) as! Int
        APIManager.manager.getRequest(influencer_filter!, headers: ["location-city-id": String(cityId)], parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    
    
    
    // MARK:- BecomeInfluencer
       func becomeInfluencer(forUser userID: Int?, name: String?, email: String?, contact_no:String?, address: String?, aboutme: String?,birthDate: String?, user_type: String?, influencer_type_id: Int?, filetype: String?, filename: String?, base64: String?, dispfilename: String?, dispfilesize: Int?, dispbase64: String?, coverfilename: String?, coverfilesize: Int?, coverbase64: String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
   //     let params = ["User": ["name": name!, "email": email!, "contact_no": contact_no!, "address": address!, "about_me": aboutme!, "user_type": user_type!], "Profile": ["influencer_type_id": influencer_type_id!, "filename": ["filetype": filetype!, "filename": filename!, "base64": base64!]]]
        
        let params = ["User":["name": name!,"email": email!,"contact_no": contact_no!,"address": address!,"birth_date": birthDate!,"about_me": aboutme!,"display_profile": ["filename": dispfilename!,"filesize": dispfilesize!,"base64": dispbase64!],"cover_profile": ["filename": coverfilename!,"filesize": coverfilesize!,"base64": coverbase64!],"user_type":"influencer"],"Profile":["influencer_type_id": influencer_type_id!,"filename":["filetype": filetype!,"filename": filename!,"base64": base64!]],"access-token": OBJ_FOR_KEY(kToken)!] as [String : Any]

        APIManager.manager.putRequestJSON(BECOME_INFLUENCER(forUser: userID!), parameters: params as [String : AnyObject]?, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
          Toast.show(withMessage: SOMETHING_WRONG)
        }
    }
    
    
    
    // MARK:- Edit Influncer Profile
    
// new code
    //noew Code
    func editInfluencerProfile(forUser userID: Int?, forUserName name: String?, contactNumber: String?, email: String?, birthDate: String?, address: String?, aboutUs: String?, stateID:Int?,cityID: Int?, zipCode: String?, skillID:String?,ProfileImgbase64: String?,coverImgbase64:String?, serviceLocations: [AnyObject]?, expYear: Int?, expMonth: Int?,arrTypicaljobCost: [AnyObject]?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
      
        
        
        
        
        let param = [
            "User": [
                "name": name!,
                "contact_no": contactNumber!,
                "email": email!,
                "birth_date": birthDate!,
                "address": address!,
                "about_me": aboutUs!,
                "state" : stateID!,
                "city": cityID!,
                "zip": zipCode!,
                "display_profile":[
                    "filename": "profile.jpg",
                    "filesize": 25841,
                    "base64": ProfileImgbase64!
                ],
                "cover_profile":[
                    "filename": "cover.jpg",
                    "filesize": 25841,
                    "base64": coverImgbase64!
                ]
            ],
            "UserAttribute":["attribute_value_id":arrTypicaljobCost!],
            
            "Profile": ["exp_year":expYear!, "exp_month":expMonth!],

            
            "UserServiceLocation":serviceLocations!,
            "UserSkill": ["skill_id": [skillID!]]
        
        ] as [String : Any]
        
       
        
        
        APIManager.manager.putRequestJSON(EDIT_INFLUENCER(forUserId: userID!), parameters: param as? [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                Toast.show(withMessage: PROFILE_SUCCESS)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            Toast.show(withMessage: SOMETHING_WRONG)
        }
        
    }
    
    
    //Old Code
   /* func editInfluencerProfile(forUser userID: Int?, forUserName name: String?, contactNumber: String?, email: String?, birthDate: String?, address: String?, aboutUs: String?, cityID: Int?, userEducation: [AnyObject]?, userTraining: [AnyObject]?, UserExperience: [AnyObject]?, UserCertification: [AnyObject]?, serviceArea: String?, skillID: String?,base64: String?,serviceLocations: [AnyObject]?, expYear: String?, expMonth: String?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        print("UserEductiuon\(userEducation!)")

        
        
    
        let param = [
            "User": [
                "name": name!,
                "contact_no": contactNumber!,
                "email": email!,
                "birth_date": "16-Nov-1990",
                "address": address!,
                "about_me": aboutUs!,
                "city": cityID!,
                "zip": "700028",
                "display_profile":[
                    "filename": "best_empl.jpg",
                    "filesize": 25841,
                    "base64": base64!
                ],
                "cover_profile":[
                    "filename": "best_empl.jpg",
                    "filesize": 25841,
                    "base64": base64!
                ]
            ],
            
            "UserServiceLocation":serviceLocations!,
            
            "UserEducation": userEducation!,
            "UserTraining": userTraining!,
            "UserExperience": UserExperience!,
            "UserSkill": ["skill_id": [skillID!
                ]],
            "UserCertification": UserCertification!,
            
            "Profile": [
                ["exp_year":expYear!, "exp_month":expMonth!]
            ],
           "Profile": [

        ],
            
        ]
        


        
        APIManager.manager.putRequestJSON(EDIT_INFLUENCER(forUserId: userID!), parameters: param as? [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                success(response: response)
                Toast.show(withMessage: PROFILE_SUCCESS)
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
        Toast.show(withMessage: SOMETHING_WRONG)
        }
        
    }
    */
    // MARK:- WriteComment
    func writeComment(forUser userID: Int?, ideaID: Int?, comment: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        let params = ["IdeaComment": ["user_id": userID!, "idea_id": ideaID!, "comment": comment!]]
        
        APIManager.manager.postRequestJSON(WRITE_COMMENT, parameters: params as [String : AnyObject]?, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- ExpertRateAndReview
    func rateAndReview(forUser userID: Int?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        APIManager.manager.getRequest(RATE_REVIEW(forUser: userID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- UserDetails
    func userDetails(forUser userID: Int?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        APIManager.manager.getRequest(USER_DETAILS(forUserId: userID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }

    
    // MARK:- Dashboard
    func getDashboard(_ success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(DASHBOARD, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- IDEA LISTING
    func getIdeaListingList(_ pageno: Int?, pageSize: Int?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(IDEA_LIST(forPageno: pageno!, pageSize: pageSize!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            //Toast.show(withMessage: SOMETHING_WRONG)
            failure(error)
        }
    }
    
    // MARK:- IDEA Details.
    func getIdeaDetails(_ ideaID: Int?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(IDEA_DETAILS(forIdeaID: ideaID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK Get My Pinned List And Pinned Details..
    func getMyPinnedDetailsList(_ categoryID: Int?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        APIManager.manager.getRequest(MY_PINNED(forUser: categoryID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    func getMyPinList(_ success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(MY_PIN_LIST, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    // MARK:-// Get My Portfolio Listing
    func getMyPortfolioListing(_ userID: Int?, pageNumber: Int?, perPage: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
        // let params = ["user_id": userID]
        APIManager.manager.getRequest(MY_PORTFOLIO(forUser: userID!, pageNumber: pageNumber!, perPage: perPage!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- Get My Portfolio Details.
    func getPortFolioDetails(forPortFolioID portFolioID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ())
    {
        APIManager.manager.getRequest(PORTFOLIO_DETAILS(forPortFolioID: portFolioID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
        
    }
    // MARK:- PortFolio Like:-
    func portfolioLike(forUserID userID: Int?, portfolioID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        let params = ["Portfoliolike": ["user_id": userID!, "portfolio_id": portfolioID!]]
        APIManager.manager.postRequestJSON(PORTFOLIO_LIKE, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
        
    }
    
    func getFollowersAndFollowingList(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(FOLLOWS_LIST, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    
    func getAttributesForProjrcts(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
        APIManager.manager.getRequest(ATTRIBUTES_FOR_PROJECTS, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- ADD Pin To Idea.
    func addIdeaPin(withIdeaID ideaID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        let params = ["Pin": ["idea_id": ideaID!]]
        
        APIManager.manager.postRequestJSON(ADD_IDEA_PIN, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            case 409:
              Toast.show(withMessage: (response?["statusText"].stringValue)!)
            default:
               Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
                Toast.show(withMessage: SOMETHING_WRONG) 
        }
    }
    
    // MARK:- Upload Ideas
    func uploadIdea(_ ideaName: String?, description: String?, fileType: String?, fileName: String?, fileSize: String?, base64: String?, IdeaTag: [AnyObject]?, attributeValues: String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
        let params = ["Idea": ["idea_name": ideaName!, "description": description!, "image": ["filename": fileName!, "filetype": fileType!, "base64": base64!]], "IdeaAttributeValue": ["attribute_value_id": attributeValues!], "IdeaTag": ["tag_id": IdeaTag!]]
        
        APIManager.manager.postRequestJSON(ADD_IDEAS, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    
    // MARK:- UpLoad Project
    func uploadProject(_ userID: Int?, projectName: String?, description: String?, projectTypeID: String?, stypeTypeID: String?, workTypeID: String?, budgetTypeID: String?, arrTags: [AnyObject]?, imageData: [AnyObject]?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
      //  let params = ["Portfolio": ["name": projectName!, "description": description!, "user_id": userID!], "attribute_value_id": ["style_type": stypeTypeID!, "projectType": projectTypeID!, "workType": workTypeID!, "projectBudget": budgetTypeID!], "PortfolioTag": ["tag_id": arrTags!]]
       
        
//            let params = ["Portfolio[name]": projectName!, "Portfolio[description]": description!, "Portfolio[user_id]": userID!, "PortfolioAttribute[attribute_value_id][style_type]": stypeTypeID!, "PortfolioAttribute[attribute_value_id][projectType]": projectTypeID!, "PortfolioAttribute[attribute_value_id][workType]": workTypeID!, "PortfolioAttribute[attribute_value_id][projectBudget]": budgetTypeID!, "PortfolioTag[tag_id]": arrTags!]
        let userIDValue =  String(userID!)
         let params = ["Portfolio[name]": projectName!, "Portfolio[description]": description!, "Portfolio[user_id]": userIDValue, "PortfolioAttribute[attribute_value_id][style_type]": stypeTypeID!, "PortfolioAttribute[attribute_value_id][projectType]": projectTypeID!, "PortfolioAttribute[attribute_value_id][workType]": workTypeID!, "PortfolioAttribute[attribute_value_id][projectBudget]": budgetTypeID!, "PortfolioTag[tag_id]": "1,3"]
        


//
        
        
        APIManager.manager.uploadFileMultipartFormDataWithParams(UPLOAD_PROJECT, headers: nil, uploadImageList: imageData!, fileName: "filetype", parameters: params as [String : AnyObject] , success: { (response) in
            
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    // Edit Project. 
    func editUploadProject(_ userID: Int?, projectName: String?, description: String?, projectTypeID: String?, stypeTypeID: String?, workTypeID: String?, budgetTypeID: String?, arrTags: [AnyObject]?, imageData: [AnyObject]?, projectID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
      
        let userIDValue =  String(userID!)
        let params = ["Portfolio[name]": projectName!, "Portfolio[description]": description!, "Portfolio[user_id]": userIDValue, "PortfolioAttribute[attribute_value_id][style_type]": stypeTypeID!, "PortfolioAttribute[attribute_value_id][projectType]": projectTypeID!, "PortfolioAttribute[attribute_value_id][workType]": workTypeID!, "PortfolioAttribute[attribute_value_id][projectBudget]": budgetTypeID!, "PortfolioTag[tag_id]": "1,3"]
        
        
    

        APIManager.manager.uploadFileMultipartFormDataWithParams(EDIT_PORJECT(forProjectID:projectID!) , headers: nil, uploadImageList: imageData!, fileName: "filetype", parameters: params as [String : AnyObject], success: { (response) in
            
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    
    //Portfolio image edit
    
        func editProjectImage(_ imageID: Int?, attribute_value_id: String?, description: String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
            let params = ["PortfolioImages": ["attribute_value_id": attribute_value_id!, "description": description!]]
            
            APIManager.manager.putRequestJSON(EDIT_PROJECT_IMAGE(forPortfolioImageID: imageID!), parameters: params as [String : AnyObject], headers: nil, success: { (response) in
                let statusCode = response?["statusCode"].intValue
                switch (statusCode!) {
                case 200:
                    success(response)
                default:
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            }) { (error) in
            }
    }
    // Delete project image
    
    func deleteProjectImage(_ imageID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
        APIManager.manager.deleteRequestJSON(DELETE_PROJECT_IMAGE(forPortfolioImageID: imageID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    
    // Edit Idea
    func editUploadIdea(forIdeaId ideaID: Int?, ideaName: String?, description: String?, fileType: String?, fileName: String?, fileSize: String?, base64: String?, IdeaTag: [AnyObject]?, attributeValues: String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
        let params = ["Idea": ["idea_name": ideaName!, "description": description!, "image": ["filename": fileName!, "filetype": fileType!, "base64": base64!]], "IdeaAttributeValue": ["attribute_value_id": attributeValues!], "IdeaTag": ["tag_id": IdeaTag!]]
        
        APIManager.manager.putRequestJSON(EDIT_IDEA(forIdeaID: ideaID!), parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    
    // MARK:- UnFollow
    func unFollow(forUnfollowrID followerID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.deleteRequestJSON(UNFOLLOW(forFollowID: followerID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        Toast.show(withMessage: SOMETHING_WRONG)
        }
    }
    
    // MARK:- Write A review
    func writeReview(_ userID: Int?, rated_by: Int?, rating: Float?, description: String?, title: String?, service_taken: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        let params = ["Rating": ["user_id": userID!, "rated_by": rated_by!, "rating": rating!, "description": description!, "title": title!, "service_taken": service_taken!]]
        
        APIManager.manager.postRequestJSON(WRITE_REVIEW, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- REMOVE IDEA PIN
    func removeIdeaPin(forIdeaID ideaID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.deleteRequestJSON(REMOVE_IDEA_PIN(forIDEAID: ideaID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
             Toast.show(withMessage: SOMETHING_WRONG)
        }
    }
    // MARK:- Set Follow
    func addFollow(forFollowerID followerID: Int?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        let params = ["Follow": ["follower_id": followerID!]]
        
        APIManager.manager.postRequestJSON(ADD_FOLLOW, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        failure(error)
        
        }
        
    }
    // MARK:- Influencer Like
    func addInfluencerLike(forUserID userID: Int?, influencerID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        let params = ["InfluencerLike": ["user_id": userID!, "influencer_id": influencerID!]]
        APIManager.manager.postRequestJSON(INFLUENCER_LIKE, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
        
    }
    
    // MARK:- Idea Like-
    func addIdeaLike(forUserID userID: Int?, IdeaID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        let params = ["IdeaLike": ["user_id": userID!, "idea_id": IdeaID!]]
        APIManager.manager.postRequestJSON(IDEA_LIKE, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            // Toast.show(withMessage: SOMETHING_WRONG)
        }
    }
    // MARK:- Portfolio Image Like
    func addPortfolioImageLike(forUserID userID: Int?, ImageID: String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        let params = ["PortfolioImageLike": ["user_id": userID!, "image_id": ImageID!]]
        APIManager.manager.postRequestJSON(PORTFOLIO_IMAGE_LIKE, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    // MARK:- Influencer Dislike
    func influencerDislike(forinfluencerID influencerID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.deleteRequestJSON(INFLUENCERDISLIKE(forInfluencerID: influencerID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    //MARK:-  Portfolio image Dislike
    func portfolioImageDislike(forPortfolioImageID imageID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.deleteRequestJSON(PORTFOLIOIMAGEDISLIKE(forPortfolioImageID: imageID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    
    // MARK- Idea Dislike
    func ideaDislike(forIdeaID ideaID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.deleteRequestJSON(IDEADISLIKE(forIdeaID: ideaID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
           // Toast.show(withMessage: SOMETHING_WRONG)
        }
    }
    
    // MARK:- Seeker Profile Edit
    func editSeekerProfileWith(forUserID userID: Int?, userName: String?, userContactnumber: String?, userAddress: String?, aboutMe: String?, userBirthDate: String?, zipCode:String?,cityID: Int?, stateID: Int?, prfileImageBase64: String?, backImage64: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
        let params = ["User": ["name": userName!, "contact_no": userContactnumber!, "about_me": aboutMe!, "birth_date": userBirthDate!,"zip":zipCode!,"city": cityID!, "state": stateID!, "display_profile": ["filename": "profile_imag.jpg","filesize": 25841,"base64": prfileImageBase64!],"cover_profile":["filename": "cover_imag.jpg","filesize": 25841,"base64": backImage64!]]]

        
       
        
        
        APIManager.manager.putRequestJSON(EDITSEEKERPROFILE(forUserID: userID!), parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
   // New Code
    
    // MARK:- Influencer List (Without passed latituted and longitued)
    func getInfluencerListWithoutLatLong(foruser UserType: String?, cityID: Int?, InfluencerType: String, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        let endPoint = "\(INFLUENCER_LIST2(forUser: InfluencerType))"
      
        APIManager.manager.getRequest(endPoint, headers: ["location-city-id": String(cityID!)], parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    
    
    // MARK:- Influencer List  (With passed latituted and longitued)
    func getInfluencerList(foruser UserType: String?, cityID: Int?, InfluencerType: String, lat: Double, lon: Double, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        
    //let  endPoint = "\(INFLUENCERS_LIST1(forUser: InfluencerType, influencerType: UserType!, lat: lat, lon: lon))"
        
        let  endPoint = "\(INFLUENCER_LIST1(forUser: InfluencerType, lat: lat, lon: lon))"
        
        APIManager.manager.getRequest(endPoint, headers: ["location-city-id": String(cityID!)], parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }

    
    
    /* Old Code
    
    // MARK:- Influencer List
    func getInfluencerList(foruser UserType: String?, cityID: Int?, InfluencerType: String, lat: Double, lon: Double, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
        
        var endPoint = ""
        if UserType == kInfluencer {
            endPoint = "\(INFLUENCER_LIST1(forUser: InfluencerType, lat: lat, lon: lon))"
        } else {
            //endPoint = "\(INFLUENCER_LIST)\(InfluencerType)&\(INFLUENCERS_LIST)\(UserType!)"
            endPoint = "\(INFLUENCERS_LIST1(forUser: InfluencerType, influencerType: UserType!, lat: lat, lon: lon))"
        }

        
        
        APIManager.manager.getRequest(endPoint, headers: ["location-city-id": String(cityID!)], parameters: nil, success: { (response) in
            let statusCode = response["statusCode"].intValue
            switch (statusCode) {
            case 200:
                              
            success(response: response)
                
                
            default:
                Toast.show(withMessage: response["statusText"].stringValue)
            }
        }) { (error) in
            failure(error: error)
        }
    }
 */
    
    // MARK:- Get InfluncerIdea List.
    func getIdeaListingWithUserID(forUserID userID: Int?, pageno: Int?, pageSize: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ())
    {
        APIManager.manager.getRequest(IDEALISTWITH(forUserID: userID!,pageNumber: pageno!,perPage: pageSize!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
        
    }
    // MARK:- GEt Incluncer Details.
    func getInfluencerDetails(forUserID userID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        
        APIManager.manager.getRequest(INFLUENCERDETAILS(forUserID: userID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- GEt All tags..
    func getTagsList(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(TAGS_LIST, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    // MARK:- get Skill List
    
    func getSkillList(_ success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(SKILLS_LIST, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK:- Get Attributes  (This Attributes gives workType value, and projectBudget )
    func getAttributes(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(ATTRIBUTES, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    func getAttributesForEditInfluncer(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(ATTRIBUTES_FOR_PROJECTS, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    // MARK:- GET NotiFications
    func getNotifications(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(NOTIFICATIONS, headers: ["access-from": "mobile"], parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- Report and  Abuse
    func reportAbuseWithTypeID(forTypeID typeID: Int?, abuse_type: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        let params = ["Abuse": ["type_id": typeID!, "abuse_type": abuse_type!,]]
        APIManager.manager.postRequestJSON(REPORT_ABUSE, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
            
        }) { (error) in
                 Toast.show(withMessage: SOMETHING_WRONG)
            failure(error)
        }
    }
    
    // MARK:- get About Us-
    func getAboutUS(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(ABOUT_US, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- get How its Work -
    func getHowItsWork(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(HOW_ITS_WORK, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
        }
    }
    
    // MARK:- Login With Facebook
    func loginWithWithSocialID(forSocialID socialID: String?, socailType: String?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
        let params = ["User": ["social_id": socialID!, "social_type": socailType!]]
        APIManager.manager.postRequestJSON(SOCIAL_LOGIN, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
            failure(error)
            
        }
    }

    // States List
    func getStates(_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        APIManager.manager.getRequest(STATE_LIST, headers: nil, parameters: nil, success: { (response) in
            
            
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                
                
                
            default: 
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
    

    // City List
    func getCityList(forStateID StateID: Int? ,success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()){
        //let params = ["state_id": StateID!]
        APIManager.manager.getRequest(CITY_LIST(forStateID: StateID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
              failure(error)
              Toast.show(withMessage: SOMETHING_WRONG)
        }
    }
// Logout Api
    func logoutWith(forUserID userID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
     APIManager.manager.putRequestJSON(LOGOUT(forUser:userID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                 Toast.show(withMessage: (response?["statusText"].stringValue)!)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
           Toast.show(withMessage: SOMETHING_WRONG)   
        }
        
    }
    
    
    // This API GEt User details
    func getUserDetails(forUserID userID: Int?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()){
        
        APIManager.manager.getRequest(USER_LIST_DETAILS(forUserId:userID!) , headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            failure(error)
            Toast.show(withMessage: SOMETHING_WRONG)
        }
    
    
    
    }
    
    
    
    // APi For Add , Delate , update Eduction. experience, traning
    // THIS Function Add Euction
    func addEductionWith(forDegreName degreeName:String?, streamName:String?, stateDate:String?, endDate:String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
       
        let params = ["UserEducation": ["degree": degreeName!, "stream": streamName!, "start_date":stateDate!,"end_date":endDate!]]
        
    
        
        APIManager.manager.postRequestJSON(ADD_EDUCTION, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
         Toast.show(withMessage: SOMETHING_WRONG)
            
        }
    
}
    // This Function Delete the Edcution
    func deleteEductionWith(forEductionID eductionID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
       
        APIManager.manager.deleteRequestJSON(DELETE_EDUCTION(forID: eductionID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
            default:
                  Toast.show(withMessage: SOMETHING_WRONG)
                //Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
         Toast.show(withMessage: SOMETHING_WRONG)
        }
    }

   // This Function Update the Eduction
    func updateEductionWith(forEductionID eductionID: Int?,degreeName:String?, streamName:String?, stateDate:String?, endDate:String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        let params = ["UserEducation": ["degree": degreeName!, "stream": streamName!, "start_date":stateDate!,"end_date":endDate!]]
        
        APIManager.manager.putRequestJSON(EDIT_EDUCTION(forID: eductionID!), parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
             Toast.show(withMessage: SOMETHING_WRONG)
        }
    
    
    }
  
   // Experience 
    // THIS Function Add Experience
    func addExperinceWith(forDegreName degreeName:String?, stateDate:String?, endDate:String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        
        let params = ["UserExperience": ["organisation_name": degreeName!, "start_date":stateDate!,"end_date":endDate!]]
        
     
        
        APIManager.manager.postRequestJSON(ADD_EXPERIENCE, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
            Toast.show(withMessage: SOMETHING_WRONG)
            
        }
        
    }
    
    // THIS Function delete Experience
    func deleteExperinceWith(forExperienceID experienceID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        
        APIManager.manager.deleteRequestJSON(DELETE_EXPERIENCE(forID: experienceID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
         Toast.show(withMessage: SOMETHING_WRONG)
        }
    
    }

    // THIS Function delete Experience
    func updateExperinceWith(forExperienceID experienceID: Int?, forDegreName degreeName:String?, stateDate:String?, endDate:String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
      let params = ["UserExperience": ["organisation_name": degreeName!, "start_date":stateDate!,"end_date":endDate!]]
      
  
        
        APIManager.manager.putRequestJSON(EDIT_EXPERIENCE(forID: experienceID!), parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            Toast.show(withMessage: SOMETHING_WRONG)
        }
    
    }
    
    
 
 // Traning
    

    // THIS Function Add Experience
    func addTraningWith(forDegreName degreeName:String?, stateDate:String?, endDate:String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        
        let params = ["UserTraining": ["training_name": degreeName!, "start_date":stateDate!,"end_date":endDate!]]
       
        
        
        APIManager.manager.postRequestJSON(ADD_TRANING, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
           Toast.show(withMessage: SOMETHING_WRONG)
            
        }
        
    }
    
    // THIS Function delete Experience
    func deleteTraningWith(forTraningID traningID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        
        APIManager.manager.deleteRequestJSON(EDIT_TRANING(forID: traningID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
          Toast.show(withMessage: SOMETHING_WRONG)
        }
        
    }
    
    // THIS Function update Experience
    func updateTraningWith(forTraningID traningID: Int?, forDegreName degreeName:String?, stateDate:String?, endDate:String?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        let params = ["UserTraining": ["training_name": degreeName!, "start_date":stateDate!,"end_date":endDate!]]
        
        APIManager.manager.putRequestJSON(EDIT_TRANING(forID: traningID!), parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            Toast.show(withMessage: SOMETHING_WRONG)
        }
        
    }

 // This Function Add A Certificate
    func addCertificateWith(forTitle title: String?, imageData:[AnyObject]?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        let params = ["UserCertification[title]":title!]
        APIManager.manager.uploadCertificateFileMultipartFormDataWithParams(ADD_CERTIFICATE , headers: ["upload-from": "mobile"], uploadImageList: imageData!, fileName: "filetype", parameters: params as [String : AnyObject], success: { (response) in
            
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }

    }
   // Update Certificate
    
    func updateCertificateWith(forCertificateID certificateID: Int?, title: String?, imageData:[AnyObject]?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
    // let params = ["title": title!]
        
         let params = ["UserCertification[title]":title!]
        
       // let JsonFormattedData = JSON(params).rawString()!
       // let postData = ["UserCertification": JsonFormattedData]
        APIManager.manager.uploadCertificateFileMultipartFormDataWithParams(UPDATE_CERTIFICATE(forID: certificateID!) , headers: ["upload-from": "mobile"], uploadImageList: imageData!, fileName: "filetype", parameters: params as [String : AnyObject], success: { (response) in
            
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    
    }
    
    // THIS Function delete Experience
    func deleteCertificateWith(forCertificateID certificateID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        
        APIManager.manager.deleteRequestJSON(DELETE_CERTIFICATE(forID: certificateID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            Toast.show(withMessage: SOMETHING_WRONG)
        }
        
    }
    
    // THIS Function delete Experience
    func deleteSkillWith(forSkillsID skillsID: Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
        
        APIManager.manager.deleteRequestJSON(DELETE_SKILLS(forID: skillsID!), parameters: nil, headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            Toast.show(withMessage: SOMETHING_WRONG)
        }
        
    }
// This Function get All Calculator attributes 
    func getAllFurnitureTypeAttributes (_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(FURNITURE_ATTRIBUTES, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
         Toast.show(withMessage: SOMETHING_WRONG)
        
        }
    }
    
    
    func getAllCalculatorTypeAttributes (_ success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(CALCULATOR_ATTRIBUTES, headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
         Toast.show(withMessage: SOMETHING_WRONG)
        }
    }

 // This Function calculate the single  vanner Value With the halp of serface
    func getAllVannerTypeAttributes (forSerfaceID serfaceID:Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(VANNER_ATTRIBUTES(forSerfaceID: serfaceID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        
        }
    }
 
    // This Function calculate the single Polish Value With the halp of serface

    func getAllPolishTypeAttributes (forSerfaceID serfaceID:Int?, success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()) {
        APIManager.manager.getRequest(POLISH_ATTRIBUTES(forSerfaceID: serfaceID!), headers: nil, parameters: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
        }
    }
   // This Function calculate Cost
    func calculatorCostOfAttributes(forFurnitureSize furniturePrice:String?, surfacePrice:String?, plyWoodPrice:String?,fittingPrice:String?,polishPrice:String?,success: @escaping (_ response: JSON?) -> (), failure: (_ error: NSError?) -> ()){
    
    let params = ["size":furniturePrice!,"surface": surfacePrice!, "plyPrice":plyWoodPrice!,"fitting":fittingPrice!,"polish":polishPrice!]

        APIManager.manager.postRequestJSON(CALCULATOR_ATTRIBUTES_COST, parameters: params as [String : AnyObject], headers: nil, success: { (response) in
            let statusCode = response?["statusCode"].intValue
            switch (statusCode!) {
            case 200:
                success(response)
                if response?["statusText"].stringValue == "No result found" {
                    Toast.show(withMessage: (response?["statusText"].stringValue)!)
                }
            default:
                Toast.show(withMessage: (response?["statusText"].stringValue)!)
            }
        }) { (error) in
            
            Toast.show(withMessage: SOMETHING_WRONG)
            
        }
        
     
        
    }
    
}

