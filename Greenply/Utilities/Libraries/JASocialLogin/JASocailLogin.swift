//
//  JASocailLogin.swift
//  GreenPlay
//
//  Created by Jitendra on 05/09/16.
//  Copyright © 2016 Jitendra. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
class JASocailLogin: NSObject {
  

}

extension JASocailLogin
{
    class func JALoginWithFacebook(delegate:UIViewController ,  sucessData:@escaping (_ sucessData: AnyObject)->Void ,  failure:(_ failure: NSError)->Void)
    {
        
         let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: delegate) { (result, error) -> Void in
            if (error != nil){
            sucessData(false as AnyObject)
            }else if (result?.isCancelled)! {
               sucessData(false as AnyObject)
            }
            else{
             let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData({ (FBuserData) -> Void in
                     sucessData(FBuserData)
                    })
                   
                }
            }
            }
        
    
    }
    
    class func getFBUserData(_ FBuserData:@escaping (_ FBuserData: AnyObject)->Void) {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    FBuserData(result as AnyObject)
                    
                }
            })
        }
    }
    
  
    
}


