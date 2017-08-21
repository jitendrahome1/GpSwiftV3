//
//  AppDelegate.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//+0 UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
        ////
		UIImageView.configureCache(withMemoryCapacity: 100_00_000, andPreferredMemoryAfterPurge: 60_00_000)

		UINavigationBar.appearance().barTintColor = UIColorRGB(57, g: 181, b: 74)
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().tintColor = UIColor.white // UIColorRGB(19, g: 150, b: 199)
		UIBarButtonItem.appearance().tintColor = UIColor.white
       
        UIApplication.shared.applicationIconBadgeNumber = 0
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        self.startMonitoringNetwork()
    
        self.pushToDashboard()
       
        if OBJ_FOR_KEY(kFirstTime) == nil {
            SET_OBJ_FOR_KEY(1 as AnyObject, key: kFirstTime)      
        }
        
		if OBJ_FOR_KEY(kToken) != nil {
			APIManager.manager.header += ["access-token": "\(OBJ_FOR_KEY(kToken)!)"]
			Globals.sharedClient.userID = INTEGER_FOR_KEY(kUserID)
		}
        
        // MARk:- GET Current Location
        CurrentLocation.sharedInstance.fetchCurrentUserLocation(onSuccess: { (latitude, longitude) in
            debugPrint("Current Lat==> \(latitude)")
            Globals.sharedClient.lat = latitude
            Globals.sharedClient.lon = longitude
            }) { (message) in
        }
		// Image Code
		return true
	}
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        if Helper.sharedClient.isGoogleSignIn {
            return GIDSignIn.sharedInstance().handle(url,
                                                        sourceApplication: sourceApplication,
                                                        annotation: annotation)
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
        CDSpinner.hide()
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
          UIApplication.shared.applicationIconBadgeNumber = 0
        	
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}
	// MARK: - Device Token
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

		let characterSet: CharacterSet = CharacterSet(charactersIn: "<>")

		let deviceTokenString: String = (deviceToken.description as NSString)
			.trimmingCharacters(in: characterSet)
			.replacingOccurrences(of: " ", with: "") as String
		Helper.sharedClient.deviceID = deviceTokenString
		debugPrint(deviceTokenString)
	}
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn’t register: (error)")
    }
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]){
        if INTEGER_FOR_KEY(kUserID) != 0{
            UIApplication.shared.applicationIconBadgeNumber = 0
            // user is login then, open a notification view controller.
            let notiVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: NotificationViewController())) as! NotificationViewController
            
            	NavigationHelper.helper.contentNavController?.pushViewController(notiVC, animated: true)
            
        }
    }
    
    // MARk:- Move To View Controller
    
 
    
    

	func pushToDashboard() {
		let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
        let rightViewController = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MenuViewController.self)) as! MenuViewController
		let slideMenuController = SlideMenuViewController(mainViewController: mainViewController, rightMenuViewController: rightViewController)
		slideMenuController.automaticallyAdjustsScrollViewInsets = true
		slideMenuController.removeRightGestures()
		NavigationHelper.helper.navController = mainViewController
  
		UIApplication.shared.windows.first!.rootViewController = slideMenuController
	}
    // this function just MonitoringNetwork
    func startMonitoringNetwork(){
       
      if APIManager.manager.isReachable(){
        CurrentLocation.sharedInstance.fetchCurrentUserLocation(onSuccess: { (latitude, longitude) in
            debugPrint("Current Lat==> \(latitude)")
            Globals.sharedClient.lat = latitude
            Globals.sharedClient.lon = longitude
        }) { (message) in
        }
           debugPrint("network is available")
      }else{
        debugPrint("No NetWork")
        }
    }
    
    
	// MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named "in.co.indusnet.Greenply" in the application's documents Application Support directory.
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[urls.count - 1]
	}()

	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = Bundle.main.url(forResource: "Greenply", withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}()

	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
		// The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
		} catch {
			// Report any error we got.
			var dict = [String: AnyObject]()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
			dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

			dict[NSUnderlyingErrorKey] = error as NSError
			let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
			// Replace this with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
			abort()
		}

		return coordinator
	}()

	lazy var managedObjectContext: NSManagedObjectContext = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				abort()
			}
		}
	}
}

