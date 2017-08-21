//
//  ServiceAreaViewController.swift
//  Greenply
//
//  Created by Jitendra on 12/1/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

@objc protocol StateCityItemsDelegate {
    @objc optional func didGetAllStateCityItems(forItems arrValue: [AnyObject]?)
}

class ServiceAreaViewController: BaseViewController, HeaderButtonDeleagte, SeacrhDelegateList, InfluencerSeacrhDelegateList {
    
    @IBOutlet weak var tblServiceJob: UITableView!
    @IBOutlet weak var buttonSave: UIButton!
    var delegate: StateCityItemsDelegate?
    var arrStateList = [AnyObject]()
    var arrCityList = [AnyObject]()
    var arrCityName = [AnyObject]()
    var arrDataList = [AnyObject]()
    var arrAreaServedData = [AnyObject]()
    var checkStatus: Bool = false
    var arrTemp: [AnyObject]?
    
    var dictPList: [String: AnyObject]?
    var pStateID: Int?
    var strStateName: String?
    var dictLocalCityList = [String: AnyObject]()
    var didSelectState: ((_ forItems: [AnyObject]?) -> ())!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getAllStateList()
        buttonSave.layer.cornerRadius = 5.0
        buttonSave.layer.masksToBounds = true
        self.tblServiceJob.estimatedRowHeight = 122
        self.tblServiceJob.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        self.tblServiceJob.rowHeight = UITableViewAutomaticDimension;
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        print("the output:\(arrAreaServedData)")
        
        if self.arrDataList.count > 0 {
            print("seleted Data\(self.arrDataList)")
           // self.delegate?.didGetAllStateCityItems!(forItems: self.arrAreaServedData)
            didSelectState!(self.arrDataList)
            
            NavigationHelper.helper.contentNavController?.popViewController(animated: true)
        }else{
            Toast.show(withMessage: ENTER_STATE_CITY)
            
        }
        
        //
        //		if self.arrDataList.count > 0 {
        //			print("seleted Data\(self.arrDataList)")
        //			self.delegate?.didGetAllStateCityItems!(forItems: self.arrDataList)
        //            didSelectState(forItems: self.arrDataList)
        //
        //			NavigationHelper.helper.contentNavController?.popViewControllerAnimated(true)
        //
        //		} else {
        //
        //			Toast.show(withMessage: ENTER_STATE_CITY)
        //		}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.delegateButton = self
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_AREA_SEARVED
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false, isHideSearchButton: true)
        NavigationHelper.helper.headerViewController?.addHeaderButton(kPluseButton)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
    }
}

