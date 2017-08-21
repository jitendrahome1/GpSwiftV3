//
//  InfluencerTableCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 19/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class InfluencerTableCell: BaseTableViewCell {
    
    @IBOutlet weak var nsConstHight: NSLayoutConstraint!
    @IBOutlet weak var textTitle: JATextField!
    @IBOutlet weak var textDescription: JATextField!
    @IBOutlet weak var textFrom: JATextField!
    @IBOutlet weak var textTo: JATextField!
    var strDictStaus: String?
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var buttonAdd: UIButton!
    
    @IBOutlet weak var btnFromDate: UIButton!
    
    @IBOutlet weak var btnToDate: UIButton!
    
    var index: Int?
    var dict: [String: AnyObject]?
    var addCell:((_ sender: UIButton, _ index: Int) -> ())!
    var didSelectFromDate:((_ pTextField: UITextField?, _ textTitle: UITextField?, _ textDesc: UITextField?, _ textTo: UITextField?, _ index: Int?, _ dictStatus: String?)->())?
    var didSelectToDate:((_ pTextField: UITextField?, _ textTitle: UITextField?, _ textDesc: UITextField?, _ textFrom: UITextField?, _ index: Int?, _ dictStatus: String?)->())?
    var didChangedValue:((_ dataSource: [String: AnyObject]?, _ index: Int?) -> ())?
    override var datasource: AnyObject? {
        didSet {
            
            
            print("dataValue:--- \(datasource)")
            
            if index == 0 {
                buttonAdd.setBackgroundImage(UIImage(named: "ProjectFormPlusIcon"), for: UIControlState())
            } else {
                buttonAdd.setBackgroundImage(UIImage(named: "ProjectFormMinusIcon"), for: UIControlState())
            }
            
            
            if datasource!.count > 0 && datasource!["KeyVale"] as! String == KEY_EXPRIENCE{
                
                self.nsConstHight.constant = 0.0
                textTitle.text =  datasource!["organisation_name"] as? String
                textDescription.text = datasource!["stream"] as? String
                
     
                if let _ = datasource!["start_date"] as? Double{
                    textFrom.text =   Date.convertTimeStampToDate((datasource!["end_date"] as? Double)!)
                  
                }else{
                   textFrom.text = ""
                }
                if let _ = datasource!["end_date"] as? Double{
                textTo.text =   Date.convertTimeStampToDate((datasource!["start_date"] as? Double)!)
                }
                else{
                  textTo.text = ""
                }
            
                btnEdit.setTitle(datasource!["ButtonTitle"] as? String, for:UIControlState())
            }
            else if datasource!.count > 0 && datasource!["KeyVale"] as! String == KEY_TRANING{
                    self.nsConstHight.constant = 0.0
                textTitle.text =  datasource!["training_name"] as? String
                textDescription.text = datasource!["stream"] as? String
                if let _ = datasource!["start_date"] as? Double{
                    textFrom.text =   Date.convertTimeStampToDate((datasource!["end_date"] as? Double)!)
                    
                }else{
                    textFrom.text = ""
                }
                if let _ = datasource!["end_date"] as? Double{
                    textTo.text =   Date.convertTimeStampToDate((datasource!["start_date"] as? Double)!)
                }
                else{
                    textTo.text = ""
                }
                btnEdit.setTitle(datasource!["ButtonTitle"] as? String, for:UIControlState())
            }
            else if datasource!.count > 0 && datasource!["KeyVale"] as! String == KEY_EDUCATION{
                    self.nsConstHight.constant = 40.0
                textTitle.text =  datasource!["degree"] as? String
                textDescription.text = datasource!["stream"] as? String
                if let _ = datasource!["start_date"] as? Double{
                    textFrom.text =   Date.convertTimeStampToDate((datasource!["end_date"] as? Double)!)
                    
                }else{
                    textFrom.text = ""
                }
                if let _ = datasource!["end_date"] as? Double{
                    textTo.text =   Date.convertTimeStampToDate((datasource!["start_date"] as? Double)!)
                }
                else{
                    textTo.text = ""
                }
                btnEdit.setTitle(datasource!["ButtonTitle"] as? String, for:UIControlState())
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        self.btnEdit.layer.cornerRadius = 6.0
    }
}


extension InfluencerTableCell {
    
    @IBAction func buttonAdd(_ sender: UIButton) {
        if addCell != nil {
            addCell!(sender, index!)
            
        }
    }
    
}

