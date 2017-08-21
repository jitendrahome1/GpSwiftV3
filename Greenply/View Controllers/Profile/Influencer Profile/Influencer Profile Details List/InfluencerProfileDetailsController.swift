//
//  InfluencerProfileDetailsController.swift
//  Greenply
//
//  Created by Shatadru Datta on 19/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//


import UIKit
enum identifySection {
    case eExperience
    case eTraining
    case eEducation
}
class InfluencerProfileDetailsController: BaseTableViewController {
    
    
    var influencerDetailsArray: Array<AnyObject>?
    var influencerDetailsArray2: Array<AnyObject>?
    
    var placesData : Data?
    var mySavedList: [String: AnyObject]?
    var pArrData = [AnyObject]()
    var objUser: User!
    var identifykeyStatus:identifySection!
    var didSaveInfluencerDetails:((_ array: [AnyObject], _ datasource: [String: AnyObject]?) -> ())?
    var didChangedFinalValue:((_ dataSource: [String: AnyObject]?,_ dataSource2: [String: AnyObject]?, _ index: Int?) -> ())?
    var dict: [String: AnyObject]?
    var dict2: [String: AnyObject]?
    var textTitle: String = ""
    var textDesc: String = ""
    var fromDate: String = ""
    var toDate: String = ""
    var btnTitleEdit: String = "Edit"
    var btnTitleDone: String = "Done"
    var eTypeDetailsStatus:identifySection =  .eExperience
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = nil
        var dataTemp = self.pArrData[0] as! [String: AnyObject]

        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = dataTemp["KeyVale"] as? String
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true, isHideSearchButton: true)
        NavigationHelper.helper.enableSideMenuSwipe = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    // MARk: - This Funtion edit  and update the record
    @IBAction func actionEditDetails(_ sender: UIButton) {
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell =  tableView.cellForRow(at: cellIndexPath!) as! InfluencerTableCell
        self.textTitle = cell.textTitle.text!
        self.textDesc = cell.textDescription.text!
        self.fromDate = cell.textFrom.text!
        self.toDate = cell.textTo.text!
        
        var dataTemp = self.pArrData[(cellIndexPath?.row)!] as! [String: AnyObject]
        
        
        
        if sender.titleLabel?.text == btnTitleEdit{
            cell.textTitle.isUserInteractionEnabled = true
            cell.textDescription.isUserInteractionEnabled = true
            cell.textFrom.isUserInteractionEnabled = true
            cell.textTo.isUserInteractionEnabled = true
            cell.btnFromDate.isUserInteractionEnabled  = true
            cell.btnToDate.isUserInteractionEnabled = true
            
            
            dataTemp["ButtonTitle"] = btnTitleDone as AnyObject?
            self.pArrData.remove(at: (cellIndexPath?.row)!)
            self.pArrData.insert(dataTemp as AnyObject, at: (cellIndexPath?.row)!)
            
            sender.setTitle(btnTitleDone, for:UIControlState())
            
        }else{
            
            // check validation
            if !(self.ValidateFields())
            {
                print(" some thing is missing")
                return;
            }
            cell.textTitle.isUserInteractionEnabled = false
            cell.textDescription.isUserInteractionEnabled = false
            cell.textFrom.isUserInteractionEnabled = false
            cell.textTo.isUserInteractionEnabled = false
            cell.btnFromDate.isUserInteractionEnabled  = false
            cell.btnToDate.isUserInteractionEnabled = false
            dataTemp["ButtonTitle"] = btnTitleEdit as AnyObject?
            sender.setTitle(btnTitleEdit, for:UIControlState())
            // APi Call
  
            self.addAndUpdateRecord(forIndexPathTemp: cellIndexPath!, KeyType: dataTemp["KeyVale"] as? String)
            
        }
        
        
    }
    // MARK:- This Function Date Action
    // MARk:- Selete the From Date Action
    
    
    func actionFromDate(_ sender: UIButton){
         self.view.endEditing(true)
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell =  tableView.cellForRow(at: cellIndexPath!) as! InfluencerTableCell
        var dataTemp = self.pArrData[(cellIndexPath?.row)!] as! [String: AnyObject]
        GPPickerViewController.showPickerController(self, isDatePicker: true, pickerArray: [], position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
            if let _  = value {
                dataTemp["start_date"] = value
                self.pArrData.remove(at: (cellIndexPath?.row)!)
                self.pArrData.insert(dataTemp as AnyObject, at: (cellIndexPath?.row)!)
                cell.textFrom.text = value! as? String
            }
          
            
            
            
            
        }
        
        
    }
    // MARK: - Selet the To DATE Action
    func actionToDate(_ sender: UIButton){
        self.view.endEditing(true)
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell =  tableView.cellForRow(at: cellIndexPath!) as! InfluencerTableCell
        var dataTemp = self.pArrData[(cellIndexPath?.row)!] as! [String: AnyObject]
        
        GPPickerViewController.showPickerController(self, isDatePicker: true, pickerArray: [], position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
            
            if let _  = value {
                dataTemp["start_date"] = value
                self.pArrData.remove(at: (cellIndexPath?.row)!)
                self.pArrData.insert(dataTemp as AnyObject, at: (cellIndexPath?.row)!)
                cell.textTo.text = value! as? String
            }
            
          
        }
        
    }
    
}
extension InfluencerProfileDetailsController
{
    func ValidateFields() -> Bool
    {
        self.view.endEditing(true)
        var result = true
        if textTitle.isEmpty == true {
            Toast.show(withMessage: ENTER_TITLE)
            // self.fieldEmpty()
            result = false
            
        }
//        else if textDesc.isEmpty == true {
//            Toast.show(withMessage: ENTER_DESC)
//            //self.fieldEmpty()
//            result = false
//        }
        else if fromDate.isEmpty == true {
            
            Toast.show(withMessage: FROM_DATE)
            //self.fieldEmpty()
            result = false
        }
        else if toDate.isEmpty == true  {
            Toast.show(withMessage: TO_DATE)
            //self.fieldEmpty()
            result = false
        }
            
        else if TO_DATE.isEmpty == false && fromDate.isEmpty == false{
            // date compair
            Helper.sharedClient.ComparingTwoNSDates(forTwoDate: toDate, fromDate: fromDate, result: { (pResult) in
                if pResult == "SAME"{
                    
                    Toast.show(withMessage: SAME_DATE)
                    result = false
                }
                    
                else  if pResult == "ASCENDING"{
                    Toast.show(withMessage: GREATER_DATE)
                    result = false
                    
                }
                
            })
        }
        return result
    }
    
