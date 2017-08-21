//
//  AreaServedCustomCell.swift
//  Greenply
//
//  Created by Jitendra on 4/5/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class AreaServedCustomCell: BaseTableViewCell {
    @IBOutlet weak var lblStateName: UILabel!
    @IBOutlet weak var lablCityList: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
            
                self.lblStateName.text = datasource!["name"] as? String
                
                let arrCityInfo = datasource!["cityLocations"] as! [AnyObject]
                var cityName = ""
                for index in 0..<(arrCityInfo as AnyObject).count {
                    
                    cityName = cityName + (arrCityInfo[index]["name"]!  as? String)!
                  
                    if index < (arrCityInfo as AnyObject).count - 1 {
                        cityName = cityName + ","
                    }
                }
                
                	self.lablCityList.text = cityName
            
            
            }
        }
    }
   
}
