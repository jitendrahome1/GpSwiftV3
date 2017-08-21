//
//  Globals.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class Globals: NSObject {

	static let sharedClient = Globals()
	fileprivate override init() { }
    
    var userID: Int?
    var lat: Double?
    var lon: Double?
    var loginUserType: String?
}
