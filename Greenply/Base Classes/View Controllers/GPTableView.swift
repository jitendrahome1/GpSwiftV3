//
//  GPTableView.swift
//  Greenply
//
//  Created by Shatadru Datta on 10/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import Foundation
class GPTableView: UITableView {
    
    var count = 0
    @IBInspectable var noDataText: String?
    
    override func reloadData() {
        super.reloadData()
        count = count + 1
        if self.tag == 101 {
            if self.numberOfSections == 0 {
                self.layoutIfNeeded()
                let label = UILabel(frame: UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)))
                //				label.backgroundColor = .redColor()
                label.numberOfLines = 0
                label.text = noDataText
                label.textAlignment = .center
                label.textColor = UIColor.black
                label.font = PRIMARY_FONT(IS_IPAD() ? 25.0 : 18.0)
                let view = UIView(frame: self.bounds)
                view.backgroundColor = .clear
                view.addSubview(label)
//                if HTTPManager.sharedManager.isReachable() {
//                    self.backgroundView = count >= 2 ? view : nil
//                } else {
//                    self.backgroundView = view
//                }
                debugPrint("description of no data label : \(label)")
            } else {
                self.backgroundView = nil
            }
        } else {
            self.backgroundView?.isHidden = true
            if self.numberOfRows(inSection: 0) == 0 {
                self.layoutIfNeeded()
                let label = UILabel(frame: UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)))
                label.backgroundColor = .red
                label.numberOfLines = 0
                label.text = noDataText
                label.textAlignment = .center
                label.textColor = UIColor.black
                label.font = PRIMARY_FONT(IS_IPAD() ? 25.0 : 18.0)
                let view = UIView(frame: self.bounds)
                view.backgroundColor = .clear
                view.addSubview(label)
//                if HTTPManager.sharedManager.isReachable() {
//                    self.backgroundView = count >= 2 ? view : nil
//                } else {
//                    self.backgroundView = view
//                }
            } else {
                self.backgroundView = nil
            }
        }
    }
}
