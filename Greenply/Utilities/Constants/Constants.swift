//
//  Constants.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import Foundation
import UIKit

let SYSTEM_VERSION = UIDevice.current.systemVersion

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let MAIN_WINDOW = UIApplication.shared.windows.first

func IS_OF_4_INCH() -> Bool {
	switch UIDevice.current.modelName {
	case .iPhone5, .iPhone5S, .iPhone5C, .iPhoneSE:
		return true
	default:
		return false
	}
}



// GOOGLE LOCATION SEARCH KYE
let GOOGLE_MAP_KEY = "AIzaSyDZqJOc5iSvCMkNStGStX0_KioP1yB4E3M" // THIS KYE USER ONLY FOR TESTING USED CHANGE WHEN YOU GET CLIENT GOOGLE AP KYE.
let GOOGLE_BASE_URL_STRING = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
//let  GOOGLE_BASE_URL_STRING = "https://maps.googleapis.com/maps/api/geocode/json?components=country:IN"
//MARK:- User Type
let kSeeker = "seeker"
let kInfluencer = "influencer"
// Image Like And Un Like
let kImageLikeSelected = "ProjectDetailsLikeSelect"
let kImageLikeDeselected = "ProjectLikeDeselected"

// Image Pinned Selected or DeSeleted
let kImagePinnedSelected = "ProjectPinSelected"
let kImagePinnedDselected = "ProjectPinDeselected"

// FeveritIocn Selected And Dsleted
let kFevImageSeleted = "FeveritIcon"
let kFevImageDeSeleted = "FeveritIconDeseleted"

// Header Button Type

let kPLusButtonType = "addPlus"
let kMenuButtonType = "addMenu"

//EmailExists
let kEmailExists = "Email already exists"

//MARK: API Endpoints
let LOGIN = "/users/login"
let USER_REGISTRATION = "/users"
let FORGOT_RESET_PASSWORD = "/users/forgot-password"
let DASHBOARD = "/dashboards"
//let IDEA_LIST = "/ideas"
func IDEA_LIST(forPageno pageno: Int, pageSize: Int) -> String {
    return "/ideas?page=\(pageno)&per-page=\(pageSize)"
}
let WRITE_COMMENT = "/comments"
let INFLUENCER_TYPE = "/influencers"
let FILTER_ATTRIBUTE = "/attributes?AttributesSearch[moduleType]=user"
//let INFLUENCER_FILTER = "/users?UserSearch[user_type]=influencer"
func MY_PINNED(forUser categoryID: Int) -> String {
    return "/pins/\(categoryID)"
}
let MY_PIN_LIST = "/pins/my-pins"
let WRITE_REVIEW = "/ratings"
let ADD_IDEA_PIN = "/pins"
let INFLUENCER_LIKE = "/influencerlikes"
let IDEA_LIKE = "/idealikes"
let PORTFOLIO_IMAGE_LIKE = "/portfolioimagelikes"
let FOLLOWS_LIST = "/follows"
let ATTRIBUTES_FOR_PROJECTS = "/attributes?expand=attributeValues"
let ADD_IDEAS = "/ideas"
let NOTIFICATIONS = "/notifications"
let ABOUT_US = "/pages/page/about-us"
let HOW_ITS_WORK = "/pages/page/how-it-works"
let ADD_FOLLOW = "/follows"
let PORTFOLIO_LIKE = "/portfoliolikes"
let INFLUENCER_LIST = "/users?UserSearch[user_type]="
let INFLUENCERS_LIST = "&UserSearch[influencer_type]="
let PORTFOLIO_LIST = "/portfolios"
let TAGS_LIST = "/tags"
let SKILLS_LIST = "/skills"
let UPLOAD_PROJECT = "/portfolios"
let STATE_LIST = "/states"

let ATTRIBUTES = "/attributes?AttributesSearch[moduleType]=portfolios"
let REPORT_ABUSE = "/abuses"
let SOCIAL_LOGIN = "/users/social-login"
let  ADD_EDUCTION = "/user-educations"
let  ADD_EXPERIENCE = "/user-experiences"
let  ADD_TRANING =  "/user-trainings"

