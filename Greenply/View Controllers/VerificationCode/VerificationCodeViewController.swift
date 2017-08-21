//
//  VerificationCodeViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/26/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class VerificationCodeViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Table View Delagte
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
         if IS_IPAD()
         {
            if indexPath.row == 1
            {
                return 277
            }
        }
        else
         {
            if indexPath.row == 1
            {
                return 180
            }
            else if indexPath.row == 2
            {
                return 82
            }
            
        }
        return 196
    }
}
