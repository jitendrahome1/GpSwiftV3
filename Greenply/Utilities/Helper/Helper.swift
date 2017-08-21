//
//  Helper.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import CoreLocation
import JTMaterialSpinner
class Helper: NSObject {
	var deviceID: String?
	var UserID: String?
	var UserType: String?
    var isGoogleSignIn = false
    var spinnerView =  JTMaterialSpinner()
    var navigationController: UINavigationController!
	static let sharedClient = Helper()
	fileprivate override init() { }

    func readPlist(forName name: String?) -> [AnyObject] {
        let url = Bundle.main.url(forResource: name, withExtension: "plist")!
        let array = NSMutableArray(contentsOf: url)?.mutableCopy() as? [AnyObject]
        
        var plistArray = [AnyObject]()
        for item in array! {
            plistArray.append(item)
        }
        
        return plistArray
    }
    
    func dateToLong(_ date:Date) -> Double {
        let timeInSeconds : TimeInterval  = date.timeIntervalSince1970
        return timeInSeconds
    }
    
    // MARK:- Check User Login In OR Not Function..
    func checkUserAlredyLogin(inViewControler presentViewController: UIViewController, isLogin: (_ isLogin: Bool?) -> ()) {
            if INTEGER_FOR_KEY(kUserID) != 0 {
                isLogin(true)
            }
            else {
                
                presentViewController.present(UIAlertController.showStandardAlertWith(kAppTitle, alertText: WANT_TO_LOGIN, positiveButtonText: TEXT_YES, negativeButtonText: TEXT_NO, selected_: { (index) in
                    if index == 1 {
                        let loginControllerNavigation = loginStoryboard.instantiateViewController(withIdentifier: "LoginNavigationalController") as! UINavigationController
                        presentViewController.present(loginControllerNavigation, animated: true, completion: nil)
                    }
                }), animated: true, completion: nil)
                
            }
        }
 
    // Show Simale Alert 
    
    func showAlertView(inViewControler presentViewController: UIViewController, alertMessge:String?, indexValue: @escaping (_ successIndex: Int?) -> ()){
        presentViewController.present(UIAlertController.showStandardAlertWith(kAppTitle, alertText: alertMessge!, positiveButtonText: TEXT_YES, negativeButtonText: TEXT_NO, selected_: { (index) in
            if index == 1 {
              indexValue(index)
            }
        }), animated: true, completion: nil)
    }
    
    // Present Login view controller
    func presentLoginView(withIndexValue indexValue: Int?){
      
        if(indexValue == 1){
        let loginControllerNavigation = loginStoryboard.instantiateViewController(withIdentifier: "LoginNavigationalController") as! UINavigationController
        
          NavigationHelper.helper.contentNavController!.present(loginControllerNavigation, animated: true, completion: nil)
            
        
               // presentViewController.presentViewController(loginControllerNavigation, animated: true, completion: nil)
            }
      
    }
    // Mark:- Check Null Value
    func checkNullValue(_ pStringdata: AnyObject?, nillStringReplaceWith: String?)->AnyObject{
        var strResult: AnyObject = "" as AnyObject
        if let pResult = pStringdata{
            strResult = pResult
        }
        else{
            strResult = nillStringReplaceWith! as AnyObject
        }
        return strResult
    }
   //Mark:- Calculating Distance between two coordinates
    func distanceBetweenTwoLocations(_ sourceLatitude: Double? , sourceLongitude: Double?, result:@escaping (_ result: Double)->()){
     
     CurrentLocation.sharedInstance.fetchCurrentUserLocation(onSuccess: { (latitude, longitude) in
        let myLocation = CLLocation(latitude: latitude, longitude: longitude)
        let myBuddysLocation = CLLocation(latitude: sourceLatitude!, longitude: sourceLongitude!)
        let distance = myLocation.distance(from: myBuddysLocation) / 1000
         let roundedTwoDigit = distance.roundedTwoDigit
        result(roundedTwoDigit)
        }) { (message) in
            
        }
       

    }
    
    
   //Comparing NSDates  
    
