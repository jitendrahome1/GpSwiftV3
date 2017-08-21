//
//  GPAPIManager.swift
//  Greenply
//
//  Created by Jitendra on 9/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import Alamofire
import Timberjack
import SwiftyJSON

class APIManager: Alamofire.SessionManager {

	static let manager: APIManager = {
		let configuration = Timberjack.defaultSessionConfiguration()
		let manager = APIManager(configuration: configuration)
    
		return manager
	}()

	fileprivate let baseURL = "http://52.6.251.159/~demoecom/greenply/api/web/v1"
	fileprivate static let apiKey = ""
    private let parameterEncoding: ParameterEncoding = JSONEncoding() as ParameterEncoding
	internal var header: [String: String] = ["Content-Type": "application/json"]

	func cancelAllTaskExcluding(tasks cancelTasks: [String]) {
		self.session.getTasksWithCompletionHandler
		{
			(dataTasks, uploadTasks, downloadTasks) -> Void in
			for task in dataTasks as [URLSessionTask] {
				if !cancelTasks.contains((task.currentRequest?.url?.description)!) {
					task.cancel()
				}
			}
		}
	}

    
	// MARK: Reachability Check
	 func isReachable() -> (Bool) {
		let network = NetworkReachabilityManager()
		network?.startListening()
        
		if network?.isReachable ?? false {
			if ((network?.isReachableOnEthernetOrWiFi) != nil) {
				return true
			} else if (network?.isReachableOnWWAN)! {
                self.moveToNetWorkConnectionsVC()
				return true
			}
		}
		else {
             self.moveToNetWorkConnectionsVC()
			return false
		}
		return false
	}
// MARK:- No Reachable View Controller 
    
