//
//  FilterViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 24/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FilterViewController: BaseViewController {

    var didpoptoInfluencer:((_ array: JSON) -> ())?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    var array = [AnyObject]()
    var arrDataList = [AnyObject]()
    var arrheaderList = [AnyObject]()
    var arrHeaderIcon = [String]()
    var arrExp = [AnyObject]()
    var arrDist = [AnyObject]()
    var arrJobCost = [AnyObject]()
    var arrRate = [AnyObject]()
    var arrCert = [AnyObject]()
    var selectedIndex = 0
    var localDict = [String: AnyObject]()
    var strExp = [String]()
    var strExpDet: String!
    var strDist = [String]()
    var strDistDet: String!
    var strJobCost = [String]()
    var strJobCostDet: String!
    var strRate = [String]()
    var strRateDet: String!
    var strCert = [String]()
    var strCertDet: String!
    var localResponse: JSON!
    var check: Bool!
    var influencer: String!
    var selectCheck = -1
    var globalInfluencerArray = [String]()
    var solutionType: String!
    var lat: Double!
    var lon: Double!
      var strPinCode: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.tabBarViewController?.hideTabBar()
        arrHeaderIcon = ["FilterWorkExperienceIcon", "FilterDistanceIcon", "FilterJobCostIcon", "FilterRatingsIcon", "FilterWithCertificateIcon"]
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        globalInfluencerArray.removeAll()
        strExp.removeAll()
        strCert.removeAll()
        strDist.removeAll()
        strRate.removeAll()
        strJobCost.removeAll()
        self.getFilterAttribute()
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_FILTER
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true, isHideSearchButton: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionClear(_ sender: UIButton) {
        self.arrCert.removeAll()
        self.arrJobCost.removeAll()
        self.arrDist.removeAll()
        self.arrExp.removeAll()
        self.arrRate.removeAll()
        for (key, value) in self.localResponse {
            if key == "0" {
                for data in value["attributeValues"].arrayObject! {
                    let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                    self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                    self.arrExp.append(self.localDict as AnyObject)
                }
            } else if key == "1" {
                for data in value["attributeValues"].arrayObject! {
                    let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                    self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                    self.arrDist.append(self.localDict as AnyObject)
                }
            } else if key == "2" {
                for data in value["attributeValues"].arrayObject! {
                    let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                    self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                    self.arrJobCost.append(self.localDict as AnyObject)
                }
            } else if key == "3" {
                for data in value["attributeValues"].arrayObject! {
                    let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                    self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                    self.arrRate.append(self.localDict as AnyObject)
                }
            } else {
                for data in value["attributeValues"].arrayObject! {
                    let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                    self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                    self.arrCert.append(self.localDict as AnyObject)
                }
            }
        }
        self.tableview.reloadData()
    }
    
    @IBAction func actionApply(_ sender: UIButton) {
        self.formingFilterStringData()
    }
}


//MARK:- GetFilterAttribute
extension FilterViewController {
    func getFilterAttribute() {
        APIHandler.handler.userFilterAttribute({ (response) in
            debugPrint(response)
            self.localResponse = response?["Attributes"]
            for (key, value) in (response?["Attributes"])! {
                if key == "0" {
                    for data in value["attributeValues"].arrayObject! {
                        let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                        self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                        self.arrExp.append(self.localDict as AnyObject)
                    }
                } else if key == "1" {
                    for data in value["attributeValues"].arrayObject! {
                        let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                        self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                        self.arrDist.append(self.localDict as AnyObject)
                    }
                } else if key == "2" {
                    for data in value["attributeValues"].arrayObject! {
                        let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                        self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                        self.arrJobCost.append(self.localDict as AnyObject)
                    }
                } else if key == "3" {
                    for data in value["attributeValues"].arrayObject! {
                        let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                        self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                        self.arrRate.append(self.localDict as AnyObject)
                    }
                } else {
                    for data in value["attributeValues"].arrayObject! {
                        let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
                        self.localDict = ["id": objFilterAttribute.id! as AnyObject, "count": objFilterAttribute.count! as AnyObject, "name": objFilterAttribute.name! as AnyObject, "value_code": objFilterAttribute.value_Code! as AnyObject, "status": false as AnyObject]
                        self.arrCert.append(self.localDict as AnyObject)
                    }
                }
            }
            
            if (response?["Attributes"].count)! > 0 {
                for value in (response?["Attributes"].arrayObject!)! {
                    let objHeaderFilterAttribute = HeaderFilterAttribute(withDictionary: value as! [String: AnyObject])
                    self.arrheaderList.append(objHeaderFilterAttribute)
                }
            }
            self.collectionView.reloadData()
            self.tableview.reloadData()
        }) { (error) in
            debugPrint(error)
        }

    }
}