    func ComparingTwoNSDates(forTwoDate twoDate:String?, fromDate: String?, result:(_ pResult:String?)->()){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
      let cToDate = dateFormatter.date(from: twoDate!)
        let cFromDate = dateFormatter.date(from: fromDate!)
        let order = (Calendar.current as NSCalendar).compare(cToDate!, to: cFromDate!,
                                                             toUnitGranularity: .hour)
        switch order {
        case .orderedDescending:
              result("DESCENDING")
        case .orderedAscending:
           result("ASCENDING")
        case .orderedSame:
       result("SAME")
        }
      
    }
    // MARk:- This Function Comparing two arrars and return common element form Array
    func arrayOfCommonElements <T, U> (_ lhs: T, rhs: U) -> [T.Iterator.Element] where T: Sequence, U: Sequence, T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
        var returnArray:[T.Iterator.Element] = []
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    returnArray.append(lhsItem)
                }
            }
        }
        return returnArray
    }
    
  
    /*
    // MARk:- This Function Comparing two arrars and return Non common element form Array
    func arrayOfNonCommonElements <T, U where T: SequenceType, U: SequenceType, T.Generator.Element: Equatable, T.Generator.Element == U.Generator.Element> (lhs: T, rhs: U) -> [T.Generator.Element] {
        
        var returnArray:[T.Generator.Element] = []
        var found = false
        
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    found = true
                    break
                }
            }
            
            if (!found){
                returnArray.append(lhsItem)
            }
            
            found = false
        }
//        for rhsItem in rhs {
//            for lhsItem in lhs {
//                if rhsItem == lhsItem {
//                    found = true
//                    break
//                }
//            }
//            
//            if (!found){
//                returnArray.append(rhsItem)
//            }
//            
//            found = false
//        }
        return returnArray
    }
 */
    
    
    
    
    
//    
//     // MARk:- This Function Comparing two arrars and return Non common element form Array
//     func arrayOfNonCommonElements <T, U where T: SequenceType, U: SequenceType, T.Generator.Element: Equatable, T.Generator.Element == U.Generator.Element> (lhs: T, rhs: U) -> [T.Generator.Element] {
//     
//        var matchArray:[T.Generator.Element] = []
//         var noMatchArray:[T.Generator.Element] = []
//     var found = false
//    
//     for lhsItem in lhs {
//     for rhsItem in rhs {
//     if lhsItem == rhsItem {
//     
//    matchArray.append(lhsItem)
//   
//     }else{
//        
//        }
//     }
//     
//     if (!found){
//     noMatchArray.append(lhsItem)
//     }
//     
//     found = false
//     }
//     //        for rhsItem in rhs {
//     //            for lhsItem in lhs {
//     //                if rhsItem == lhsItem {
//     //                    found = true
//     //                    break
//     //                }
//     //            }
//     //
//     //            if (!found){
//     //                returnArray.append(rhsItem)
//     //            }
//     //
//     //            found = false
//     //        }
//     return matchArray
//     }
// 
    
    
    
    

    func arrayOfNonCommonElements(_ array1:[Int] , array2:[Int]) -> ([AnyObject],[AnyObject])
    {
      var arrNoMatch = [Int]()
    var arrMatch = [Int]()
        arrNoMatch = array2.filter { !array1.contains($0) }
 //arrNoMatch = array1.filter(!array2.contains)
        
        arrMatch = array1.filter { array2.contains($0) }
        
//        let set1 = Set(array1)
//        let set2 = Set(array2)
//        
//     arrNoMatch = Array(set1.subtract(set2))
      
        return (arrMatch as [AnyObject], arrNoMatch as [AnyObject])
    }
   
    
    
    
    
    
    // Image blur
    func imageBlurWith(forImageView imageView: UIImageView?){
        
    
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
        
       let blurView = UIVisualEffectView(effect: darkBlur)
       blurView.frame = imageView!.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
     imageView!.addSubview(blurView)
        
        
       
      
        
    }
    
    // MARk:- Show Loader
    
    func showLoaderWith(inview inView: UIView){
        let win: UIWindow = UIApplication.shared.delegate!.window!!
        inView.isUserInteractionEnabled = false
        spinnerView.frame.size = CGSize(width: 50, height: 50)
        spinnerView.center =  win.center
        win.addSubview(spinnerView)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.green.cgColor
        spinnerView.beginRefreshing()
    }
    func removeLoader(inview inView: UIView){
        inView.isUserInteractionEnabled = true
        spinnerView.endRefreshing()
    }
    
    // Convert String Date To TimeStamep
    func dateStringToTimeStampFormat(dateformat Pdate: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: Pdate)
        if let _ = date{
            return date!.timeIntervalSince1970 * 1000
        }else{
            return Date().timeIntervalSince1970
        }
        
        
           }
    
}


extension Double{
    
    var roundedTwoDigit:Double{
        
        return Double((100*self)/100)
        
    }
    mutating  func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
