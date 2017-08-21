//
//  HowItsWorkViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class HowItsWorkViewController: BaseTableViewController {
	@IBOutlet weak var labelDescription: UILabel!
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var viewBG: UIView!
	override func viewDidLoad() {
		super.viewDidLoad()
        self.labelTitle.text = ""
        self.labelDescription.text =  ""
		self.initialUISetup()

		// Do any additional setup after loading the view.
		self.backgroundImageView.image = UIImage(named: "BackgroundImage")
		self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        self.getHowITSWork()
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_ITS_WORK
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		NavigationHelper.helper.tabBarViewController?.hideTabBar()
	}

	// MARK:- initial setup
	func initialUISetup()
	{
		viewBG.layer.borderWidth = 0.7
		viewBG.layer.borderColor = UIColorRGB(212, g: 212, b: 212)?.cgColor
		self.backgroundImageView.image = UIImage(named: "")
		self.tableView.needsUpdateConstraints()
		self.tableView.estimatedRowHeight = 96.0
		self.tableView.rowHeight = UITableViewAutomaticDimension;
	}

}

extension HowItsWorkViewController
{ // MARK: UITextFieldDelegate methods
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return UITableViewAutomaticDimension
	}

}
//MARK: How Its Work. API Caling
extension HowItsWorkViewController
{
    func getHowITSWork(){
        APIHandler.handler.getHowItsWork({ (response) in
            print("How ITs Work:==\(response)")
            if let _ =  response?["Page"].dictionaryObject{
                let dictAboutUs = response?["Page"].dictionaryObject!
                self.labelTitle.text = dictAboutUs?["page_title"] as? String
               
                let myString = dictAboutUs?["page_content"] as? String
                self.labelDescription.textAlignment = NSTextAlignment.justified
                self.labelDescription.text = myString?.trimString(forString: myString) //dictAboutUs["page_content"] as? String
                //self.labelDescription.text?.labelJustified(self.labelDescription)
                self.tableView.reloadData()
            }else{
                Toast.show(withMessage: NO_RECORDS_FOUND)
            }
        }) { (error) in
            
        }
    }
    
    
}