//MARK:- TableViewDelegate, TableViewDatasource
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedIndex {
        case 0:
            return arrExp.count
        case 1:
            return arrDist.count
        case 2:
            return arrJobCost.count
        case 3:
            return arrRate.count
        case 4:
            return arrCert.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterTableViewCell.self), for: indexPath) as! FilterTableViewCell
        switch selectedIndex {
        case 0:
            cell.datasource = arrExp[indexPath.row]
        case 1:
            cell.datasource = arrDist[indexPath.row]
        case 2:
            cell.datasource = arrJobCost[indexPath.row]
        case 3:
            cell.datasource = arrRate[indexPath.row]
        case 4:
            cell.datasource = arrCert[indexPath.row]
        default:
            debugPrint("No Code")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_IPAD() ? 80.0 : 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedIndex {
        case 0:
            let objFilterData = self.arrExp[indexPath.row]
            if (objFilterData["status"] as! Bool) == true {
                check = false
            } else {
                check = true
            }
            localDict = ["id": objFilterData["id"]!! as AnyObject, "count": objFilterData["count"]!! as AnyObject, "name": objFilterData["name"]!! as AnyObject, "value_code": objFilterData["value_code"]!! as AnyObject, "status": check as AnyObject]
            self.arrExp.remove(at: indexPath.row)
            self.arrExp.insert(localDict as AnyObject, at: indexPath.row)
        case 1:
            let objFilterData = self.arrDist[indexPath.row]
            if (objFilterData["status"] as! Bool) == true {
                check = false
            } else {
                check = true
            }
            localDict = ["id": objFilterData["id"]!! as AnyObject, "count": objFilterData["count"]!! as AnyObject, "name": objFilterData["name"]!! as AnyObject, "value_code": objFilterData["value_code"]!! as AnyObject, "status": check as AnyObject]
            self.arrDist.remove(at: indexPath.row)
            self.arrDist.insert(localDict as AnyObject, at: indexPath.row)
        case 2:
            let objFilterData = self.arrJobCost[indexPath.row]
            if (objFilterData["status"] as! Bool) == true {
                check = false
            } else {
                check = true
            }
            localDict = ["id": objFilterData["id"]!! as AnyObject, "count": objFilterData["count"]!! as AnyObject, "name": objFilterData["name"]!! as AnyObject, "value_code": objFilterData["value_code"]!! as AnyObject, "status": check as AnyObject]
            self.arrJobCost.remove(at: indexPath.row)
            self.arrJobCost.insert(localDict as AnyObject, at: indexPath.row)
        case 3:
            let objFilterData = self.arrRate[indexPath.row]
            if (objFilterData["status"] as! Bool) == true {
                check = false
            } else {
                check = true
            }
            localDict = ["id": objFilterData["id"]!! as AnyObject, "count": objFilterData["count"]!! as AnyObject, "name": objFilterData["name"]!! as AnyObject, "value_code": objFilterData["value_code"]!! as AnyObject, "status": check as AnyObject]
            self.arrRate.remove(at: indexPath.row)
            self.arrRate.insert(localDict as AnyObject, at: indexPath.row)
        case 4:
            let localArrCert = self.arrCert
            selectCheck = indexPath.row
            if selectCheck == 0 {
                self.arrCert.removeAll()
                let objFilterData = localArrCert[selectCheck]
                localDict = ["id": objFilterData["id"]!! as AnyObject, "count": objFilterData["count"]!! as AnyObject, "name": objFilterData["name"]!! as AnyObject, "value_code": objFilterData["value_code"]!! as AnyObject, "status": true as AnyObject]
                self.arrCert.append(localDict as AnyObject)
                
                let objFilterData2 = localArrCert[selectCheck+1]
                localDict = ["id": objFilterData2["id"]!! as AnyObject, "count": objFilterData2["count"]!! as AnyObject, "name": objFilterData2["name"]!! as AnyObject, "value_code": objFilterData2["value_code"]!! as AnyObject, "status": false as AnyObject]
                self.arrCert.append(localDict as AnyObject)
            } else {
                self.arrCert.removeAll()
                let objFilterData = localArrCert[selectCheck-1]
                localDict = ["id": objFilterData["id"]!! as AnyObject, "count": objFilterData["count"]!! as AnyObject, "name": objFilterData["name"]!! as AnyObject, "value_code": objFilterData["value_code"]!! as AnyObject, "status": false as AnyObject]
                self.arrCert.append(localDict as AnyObject)
                
                let objFilterData2 = localArrCert[selectCheck]
                localDict = ["id": objFilterData2["id"]!! as AnyObject, "count": objFilterData2["count"]!! as AnyObject, "name": objFilterData2["name"]!! as AnyObject, "value_code": objFilterData2["value_code"]!! as AnyObject, "status": true as AnyObject]
                self.arrCert.append(localDict as AnyObject)
            }
            

        default:
            debugPrint("No code")
        }
        tableView.reloadData()
    }
}