// MARK:- Header Button Delegate
extension ServiceAreaViewController {
    func didTapMenuButton(_ strButtonType: String) {
        if strButtonType == kPluseButton {
            let stateVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: SearchTableViewController())) as! SearchTableViewController
            if self.arrStateList.count > 0 {
                stateVC.delegate = self
                stateVC.arrPData = self.arrStateList
                stateVC.eStateCityStatus = .eStateSeleted
                
                NavigationHelper.helper.contentNavController!.pushViewController(stateVC, animated: true)
            } else {
                Toast.show(withMessage: STATE_ERROR)
            }
            
        } else {
            
        }
    }
    
    func getAllStateList() {
        APIHandler.handler.getStates({ (response) in
            self.arrStateList.removeAll()
            self.arrStateList = response!["states"].arrayObject! as [AnyObject]
            
            print("\(response)")
            
        }) { (error) in
            
        }
    }
    
    // get City with state id
    func getCityWith(forStateID stateID: Int?) {
        APIHandler.handler.getCityList(forStateID: self.pStateID!, success: { (response) in
            self.arrCityList.removeAll()
            var tempDict  = [String: AnyObject]()
            let arrTemp = response?["cities"].arrayObject!
            print("City Result\(response)")
            
            self.dictLocalCityList.removeAll()
            self.arrCityList.removeAll()
            
            
            // tempDict = ["id":stateID!, "name":self.strStateName!, "cityInfo": arrTemp]
            // self.arrAreaServedData.append(tempDict)
            if (arrTemp?.count)! > 0 {
                
                for index in 0..<arrTemp!.count {
                    
                    let dictCity = arrTemp?[index] as! [String: AnyObject]
                    
                    // make a local dict for city list
                    
                    
                    self.dictLocalCityList = ["id": dictCity["id"] as! Int as AnyObject, "name": dictCity["name"] as! String as AnyObject, "state_id": dictCity["state_id"] as! Int as AnyObject, "checkStatus": false as AnyObject]
                    
                    
                    //self.dictLocalCityList = ["stateID":dictCity["state_id"] as! Int, "stateName":self.strStateName!, "cityInfo": arrTemp,"checkStatus": false]
                    
                    
                    
                    self.arrCityList.append(self.dictLocalCityList as AnyObject)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                if self.arrCityList.count > 0 {
                    
                    let searchVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerTableViewSearch.self)) as! InfluencerTableViewSearch
                    searchVC.arrPData = self.arrCityList
                    searchVC.arrGetEditData = self.arrDataList
                    searchVC.delegate = self
                    self.navigationController?.pushViewController(searchVC, animated: true)
                }
            } else {
                Toast.show(withMessage: CITY_ERROR)
            }
            
        }) { (error) in
            
        }
        
        
        
        
        
    }
    
    // Mark:- SearchView  deletae
    // MARK:- State get delegate
    func didFinishSelectedState(forItems dictValue: [String: AnyObject]?)
    {
        self.pStateID = dictValue!["id"] as? Int
        self.strStateName = dictValue!["name"] as? String
        
        let pResult =  self.checkStateAlredyInListWith(arrItems: self.arrDataList, tempStateID: pStateID!)
        if pResult == true {
            Toast.show(withMessage: STATE_ALREADY)
        } else {
            self.getCityWith(forStateID: self.pStateID!)
        }
        
        
    }
    
    func didGetAllSelectedCity(forItems arrValue: [AnyObject]?) {
        
        // check state is alredy added or not.
        
        print("allvalue\(arrValue)")
        
        self.dictPList = ["id": self.pStateID! as AnyObject, "name": self.strStateName! as AnyObject, "cityLocations": arrValue! as AnyObject]
        let tempDict =  ["id":self.pStateID!, "name":self.strStateName!, "cityLocations": arrValue!] as [String : Any]
        self.arrAreaServedData.append(tempDict as AnyObject)
        
        self.arrDataList.append(self.dictPList! as AnyObject)
        self.tblServiceJob.reloadData()
        
    }
    
    func didGetAllEditableCity(forItems arrValue: [AnyObject]?, indexValue: Int) {
        print("name\(arrValue)")
        self.arrDataList.remove(at: indexValue)
        self.dictPList = ["id": self.pStateID! as AnyObject, "name": self.strStateName! as AnyObject, "cityLocations": arrValue! as AnyObject]
        
        self.arrDataList.append(self.dictPList! as AnyObject)
        self.tblServiceJob.reloadData()
    }
    
    // MARK :- Check State Alredy seleted or note
    
    func checkStateAlredyInListWith(arrItems arrItemList: [AnyObject], tempStateID: Int) -> Bool {
        var result: Bool = false
        if arrItemList.count > 0 {
            for index in 0..<arrItemList.count {
                let dict = arrItemList[index]
                if tempStateID == dict["id"] as! Int {
                    result = true
                    break
                }
            }
            
        }
        else {
            result = false
        }
        return result
    }
    
    // MARK:- Edit A city list
    func editCityList(_ indexPath: UIButton) {
        self.arrTemp?.removeAll()
        self.dictLocalCityList.removeAll()
        var arrTempCity = [AnyObject]()
        arrTempCity.removeAll()
        self.arrCityList.removeAll()
        let pDict = self.arrDataList[indexPath.tag]
        
        print("\(pDict)")
        
        arrTemp = pDict["cityLocations"] as? [AnyObject]
        print("value\(arrTemp)")
        self.strStateName = pDict["name"] as? String
        self.pStateID = pDict["id"] as? Int
        
        APIHandler.handler.getCityList(forStateID: self.pStateID, success: { (response) in
            
            arrTempCity = response!["cities"].arrayObject! as [AnyObject]
            print("City Result\(response)")
            
            for index in 0..<arrTempCity.count {
                
                let dictCity = arrTempCity[index] as! [String: AnyObject]
                
                // make a local dict for city list
                
                // check equal array
                
                for indexVal in 0..<self.arrTemp!.count {
                    
                    let tempDict = self.arrTemp![indexVal] as! [String: AnyObject]
                    
                    if tempDict["id"] as! Int == dictCity["id"] as! Int {
                        
                        self.checkStatus = true
                        print("\(self.checkStatus)")
                        break
                    } else {
                        self.checkStatus = false
                    }
                    
                }
                
                self.dictLocalCityList = ["id": dictCity["id"] as! Int as AnyObject, "name": dictCity["name"] as! String as AnyObject, "state_id": dictCity["state_id"] as! Int as AnyObject, "checkStatus": self.checkStatus as AnyObject]
                self.arrCityList.append(self.dictLocalCityList as AnyObject)
            }
            
            if self.arrCityList.count > 0 {
                let searchVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerTableViewSearch())) as! InfluencerTableViewSearch
                
                searchVC.arrPData = self.arrCityList
                // searchVC.arrSeletedItems = self.arrTemp!
                searchVC.eCityStatus = .eCityEdit
                searchVC.getIndexValue = indexPath.tag
                
                searchVC.delegate = self
                self.navigationController?.pushViewController(searchVC, animated: true)
            } else {
                Toast.show(withMessage: CITY_ERROR)
            }
            
        }) { (error) in
            
        }
        
    }
    
    // MARK:- Delete a Cell
    func deleteItemsWith(indexValue: UIButton){
        
        self.arrDataList.remove(at: indexValue.tag)
      //  self.arrAreaServedData.removeAtIndex(indexValue.tag)
        self.tblServiceJob.reloadData()
    }
    
}

extension ServiceAreaViewController {
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDataList.count// self.arrNotificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ServiceAreaCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ServiceAreaCell())) as! ServiceAreaCell
        
        let dictValue = self.arrDataList[indexPath.row]
        
        print("DictInfo\(dictValue)")
        cell.tagListView.removeAllTags()
        
        self.arrCityName.removeAll()
        let arr = dictValue["cityLocations"] as! [AnyObject]
        print("arrInfo\(arr)")
        for index in 0..<arr.count {
            
            let dictCity = arr[index]
            
            cell.tagListView.addTag(dictCity["name"] as! String)
        }
        
        cell.buttonDidTap.tag = indexPath.row
        cell.buttonDeleteCell.tag = indexPath.row
        cell.labelTitleName.text = dictValue["name"] as? String
        
        cell.didTapCellAction = { (sender) in
            
            self.editCityList(sender)
            print("sender Tag\(sender.tag)")
        }
        cell.didTapDeleteCell = {(sender) in
            self.deleteItemsWith(indexValue: sender)
        }
        
        print("CityInfo \(self.arrCityName)")
        // cell.tagListView.addTags(self.arrCityName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    }
    
    // MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            self.arrDataList.remove(at: indexPath.row)
            self.tblServiceJob.reloadData()
        }
    }
    
}
