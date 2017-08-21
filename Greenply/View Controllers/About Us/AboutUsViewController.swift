//
//  AboutUsViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/30/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
class AboutUsViewController: BaseTableViewController {
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewBG: UIView!
 
    override func viewDidLoad() {
    
    super.viewDidLoad()
      self.labelDescription.text = ""
        self.labelTitle.text = ""

        

        viewBG.layer.borderColor =  UIColorRGB(212, g: 212, b: 212)?.cgColor
 
       // self.tableView.needsUpdateConstraints()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 96.0
        self.backgroundImageView.image = UIImage(named: "BackgroundImage")
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
          //self.tableView.reloadData()
         }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
              self.getAboutUsList()
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_ABOUT_US
       NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton:false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        NavigationHelper.helper.tabBarViewController?.hideTabBar()

    }


}
extension AboutUsViewController
{	// MARK: UITextFieldDelegate methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}
//MARK:- API calling
extension AboutUsViewController
{
    func getAboutUsList(){
        APIHandler.handler.getAboutUS({ (response) in
     
            if let _ =  response?["Page"].dictionaryObject{
                let dictAboutUs = response?["Page"].dictionaryObject!
                self.labelTitle.text = dictAboutUs?["page_title"] as? String
                
             let myString = dictAboutUs?["page_content"] as? String
            
            self.labelDescription.textAlignment = NSTextAlignment.justified
                self.labelDescription.text =  myString?.trimString(forString: myString)// (dictAboutUs["page_content"] as? String)
                
                self.tableView.reloadData()
            }else{
                Toast.show(withMessage: NO_RECORDS_FOUND)
            }
           
        }) { (error) in
            
        }
    }
}
