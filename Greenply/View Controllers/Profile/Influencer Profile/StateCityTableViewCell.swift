//
//  StateCityTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 13/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class StateCityTableViewCell: BaseTableViewCell {

    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    var arrayCity: [AnyObject]?
    var arrCityVal = [String]()
    override var datasource: AnyObject?{
        didSet{
            if datasource != nil {
                arrCityVal.removeAll()
                labelState.text = "State: \(datasource!["stateName"]!!)"
                arrayCity = datasource!["cityInfo"]!! as? [AnyObject]
                for value in arrayCity! {
                    arrCityVal.append(value["name"]! as! String)
                }
                labelCity.text = "City: \(arrCityVal.joined(separator: ","))"
            }
        }
    }
}




