//
//  NotificationViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/30/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NotificationViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   }
extension NotificationViewController{
   
    //MARK: UITableViewDelegate AND Datasource methods
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return IS_IPAD() ? 130 : 90
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: NotificationCell = tableView.dequeueReusableCellWithIdentifier(String(NotificationCell)) as! NotificationCell
        return cell
    }

}