let  ADD_CERTIFICATE = "/user-certifications"

let FURNITURE_ATTRIBUTES = "/furniture-types"
let CALCULATOR_ATTRIBUTES = "/calculator-attributes"
let  CALCULATOR_ATTRIBUTES_COST =  "/calculator-attributes/calculate"

func INFLUENCER_LIST1(forUser userType: String, lat: Double, lon: Double) -> String {
    return "/users?UserSearch[user_type]=\(userType)&UserSearch[latitude]=\(lat)&UserSearch[longitude]=\(lon)&"
}



//func INFLUENCERS_LIST1(forUser userType: String, influencerType: String, lat: Double, lon: Double) -> String {
//    return "/users?UserSearch[user_type]=\(userType)&UserSearch[influencer_type]=\(influencerType)&UserSearch[latitude]=\(lat)&UserSearch[longitude]=\(lon)&"
//}
func INFLUENCER_LIST2(forUser userType: String) -> String {
    return "/users?UserSearch[user_type]=\(userType)"
}

func VANNER_ATTRIBUTES(forSerfaceID serfaceID: Int) -> String {
    return "/calculator-attributes?CalculatorAttributeSearch[type]=surface&CalculatorAttributeSearch[parent]=\(serfaceID)&CalculatorAttributeSearch[is_dependent]=0"
}

func POLISH_ATTRIBUTES(forSerfaceID serfaceID: Int) -> String {
    return "/calculator-attributes?CalculatorAttributeSearch[type]=surface&CalculatorAttributeSearch[parent]=\(serfaceID)&CalculatorAttributeSearch[is_dependent]=1"
}







func CHANGE_PASSWORD(forUser userID: Int) -> String {
	return "/users/\(userID)"
}
func BECOME_INFLUENCER(forUser userID: Int) -> String {
	return "/users/\(userID)"
}
func EDIT_INFLUENCER(forUserId userID: Int) -> String {
	return "/users/\(userID)"
}
func USER_DETAILS(forUserId userID: Int) -> String {
    return "/users/\(userID)"
}
func CITY_LIST(forStateID stateID: Int) -> String {
    return "/cities?CitySearch[state_id]=\(stateID)"
}
func LOGOUT(forUser userID: Int) -> String {
    return "/users/\(userID)/logout"
}
func USER_LIST_DETAILS(forUserId userID: Int) -> String {
	return "/users/\(userID)"
}

// EDUCTION

func EDIT_EDUCTION(forID eductionID : Int)->String{
   return "/user-educations/\(eductionID)"
}
func DELETE_EDUCTION(forID eductionID : Int)->String{
    return "/user-educations/\(eductionID)"
}
// Experience

func EDIT_EXPERIENCE(forID PID : Int)->String{
    return "/user-experiences/\(PID)"
 
   
}
func DELETE_EXPERIENCE(forID PID : Int)->String{
    return "/user-experiences/\(PID)"
}
// Traning


func EDIT_TRANING(forID PID : Int)->String{
    return "/user-trainings/\(PID)"
}
func DELETE_TRANING(forID PID : Int)->String{
    return "/user-trainings/\(PID)"
}
// Certificate

func UPDATE_CERTIFICATE(forID PID : Int)->String{
    return "/user-certifications/update-certificate/\(PID)"
}

func DELETE_CERTIFICATE(forID PID : Int)->String{
    return "/user-certifications/\(PID)"
}

func DELETE_SKILLS(forID PID : Int)->String{
    return "/user-skills/\(PID)"
}



//func RATE_REVIEW(forUser userID: Int) -> String {
//	return "/ratings/user-rating/\(userID)?lat=29.46786&long=-98.53506"
//}
func RATE_REVIEW(forUser userID: Int) -> String {
	return "/ratings/user-rating/\(userID)"
}