    // MARk:- This Function Make A local dict
    func makeLocalDictWith(forDictValue pDictData:[String: AnyObject], keyValue: String!, indexValue:Int?){
        if keyValue == KEY_EXPRIENCE{
           
             let dict = ["organisation_name": pDictData["organisation_name"] as! String, "stream": "", "start_date":pDictData["start_date"] as! Double, "end_date": pDictData["end_date"] as! Double, "KeyVale":KEY_EXPRIENCE ,"ButtonTitle":self.btnTitleEdit, "id": pDictData["id"] as! Int] as [String : Any]

                self.pArrData.remove(at: indexValue!)
                self.pArrData.insert(dict as AnyObject, at: indexValue!)
            }
        else if keyValue == KEY_TRANING{
    
    let dict = ["training_name": pDictData["training_name"] as! String, "stream": "", "start_date": pDictData["start_date"] as! Double, "end_date": pDictData["end_date"] as! Double, "KeyVale":KEY_TRANING ,"ButtonTitle":self.btnTitleEdit, "id": pDictData["id"] as! Int] as [String : Any]
            self.pArrData.remove(at: indexValue!)
            self.pArrData.insert(dict as AnyObject, at: indexValue!)
       
        }

    else if keyValue == KEY_EDUCATION{
            let dict = ["degree": pDictData["degree"] as! String, "stream":  pDictData["stream"] as! String, "start_date": pDictData["start_date"] as! Double, "end_date":pDictData["end_date"] as! Double, "KeyVale":KEY_EDUCATION ,"ButtonTitle":self.btnTitleEdit, "id": pDictData["id"] as! Int] as [String : Any]

            self.pArrData.remove(at: indexValue!)
            self.pArrData.insert(dict as AnyObject, at: indexValue!)
        }
       // Update User Class and Nsdefult
        self.updateUserClassRecordLocal(forArrData: self.pArrData, keyValue: keyValue)
    }
// MARK:- This Function Update User User Obkect And Local; Dict
    func updateUserClassRecordLocal(forArrData arrResultData:[AnyObject]!, keyValue: String!){
   
        if keyValue == KEY_EXPRIENCE{
            if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
                mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: AnyObject]
                mySavedList!["experiences"] =  arrResultData! as AnyObject?
                }
        
        }
        
        
        else if keyValue == KEY_TRANING{
            if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
            mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: AnyObject]
                
                mySavedList!["trainings"] =  arrResultData! as AnyObject?
 
            }

        
        }
        
        else if keyValue == KEY_EDUCATION{
            if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
              mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: AnyObject]
                
                mySavedList!["educations"] =  arrResultData! as AnyObject?
      
            }

        }
        placesData = NSKeyedArchiver.archivedData(withRootObject: (mySavedList)!)
        
        SET_OBJ_FOR_KEY(placesData! as AnyObject , key: kUserLoginDetails)
    }
   
    
    
}

