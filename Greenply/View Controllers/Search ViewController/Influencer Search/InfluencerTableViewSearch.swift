//
//  SearchTableViewController.swift
//  Greenply
//
//  Created by Jitendra on 11/22/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

@objc protocol InfluencerSeacrhDelegateList {
    @objc optional func didGetAllSelectedCity(forItems arrValue: [AnyObject]?)
    @objc optional func didGetAllEditableCity(forItems arrValue: [AnyObject]?, indexValue: Int)
}

enum enumCityEdit {
    case eCityEdit
    case eCityAdd
}
import UIKit
class InfluencerTableViewSearch: BaseViewController, UITableViewDelegate, UISearchBarDelegate, HeaderButtonDeleagte {
    var arrPData = [AnyObject]()
    var dictCity: [String: AnyObject]?
    var arrSeletedItems = [AnyObject]()
    var arrGetEditData = [AnyObject]()
    var arrFilter = [AnyObject]()
    var arrFilteredList = [AnyObject]()
    var arrList = [AnyObject]()
    var isSearchButtonPress: Bool?
    var getIndexValue: Int?
    var eCityStatus: enumCityEdit = .eCityAdd
    var delegate: InfluencerSeacrhDelegateList?
    var localDict = [String: AnyObject]()
    @IBOutlet weak var aSearchView: UISearchBar!
    @IBOutlet var tblCountry: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //self.arrSeletedItems.removeAll()
        
        
        NavigationHelper.helper.headerViewController?.delegateButton = self
        self.backButtonEnabled = false
        // tblCountry.allowsMultipleSelection = true
        
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_CITY_LIST
        NavigationHelper.helper.headerViewController?.buttonMenu.isHidden = true
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController?.addHeaderButton(KHeaderTickButton)
        aSearchView.delegate = self
        self.arrList.removeAll()
        
        self.localDict.removeAll()
        self.arrFilteredList.removeAll()
        self.loadData()
        self.tblCountry.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        NotificationCenter.default.addObserver(self, selector: #selector(SearchTableViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    // Mark:- Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.arrList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let cellCountry = self.tblCountry.dequeueReusableCell(withIdentifier: "InfluencerCityCell", for: indexPath) as! InfluencerCityCell
        
        if indexPath.row % 2 == 0 {
            cellCountry.backgroundColor = UIColor.groupTableViewBackground
        } else {
            cellCountry.backgroundColor = UIColor.white
        }
        
        let dictVAlue = arrList[indexPath.row]
        
        if dictVAlue["checkStatus"] as! Bool == true {
            cellCountry.checkImg.image = UIImage(named: "CheckBoxSelected")
            cellCountry.checkCity = true
        } else {
            cellCountry.checkImg.image = UIImage(named: "CheckBoxDelSected")
            cellCountry.checkCity = false
        }
        
        print("Value Result\(dictVAlue)")
        
        cellCountry.labelCity.text = dictVAlue["name"] as? String
        return cellCountry
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myCell = tableView.cellForRow(at: indexPath) as! InfluencerCityCell
        let tempDict = arrList[indexPath.row] as! [String: AnyObject]
        
        print("Temp Dict \(tempDict)")
        
        self.getIndexPath(self.arrList, keySearch: tempDict["name"] as! String, cell: myCell)
        
    }
    
}

// MARk: - Tick Button Action
extension InfluencerTableViewSearch {
    func didTapMenuButton(_ strButtonType: String) {
        if strButtonType == KHeaderTickButton {
            // some action
            
            self.arrSeletedItems.removeAll()
            for index in 0..<self.arrList.count {
                
                var dicValue = self.arrList[index] as! [String : AnyObject]
                
                if dicValue["checkStatus"] as! Bool ==  true{
                    self.arrSeletedItems.append(dicValue as AnyObject)
                }
                
            }
            
            
            if self.arrSeletedItems .count > 0{
                for controller in NavigationHelper.helper.contentNavController!.viewControllers as Array {
                    if controller.isKind(of: ServiceAreaViewController.self) {
                        
                        if self.eCityStatus == .eCityEdit {
                            self.delegate?.didGetAllEditableCity!(forItems: self.arrSeletedItems, indexValue: self.getIndexValue!)
                        } else {
                            self.delegate?.didGetAllSelectedCity!(forItems: self.arrSeletedItems)
                        }
                        
                        self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                        break
                    }
                }
            }
            else{
                Toast.show(withMessage: SELECT_CITY)
            }
            
            
        }
    }
    // Mark Local Function
    func loadData()
    {
        self.arrList.removeAll()
        for index in 0..<arrPData.count {
            
            let dict = self.arrPData[index]
            self.arrList.append(dict)
        }
        self.tblCountry.reloadData()
    }
    
    func removeArrWithID(_ pArry: [AnyObject], keySearch: [AnyObject], indexx: Int)
    {
        var dictSearch = keySearch.first as! [String: AnyObject]
        for index in 0..<pArry.count {
            let dict = pArry[index] as! [String: AnyObject]
            print("dict\(dict)")
            if dict["id"]?.int32Value == dictSearch["id"]?.int32Value {
                self.arrList.remove(at: index)
            }
        }
    }
    
    // MARK:- Remove Tags ID
    func getIndexPath(_ pArry1: [AnyObject], keySearch: String, cell: InfluencerCityCell)
    {
        
        let index = self.arrList.index {
            if let dic = $0 as? Dictionary<String, AnyObject> {
                if let value = dic["name"] as? String, value == keySearch {
                    return true
                }
            }
            return false
        }
        
        
        print("Index Value\(index)")
        
        print(self.arrList)
        var tempDict = self.arrList[index!] as! [String: AnyObject]
        let isCheckStatus = tempDict["checkStatus"] as! Bool
        let changeStatus = !isCheckStatus
        tempDict["checkStatus"] = changeStatus as AnyObject?
        self.arrList[index!] = tempDict as AnyObject
        print(self.arrList)
        
        let dictVAlue = arrList[index!] as! [String :  AnyObject]
        
        if dictVAlue["checkStatus"] as! Bool == true {
            cell.checkImg.image = UIImage(named: "CheckBoxSelected")
            cell.checkCity = true
            // Add City
            // self.addSelectedCity(forDict:dictVAlue)
        } else {
            // Remove City
            // self.removeCityList(withIndexValue: index!)
            cell.checkImg.image = UIImage(named: "CheckBoxDelSected")
            cell.checkCity = false
        }
        
        print("City Count\(arrSeletedItems.count)")
    }
    
    // MARK:- Add selected City
    func addSelectedCity(forDict dictSeletedCity:[String : AnyObject]){
        
        self.arrSeletedItems.append(dictSeletedCity as AnyObject)
    }
    // MARK:- Remove the City
    func removeCityList(withIndexValue indexValue: Int){
        
        self.arrSeletedItems.remove(at: indexValue)
    }
    
}