func VERIFY_FORGOT_PASSWORD_OTP(forUser userID: Int) -> String {
	return "/users/\(userID)/otp-password-verify"
}
func VERIFY_REGISTRATION_OTP(forUser userID: Int) -> String
{
	return "/users/\(userID)/otp-verify"
}
func RESEND_OTP(forUser userID: Int) -> String
{
	return "/users/\(userID)/resend-otp"
}
func IDEA_DETAILS(forIdeaID ideaID: Int) -> String {
	return "/ideas/\(ideaID)?expand=user,comments"
}
func REMOVE_IDEA_PIN(forIDEAID ideaID: Int) -> String {
	return "/pins/\(ideaID)"
}
func UNFOLLOW(forFollowID followerID: Int) -> String {
	return "/follows/\(followerID)"
}
func INFLUENCERDISLIKE(forInfluencerID influencerID: Int) -> String {
	return "/influencerlikes/\(influencerID)"
}
func PORTFOLIOIMAGEDISLIKE(forPortfolioImageID imageID: Int) -> String {
	return "/portfolioimagelikes/\(imageID)"
}
func IDEADISLIKE(forIdeaID ideaID: Int) -> String {
	return "/idealikes/\(ideaID)"
}
func EDITSEEKERPROFILE(forUserID ideaID: Int) -> String {
	return "/users/\(ideaID)"
}
func MY_PORTFOLIO(forUser userID: Int?, pageNumber: Int, perPage: Int) -> String {
// return "/portfolios/?PortfolioSearch[user_id]=\(userID)&page=\(pageNumber)&per-page\(perPage)"
	return "/portfolios?PortfolioSearch[user_id]=\(userID!)&page=\(pageNumber)&per-page=\(perPage)"


}

func IDEALISTWITH(forUserID userID: Int?,pageNumber: Int, perPage: Int) -> String {
    return "/ideas?IdeaSearch[user_id]=\(userID!)&page=\(pageNumber)&per-page=\(perPage)"
    
    
}

func PORTFOLIO_DETAILS(forPortFolioID portFolioID: Int?) -> String {
	return "/portfolios/\(portFolioID!)?expand=user"
}

func INFLUENCERDETAILS(forUserID userID: Int?) -> String {
	return "/users/\(userID!)"

}
func EDIT_IDEA(forIdeaID ideaID: Int?) -> String {
	return "/ideas/\(ideaID!)"
}
func EDIT_PORJECT(forProjectID projectID: Int?) -> String {
 
return "/portfolios/portfolio-update/\(projectID!)"
 
}

func EDIT_PROJECT_IMAGE(forPortfolioImageID ImageID: Int?) -> String {
    return "/portfolioimages/\(ImageID!)"
    
   
}
func DELETE_PROJECT_IMAGE(forPortfolioImageID ImageID: Int?) -> String {
    return "/portfolioimages/\(ImageID!)"
    
}


// MARK: Storyboard
let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
let otherStoryboard: UIStoryboard = UIStoryboard(name: "Others", bundle: nil)
let UnUsedStoryboard: UIStoryboard = UIStoryboard(name: "UnUsed", bundle: nil)
// MARK:- Font
let FONT_NAME = "Roboto-Regular"
let kTableViewBackgroundImage = "BackgroundImage"
// Header Button Image Name
let kSearchButton = "SearchButton"
let kFilterBttton = "FilterBttton"
let kPluseImage = "HeaderPlus"
let kMenuImage = "MenuIcon"
let kHeaderTickImage = "HeaderTick"

// Add plus Button.
let kPluseButton = "PlusButton"
let KMenuButton = "menuButton"
let KHeaderTickButton = "headerTick"
// MARK:- APP Text
let APP_TITLE = "Greenply"
//MARK:- Message Successfully
let PROFILE_SUCCESS = "Profile updated successfully"

// MARK: User Defaults Keys
let kStateId = "stateId"
let kCityId = "cityId"
let kSeletedState = "StateName"
let kSeletedCity = "CityName"


let kFirstTime = "firstTime"
let kUserID = "userID"
let kToken = "token"
let kUserName = "userName"
let kUserType = "userType"
let kInfluencerType = "influencerType"
let kUserCity = "city"
let kUserContactNumber = "UserContactNumber"
let kUserAddress = "userAddress"
let kUserEmail = "userEmail"
let kUserStateName = "stateName"
let kUserStateID = "stateID"
let kUserLoginDetails = "userLoginDetails"
let kUserCityName = "cityName"
let kUserCityID = "cityID"

