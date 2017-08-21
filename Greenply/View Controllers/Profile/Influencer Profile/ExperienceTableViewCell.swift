//
//  ExperienceTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ExperienceTableViewCell: BaseTableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var labelTo: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    override var datasource: AnyObject? {
        didSet {
            debugPrint(datasource)
//            labelTitle.text = datasource!["degree"] as? String
//            labelDesc.text = datasource!["stream"] as? String
//            labelFrom.text = datasource!["start_date"] as? String
//            labelTo.text = datasource!["end_date"] as? String
            
            
       
            if datasource!.isKind(of: UserExperience.self){
                let objExp = datasource as! UserExperience
                labelTitle.text = "Degree: \(objExp.organisation_name!)"
                   labelDesc.text = "Stream: \(objExp.stream)"
                    labelFrom.text = "From date: \(Date.convertTimeStampToDate(objExp.startDate!))"
                     labelTo.text = "To date: \(Date.convertTimeStampToDate(objExp.endDate!))"
                
                
            
            }
            else if datasource!.isKind(of: UserTraining.self){
                let objTraning = datasource as! UserTraining
                labelTitle.text = "Degree: \(objTraning.training_name!)"
                labelDesc.text = "Stream: \(objTraning.stream)"
                labelFrom.text = "From date: \(Date.convertTimeStampToDate(objTraning.startDate!))"
                labelTo.text = "To date: \(Date.convertTimeStampToDate(objTraning.endDate!))"
            }
            else if datasource!.isKind(of: UserEducation.self){
                let objEdu = datasource as! UserEducation
                labelTitle.text = "Degree: \(objEdu.degreeName!)"
                labelDesc.text = "Stream: \(objEdu.stream!)"
                labelFrom.text = "From date: \(Date.convertTimeStampToDate(objEdu.startDate!))"
                labelTo.text = "To date: \(Date.convertTimeStampToDate(objEdu.endDate!))"            }
                
            else{
                labelTitle.text = datasource!["Title"] as? String
                labelDesc.text = datasource!["Description"] as? String
                labelFrom.text = datasource!["From"] as? String
                labelTo.text = datasource!["To"] as? String
                
                debugPrint(datasource?.count)
            }
            
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // viewTitle.layer.cornerRadius = IS_IPAD() ? 10.0 : 5.0
    }
}

