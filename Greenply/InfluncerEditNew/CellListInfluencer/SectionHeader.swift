//
//  SectionHeader.swift
//  Greenply
//
//  Created by Jitendra on 4/4/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class SectionHeader: UIView {

    @IBOutlet weak var lblSectionTitle: UILabel!

    @IBOutlet weak var btnSectionHeader: UIButton!


    @IBOutlet weak var imgDropDown: UIImageView!

     class func instantiateFromNib() -> Self {
        
        return instantiateFromNib("SectionHeader")
    }
}
public extension UIView {
    
    public class func instantiateFromNib<T: UIView>(_ viewType: T.Type) -> T {
        let url = URL(string: NSStringFromClass(viewType))
        return Bundle.main.loadNibNamed((url?.pathExtension)!, owner: nil, options: nil)!.first as! T
    }
    
    public class func instantiateFromNib(_ name:String) -> Self {
        return instantiateFromNib(self)
    }
    
}