let kUserAboutUS = "aboutUs"
let kUserBirthDate = "birthDate"
let kUserTypeStatus = "userTypeStatus"
let kUserSocialID = "socialID"
let kUserZipCode = "zipCode"
let kUserTotalNotification = "totalNotification"
let kSocailTypeFacebook = "facebookLogin"
let kSocailTypeGmail = "Google"
// REport AND Abus
let kReportAbusIdea = "idea"
let kReportAbusComment = "comment"
let kReportAbusPortfolio = "portfolio"
let kReportAbusUser = "user"

let kDisplayProfile = "profileImage"
let kCoverProfile = "coverImage"
// Report abus Image

let mReportAlredy = "You've already submitted a report for this item"

let kReportAbusGreenImage = "ProjectDetailsAlertIconGreen"
let kReportAbusRedImage = "ProjectDetailsAlertIcon"

//Experience
let EXP_NAME = "OrganizationName"
let EXP_STRT_DATE = "OrgStartDate"
let EXP_END_DATE = "OrgEndDate"

//Training
let TR_NAME = "TrainingName"
let TR_STRT_DATE = "TrStartDate"
let TR_END_DATE = "TrEndDate"

//Education
let EDU_DEGREE = "EduDegree"
let EDU_START_DATE = "EduStartDate"
let EDU_END_DATE = "EduEndDate"
let EDU_STREAM = "EduStream"

let CERTIFICATES = "Certificates"

// ENTITY NAME
let ENTITY_STATE = "StateInfo"

func IS_IPAD() -> Bool {

	switch UIDevice.current.userInterfaceIdiom {
	case .phone: // It's an iPhone
		return false
	case .pad: // It's an iPad
		return true
	case .unspecified: // undefined
		return false
	default:
		return false
	}
}

func SET_OBJ_FOR_KEY(_ obj: AnyObject, key: String) {
	UserDefaults.standard.set(obj, forKey: key)
    UserDefaults.standard.synchronize()
}

func OBJ_FOR_KEY(_ key: String) -> AnyObject? {
	if UserDefaults.standard.object(forKey: key) != nil {
		return UserDefaults.standard.object(forKey: key)! as AnyObject?
	}
	return nil
}



func SET_INTEGER_FOR_KEY(_ integer: Int, key: String) {
	UserDefaults.standard.set(integer, forKey: key)
}

func INTEGER_FOR_KEY(_ key: String) -> Int? {
	return UserDefaults.standard.integer(forKey: key)
}

func SET_FLOAT_FOR_KEY(_ float: Float, key: String) {
	UserDefaults.standard.set(float, forKey: key)
}

func FLOAT_FOR_KEY(_ key: String) -> Float? {
	return UserDefaults.standard.float(forKey: key)
}

func SET_BOOL_FOR_KEY(_ bool: Bool, key: String) {
	UserDefaults.standard.set(bool, forKey: key)
}

func BOOL_FOR_KEY(_ key: String) -> Bool? {
	return UserDefaults.standard.bool(forKey: key)
}

func REMOVE_OBJ_FOR_KEY(_ key: String) {
	UserDefaults.standard.removeObject(forKey: key)
}

func UIColorRGB(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor? {
	return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}
func UIBorderColor() -> UIColor {
	return UIColor(red: 212.0 / 255.0, green: 212.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
}

func UIColorRGBA(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor? {
	return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func FIRST_WINDOW() -> AnyObject? {
	return UIApplication.shared.windows.first!
}

func APP_DELEGATE() -> AppDelegate? {
	return UIApplication.shared.delegate as? AppDelegate
}

func SWIFT_CLASS_STRING(_ className: String) -> String? {
	return "\(Bundle.main.infoDictionary!["CFBundleName"] as! String).\(className)";
}

func PRIMARY_FONT(_ size: CGFloat) -> UIFont? {
	return UIFont(name: FONT_NAME, size: size)
}

//func SECONDARY_FONT(size: CGFloat) -> UIFont? {
// return UIFont(name: "Roboto-Regular", size: size)!
//}

/*
 if #available(iOS 9.0, *)
 {
 //System version is more than 9.0
 }
 else
 {

 }
 */