//MARK:- CollectionViewDelegate, CollectionViewDatasource
extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrheaderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCollectionViewCell.self), for: indexPath) as! FilterCollectionViewCell
        if selectedIndex == indexPath.item {
            cell.backgroundColor = UIColorRGB(58.0, g: 100.0, b: 36.0)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        cell.imageIcon.image = UIImage(named: arrHeaderIcon[indexPath.item])
        cell.datasource = arrheaderList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if IS_IPAD() {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/5)
        } else {
            return CGSize(width: collectionView.frame.width, height: IS_OF_4_INCH() ? 100 : collectionView.frame.height/5)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        tableview.reloadData()
    }
}


//MARK:- FilteringData
extension FilterViewController {
    
    func formingFilterStringData() {
        globalInfluencerArray.removeAll()
        strExp.removeAll()
        strCert.removeAll()
        strDist.removeAll()
        strRate.removeAll()
        strJobCost.removeAll()
       
        for value in self.arrExp {
            if (value["status"] as! Bool) == true {
                strExp.append("UserSearch[work_experience][]=\(value["value_code"]! as! String)")
            }
        }
        for value in self.arrDist {
            if (value["status"] as! Bool) == true {
                strDist.append("UserSearch[distance][]=\(value["value_code"]! as! String)")
            }
        }
        for value in self.arrCert {
            if (value["status"] as! Bool) == true {
                strCert.append("UserSearch[with_certifications][]=\(value["value_code"]! as! String)")
            }
        }
        for value in self.arrRate {
            if (value["status"] as! Bool) == true {
                strRate.append("UserSearch[ratings][]=\(value["value_code"]! as! String)")
            }
        }
        for value in self.arrJobCost {
            if (value["status"] as! Bool) == true {
                strJobCost.append("UserSearch[typical_job_cost][]=\(value["value_code"]! as! String)")
            }
        }
        
        if strExp.count > 0 {
            strExpDet = strExp.joined(separator: "&")
            globalInfluencerArray.append(strExpDet)
        }
        if strDist.count > 0 {
            strDistDet = strDist.joined(separator: "&")
            globalInfluencerArray.append(strDistDet)
        }
        if strJobCost.count > 0 {
            strJobCostDet = strJobCost.joined(separator: "&")
            globalInfluencerArray.append(strJobCostDet)
        }
        if strRate.count > 0 {
            strRateDet = strRate.joined(separator: "&")
            globalInfluencerArray.append(strRateDet)
        }
        if strCert.count > 0 {
            globalInfluencerArray.append(strCert[0])
        }
        
        //API Call...
        self.userFilterAPI()
    }
}

    
//    52.6.251.159/~demoecom/greenply/api/web/v1/users?UserSearch[user_type]=influencer&UserSearch[influencer_type]=architect&UserSearch[work_experience][]=less-2&UserSearch[work_experience][]=6-10&UserSearch[ratings][]=1&UserSearch[ratings][]=2&UserSearch[typical_job_cost][]=less-30000&UserSearch[typical_job_cost][]=30000-70000&UserSearch[skills][]=1&UserSearch[skills][]=2&UserSearch[distance][]=less-1&UserSearch[with_certifications]=yes&sort=like_count



//MARK:- UserFilterAPICall
extension FilterViewController {
    

    
    func userFilterAPI() {
    
        if globalInfluencerArray.count > 0 {
            let localStr = globalInfluencerArray.joined(separator: "&")
            
            if let lat1 = Globals.sharedClient.lat {
                lat = lat1
            } else {
                lat = 0.00
            }
            
            if let lon1 = Globals.sharedClient.lon {
                lon = lon1
            } else {
                lon = 0.00
            }
            if let pinCode = OBJ_FOR_KEY(kUserZipCode){
                strPinCode =  pinCode as? String
                
            }
            else{
                strPinCode = ""
            }
            

            
            if solutionType == "influencer" {
                influencer = "/users?UserSearch[user_type]=\(solutionType)&UserSearch[latitude]=\(lat)&UserSearch[longitude]=\(lon)&UserSearch[nearest_postcode]=\(strPinCode!)&\(localStr)"
            } else {
                influencer = "/users?UserSearch[user_type]=influencer&UserSearch[influencer_type]=\(solutionType)&UserSearch[latitude]=\(lat)&UserSearch[longitude]=\(lon)&\(localStr)"
            }
            
            APIHandler.handler.influencerFilter(forUser: "influencer", influencer_type: "architect", influencer_filter: influencer, success: { (response) in
                debugPrint(response)
                self.didpoptoInfluencer!(response!)
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                debugPrint(error)
            }

        } else {
            Toast.show(withMessage: SELECT_RECORD)
        }
        
    }
}