    func moveToNetWorkConnectionsVC(){
        let noNetWorkVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: NoNetWorkViewController())) as! NoNetWorkViewController
        DispatchQueue.main.async(execute: {
            Helper.sharedClient.removeLoader(inview: noNetWorkVC.view);
          
        })
        NavigationHelper.helper.contentNavController?.present(noNetWorkVC, animated: true, completion: nil)
        
        noNetWorkVC.didTapRetry = {(sender) in
            
            if APIManager.manager.isReachable(){
                NavigationHelper.helper.contentNavController?.dismiss(animated: true, completion: nil)
            } else {
                
            }
        }
    }
	func postRequestJSON(_ endPoint: String, parameters: [String: AnyObject]?, headers: [String: String]?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
		defer {
		}
		if isReachable() {
            
			if headers != nil {
				header += headers!
			}

			APIManager.manager.cancelAllTaskExcluding(tasks: [baseURL + DASHBOARD])

			CDSpinner.show()
			 APIManager.manager.request(String(baseURL + endPoint),method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in

				CDSpinner.hide()

				guard response.result.isSuccess else {
                    if response.result.error!._code == NSURLErrorTimedOut {
                        //timeout here
                      //  Toast.show(withMessage: REQUEST_TIME_OUT)
                    }
					failure(response.result.error as NSError?)

					return
				}
				if let value = response.result.value {
					success(JSON(value))
				}
			}
		} else {

			CDSpinner.hide()
			Toast.show(withMessage: NO_NETWORK)
		}
	}

	func getRequest(_ endpoint: String, headers: [String: String]?, parameters: [String: AnyObject]?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {

		defer {

		}

		if headers != nil {
			header += headers!
		}
		if isReachable() {

			APIManager.manager.cancelAllTaskExcluding(tasks: [baseURL + DASHBOARD])

			CDSpinner.show()
		
            APIManager.manager.request(String(baseURL + endpoint),method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
        
				CDSpinner.hide()
				guard response.result.isSuccess else {
                    if response.result.error!._code == NSURLErrorTimedOut {
                        
                        //timeout here
                       // Toast.show(withMessage: REQUEST_TIME_OUT)
                    }
					failure(response.result.error as NSError?)
					return
				}

				if let value = response.result.value {
					success(JSON(value))
				}
			}
		} else {
			CDSpinner.hide()
			Toast.show(withMessage: NO_NETWORK)
		}
	}

	func putRequestJSON(_ endPoint: String, parameters: [String: AnyObject]?, headers: [String: String]?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
		defer {
		}
		if isReachable() {
			
			if headers != nil {
				header += headers!
			}

			APIManager.manager.cancelAllTaskExcluding(tasks: [baseURL + DASHBOARD])

			CDSpinner.show()
		 APIManager.manager.request(String(baseURL + endPoint),method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
				
				CDSpinner.hide()
//                CMHelper.helper.stopLoaderAnimation()
				guard response.result.isSuccess else {
                    
                    if response.result.error!._code == NSURLErrorTimedOut {
                        //timeout here
                       // Toast.show(withMessage: REQUEST_TIME_OUT)
                    }
                    
					failure(response.result.error as NSError?)
					if response.result.error?.localizedDescription != "cancelled" {
//                        UIApplication.sharedApplication().keyWindow!.makeToast(response.result.error!.localizedDescription, duration: 1.0, position: CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT - 75))
					}
//                    self.showError(data: response.data!)
					if let userInfo = response.result.value as? [String: AnyObject] {
						if let code = userInfo["StatusCode"] as? NSNumber {
							if code == 406 || code == 403 {
								
								// self.logout()
							}
						}
					}
					return
				}

				if let value = response.result.value {
					success(JSON(value))
				}
			}
		} else {
			CDSpinner.hide()
			Toast.show(withMessage: NO_NETWORK)
		}
	}

	func deleteRequestJSON(_ endPoint: String, parameters: [String: AnyObject]?, headers: [String: String]?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ error: NSError?) -> ()) {
		defer {
			
		}
		if isReachable() {
			
			if headers != nil {
				header += headers!
			}

			APIManager.manager.cancelAllTaskExcluding(tasks: [baseURL + DASHBOARD])

			CDSpinner.show()
			 APIManager.manager.request(String(baseURL + endPoint),method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
				
				CDSpinner.hide()
				// CMHelper.helper.stopLoaderAnimation()
				guard response.result.isSuccess else {
                    if response.result.error!._code == NSURLErrorTimedOut {
                        //timeout here
                      //  Toast.show(withMessage: REQUEST_TIME_OUT)
                    }
					failure(response.result.error as NSError?)
					if response.result.error?.localizedDescription != "cancelled" {
						// UIApplication.sharedApplication().keyWindow!.makeToast(response.result.error!.localizedDescription, duration: 1.0, position: CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT - 75))
					}
					// self.showError(data: response.data!)
					if let userInfo = response.result.value as? [String: AnyObject] {
           
                       
                        
                        if let code = userInfo["StatusCode"]  as? NSNumber {
							if code == 406 || code == 403 {
								
								// self.logout()
							}
						}
					}
					return
				}

				if let value = response.result.value {
					success(JSON(value))
				}
			}
		} else {
			CDSpinner.hide()
			Toast.show(withMessage: NO_NETWORK)
		}
	}

	func uploadFileMultipartFormDataWithParams(_ endPoint: String, headers: [String: String]?, uploadImageList: [AnyObject]?, fileName: String?, parameters: [String: AnyObject]?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ errorMsg: String) -> ()) {

		if isReachable() {
			if headers != nil {
				header += headers!
			}
			CDSpinner.show()


            APIManager.manager.upload(multipartFormData: { multipartFormData in
                
                for index in 0..<uploadImageList!.count {
                    if let imageData = uploadImageList![index] as? Data {
                       multipartFormData.append(imageData, withName:  "PortfolioImages[]", fileName: "portfolio.jpg", mimeType: "image/jpg")
                    }
                }
                
                
                
                for (key, value) in parameters! {
                    
                    print("key value:\(key) valaue:\(value)")
                    
                   // MultipartFormData.appendBodyPart(data: value.data(using: String.Encoding.utf8)!, name: key)
                    
                   multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            },
                            to: baseURL + endPoint,
                                                   encodingCompletion: { encodingResult in

				switch encodingResult {
				case .success(let upload, _, _):
		 			upload.responseJSON { response in
						(response)
						CDSpinner.hide()
						if let value = response.result.value {
							success(JSON(value))
						}
					}
				case .failure(let encodingError):
					print(encodingError)
					CDSpinner.hide()
					failure("Failure")
					Toast.show(withMessage: NO_NETWORK)

				}
			})
		} else {
			CDSpinner.hide()
			
			failure("No Network.")
			Toast.show(withMessage: NO_NETWORK)
		}
	}
 // Certificate Update Image
    
    func uploadCertificateFileMultipartFormDataWithParams(_ endPoint: String, headers: [String: String]?, uploadImageList: [AnyObject]?, fileName: String?, parameters: [String: AnyObject]?, success: @escaping (_ response: JSON?) -> (), failure: @escaping (_ errorMsg: String) -> ()) {
        
        if isReachable() {
            if headers != nil {
                header += headers!
            }
            CDSpinner.show()
            
             APIManager.manager.upload(multipartFormData: { multipartFormData in
                
                for index in 0..<uploadImageList!.count {
                    if let imageData = uploadImageList![index] as? Data {
                     
                        multipartFormData.append(imageData, withName:  "UserCertification[]", fileName: "certificate.jpg", mimeType: "image/jpg")
                    }
                }
                
                for (key, value) in parameters! {
                  multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            },
                                       
                to: baseURL + endPoint,
                encodingCompletion: { encodingResult in
                
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            (response)
                            CDSpinner.hide()
                            if let value = response.result.value {
                                success(JSON(value))
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        CDSpinner.hide()
                        failure("Failure")
                        Toast.show(withMessage: NO_NETWORK)
                        
                    }
            })
        } else {
            CDSpinner.hide()
            
            failure("No Network.")
            Toast.show(withMessage: NO_NETWORK)
        }
    }
    

}

func += <K, V> (left: inout [K: V], right: [K: V]) {
	for (k, v) in right {
		left.updateValue(v, forKey: k)
	}
}