extension InfluencerProfileDetailsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return pArrData.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfluencerTableCell.self), for: indexPath) as! InfluencerTableCell
        cell.index = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.btnFromDate.tag = indexPath.row
        cell.btnToDate.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(self.actionEditDetails(_:)), for: .touchUpInside)
        cell.btnFromDate.addTarget(self, action: #selector(self.actionFromDate(_:)), for: .touchUpInside)
        cell.btnToDate.addTarget(self, action: #selector(self.actionToDate(_:)), for: .touchUpInside)
        cell.datasource = self.pArrData[indexPath.row]
        
        //
        cell.textTitle.isUserInteractionEnabled = false
        cell.textDescription.isUserInteractionEnabled = false
        cell.textTo.isUserInteractionEnabled = false
        cell.textFrom.isUserInteractionEnabled = false
        cell.btnFromDate.isUserInteractionEnabled  = false
        cell.btnToDate.isUserInteractionEnabled = false
        
        cell.addCell = {(button, index) in
            if index == 0 {
                 let KeyValueType = self.pArrData[0]
            let dict = ["Title": "", "stream": "", "From": "", "To": "", "KeyVale":KeyValueType["KeyVale"] as! String ,"ButtonTitle":self.btnTitleEdit, "id": 0] as [String : Any]
                
                self.pArrData.append(dict as AnyObject)
                tableView.insertRows(at: [IndexPath(row: (self.pArrData.count) - 1, section: indexPath.section)], with: .top)
            }else {
                let point = button.convert(CGPoint.zero, to: tableView)
                let indexPathTemp = tableView.indexPathForRow(at: point)
                
                let KeyValueType = self.pArrData[(indexPathTemp?.row)!]
                self.deleteRecordWith(forIndexPathTemp: indexPathTemp!, KeyType:KeyValueType["KeyVale"] as? String)
                
                
                
                
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_IPAD() ? 254.0 : 245
    }
}
// This Function Calling api
extension InfluencerProfileDetailsController{
    //MARK:- This Function update the record
    func addAndUpdateRecord(forIndexPathTemp indexPathTemp:IndexPath, KeyType: String?){
        if KeyType == KEY_EXPRIENCE{
           // update record Api calling
            var dataTemp = self.pArrData[(indexPathTemp.row)] as! [String: AnyObject]
            
            let pID = dataTemp["id"] as! Int
            if pID != 0{
                // call api then delete to arry
                self.UpdateRecordApiCallingWith(forKeyValue: KeyType!, pID: pID,indexPathValue:indexPathTemp)
         
            }
                
            else{
                // add record  Api calling
                  self.addRecordApiCallingWith(forKeyValue: KeyType!,indexPathValue:indexPathTemp)
            }
     
            
        }
        else if KeyType == KEY_TRANING{
            
            // update record Api calling
            var dataTemp = self.pArrData[(indexPathTemp.row)] as! [String: AnyObject]
            
            let pID = dataTemp["id"] as! Int
            if pID != 0{
                // call api then delete to arry
                self.UpdateRecordApiCallingWith(forKeyValue: KeyType!, pID: pID,indexPathValue:indexPathTemp)

                
            }
                
            else{
                // add record  Api calling
                self.addRecordApiCallingWith(forKeyValue: KeyType!,indexPathValue:indexPathTemp)
            }

        
        }else if KeyType == KEY_EDUCATION{
            
            // update record Api calling
            var dataTemp = self.pArrData[(indexPathTemp.row)] as! [String: AnyObject]
            
            let pID = dataTemp["id"] as! Int
            if pID != 0{
                // call api then delete to arry
                self.UpdateRecordApiCallingWith(forKeyValue: KeyType!, pID: pID,indexPathValue:indexPathTemp)

                
            }
                
            else{
                // add record  Api calling
                self.addRecordApiCallingWith(forKeyValue: KeyType!,indexPathValue:indexPathTemp)
            }
        }
        
    }
    // MARK:- This Function Delete the record
    
    func deleteRecordWith(forIndexPathTemp indexPathTemp:IndexPath, KeyType: String?){
      
        if KeyType == KEY_EXPRIENCE{
            var dataTemp = self.pArrData[(indexPathTemp.row)] as! [String: AnyObject]
            
            let pID = dataTemp["id"] as! Int
            if pID != 0{
                // call api then delete to arry
                self.deleteRecordApiCallingWith(forKeyValue: KeyType, delteID: pID, indexValue:indexPathTemp.row)
                self.pArrData.remove(at: indexPathTemp.row)
                self.updateUserClassRecordLocal(forArrData: self.pArrData, keyValue: KEY_EXPRIENCE)

                
            }
                
            else{
                self.pArrData.remove(at: indexPathTemp.row)
            }
    
       

            tableView.deleteRows(at: [IndexPath(row: (indexPathTemp.row), section: 0)], with: .top)
            let seconds = 0.3
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                
                self.tableView.reloadData()
            })
            
            
        }
        else if KeyType == KEY_TRANING{
        
            var dataTemp = self.pArrData[(indexPathTemp.row)] as! [String: AnyObject]
            
            let pID = dataTemp["id"] as! Int
            if pID != 0{
                // call api then delete to arry
                self.deleteRecordApiCallingWith(forKeyValue: KeyType, delteID: pID,indexValue:indexPathTemp.row)
                self.pArrData.remove(at: indexPathTemp.row)
              self.updateUserClassRecordLocal(forArrData: self.pArrData, keyValue: KEY_TRANING)
            
            }
                
            else{
                self.pArrData.remove(at: indexPathTemp.row)
            }
            tableView.deleteRows(at: [IndexPath(row: (indexPathTemp.row), section: 0)], with: .top)
            let seconds = 0.3
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                
                self.tableView.reloadData()
            })
            
            
        }
        else if KeyType == KEY_EDUCATION{
            var dataTemp = self.pArrData[(indexPathTemp.row)] as! [String: AnyObject]
            
            let pID = dataTemp["id"] as! Int
            if pID != 0{
                // call api then delete to arry
                self.deleteRecordApiCallingWith(forKeyValue: KeyType, delteID: pID,indexValue:indexPathTemp.row)
                self.pArrData.remove(at: indexPathTemp.row)
                self.updateUserClassRecordLocal(forArrData: self.pArrData, keyValue: KEY_EDUCATION)

            }
                
            else{
                self.pArrData.remove(at: indexPathTemp.row)
            }
            
            tableView.deleteRows(at: [IndexPath(row: (indexPathTemp.row), section: 0)], with: .top)
            let seconds = 0.3
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                
                self.tableView.reloadData()
            })
            
   
        }
    }
  
  // MARk:- Workijg On Api
    // ADD Record
    
    func addRecordApiCallingWith(forKeyValue keyValue:String?, indexPathValue:IndexPath){
        if keyValue == KEY_EXPRIENCE{
        APIHandler.handler.addExperinceWith(forDegreName: self.textTitle, stateDate: self.toDate, endDate: self.fromDate, success: { (response) in
            print("Response \(response)")
              self.makeLocalDictWith(forDictValue:  response!["experience"].dictionaryObject! as [String : AnyObject], keyValue: KEY_EXPRIENCE, indexValue:indexPathValue.row)
            Toast.show(withMessage:ADD_Record)
            
            }, failure: { (error) in
            
        })
            
        }
        else if keyValue  == KEY_TRANING{
       APIHandler.handler.addTraningWith(forDegreName: self.textTitle, stateDate: self.toDate, endDate: self.fromDate, success: { (response) in
        print("Response \(response)")
    
        self.makeLocalDictWith(forDictValue:  response!["training"].dictionaryObject! as [String : AnyObject], keyValue: KEY_TRANING, indexValue:indexPathValue.row)
        Toast.show(withMessage:ADD_Record)
        }, failure: { (error) in
        
       })
        }
        else if keyValue == KEY_EDUCATION{
       APIHandler.handler.addEductionWith(forDegreName: self.textTitle, streamName: self.textDesc, stateDate: self.toDate, endDate: self.fromDate, success: { (response) in
        print("Response \(response)")
          self.makeLocalDictWith(forDictValue:  response!["education"].dictionaryObject! as [String : AnyObject], keyValue: KEY_EDUCATION, indexValue:indexPathValue.row)
        Toast.show(withMessage:ADD_Record)
        }, failure: { (error) in
            
       })
        
        }
    
    }
    
    // Update Record
    
    func UpdateRecordApiCallingWith(forKeyValue keyValue:String?, pID:Int?, indexPathValue:IndexPath){
        if keyValue == KEY_EXPRIENCE{
            APIHandler.handler.updateExperinceWith(forExperienceID: pID!, forDegreName: self.textTitle, stateDate: self.fromDate, endDate: self.toDate, success: { (response) in
                   self.makeLocalDictWith(forDictValue:  response!["experience"].dictionaryObject! as [String : AnyObject], keyValue: KEY_EXPRIENCE, indexValue:indexPathValue.row)
                Toast.show(withMessage:update_Record)
                
                
                }, failure: { (error) in
                
            })
        }
        else if keyValue  == KEY_TRANING{
        APIHandler.handler.updateTraningWith(forTraningID: pID!, forDegreName: self.textTitle, stateDate: self.fromDate, endDate: self.toDate, success: { (response) in
                self.makeLocalDictWith(forDictValue:  response!["training"].dictionaryObject! as [String : AnyObject], keyValue: KEY_TRANING, indexValue:indexPathValue.row)
               Toast.show(withMessage:update_Record)
            }, failure: { (error) in
                
        })
        
        }
        else if keyValue == KEY_EDUCATION{
        APIHandler.handler.updateEductionWith(forEductionID: pID!, degreeName: self.textTitle, streamName: self.textDesc, stateDate: self.fromDate, endDate: self.toDate, success: { (response) in
                 self.makeLocalDictWith(forDictValue:  response!["education"].dictionaryObject! as [String : AnyObject], keyValue: KEY_EDUCATION, indexValue:indexPathValue.row)
             Toast.show(withMessage:update_Record)
            }, failure: { (error) in
            
        })
        }
        
    }
    
    // Delete The Record api.
    func deleteRecordApiCallingWith(forKeyValue keyValue:String?, delteID: Int?, indexValue:Int?){
        if keyValue == KEY_EXPRIENCE{
        
         APIHandler.handler.deleteExperinceWith(forExperienceID: delteID!, success: { (response) in
                Toast.show(withMessage:Delete_Record)
           
           
            }, failure: { (error) in
                
         })
            
        }
        else if keyValue  == KEY_TRANING{
          APIHandler.handler.deleteTraningWith(forTraningID: delteID!, success: { (response) in
            
           
            
            
            Toast.show(withMessage:Delete_Record)
            
            
            
            
            }, failure: { (error) in
                
          })
            
        } else if keyValue == KEY_EDUCATION{
          
            APIHandler.handler.deleteEductionWith(forEductionID: delteID!, success: { (response) in
                
                
                Toast.show(withMessage:Delete_Record)
                }, failure: { (error) in
                    
            })
        }
    }
    
    
}


