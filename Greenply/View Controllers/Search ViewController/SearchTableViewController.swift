//
//  SearchTableViewController.swift
//  Greenply
//
//  Created by Jitendra on 11/22/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

@objc protocol SeacrhDelegateList{
@objc optional func didFinishSelectedCity(forItems dictValue: [String: AnyObject]?)
 @objc optional func didFinishSelectedState(forItems dictValue: [String: AnyObject]?)
}
enum EStateCity {
    case eCitySeleted
    case eStateSeleted
}
import UIKit
class SearchTableViewController: BaseViewController, UITableViewDelegate, UISearchBarDelegate {
	var arrPData = [AnyObject]()
	var arrFilteredList = [AnyObject]()
	var arrList = [AnyObject]()
	var isSearchButtonPress: Bool?
    	var eStateCityStatus: EStateCity = .eCitySeleted
     var delegate: SeacrhDelegateList?
    var localDict = [String: AnyObject]()
	@IBOutlet weak var aSearchView: UISearchBar!
	@IBOutlet var tblCountry: UITableView!
    var ImgValue: UIImage?
	override func viewDidLoad()
	{
		super.viewDidLoad()
        
        self.backButtonEnabled = false
        if eStateCityStatus == .eCitySeleted{
               self.setNavigationTitle(TITLE_CITY_LIST)
               NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_CITY_LIST
              NavigationHelper.helper.headerViewController?.buttonMenu.isHidden  = true
            self.ImgValue = UIImage(named: "CityIcone")
        
        }else{
          self.setNavigationTitle(TITLE_STATE_LIST)
              NavigationHelper.helper.headerViewController?.buttonMenu.isHidden  = true
              NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_STATE_LIST
             self.ImgValue = UIImage(named: "stateIcone")
        }
       
		aSearchView.delegate = self
        self.arrList.removeAll()
        self.localDict.removeAll()
        self.arrFilteredList.removeAll()
        self.loadData()
        self.tblCountry.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
         NotificationCenter.default.addObserver(self, selector: #selector(SearchTableViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
		
	

	func loadData()
	{
		for index in 0..<arrPData.count {

			let dict = self.arrPData[index]
			self.arrList.append(dict)

		}
		self.tblCountry.reloadData()

	}

func keyboardWillHide(_ notification: Foundation.Notification) {
    self.aSearchView.showsCancelButton = false
}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if isSearchButtonPress == true {
			self.arrList.removeAll()
			return self.arrFilteredList.count
		}

		else {
			return self.arrList.count
		}

	}

	func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
	{
		//let cellCountry = self.tblCountry.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let cellCountry: SearchTableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTableCell.self)) as!  SearchTableCell
        
		if indexPath.row % 2 == 0 {
			cellCountry.backgroundColor = UIColor.groupTableViewBackground
		} else {
			cellCountry.backgroundColor = UIColor.white
		}
		// var countryName: String!
		if isSearchButtonPress == true {
			let dictVAlue = arrFilteredList[indexPath.row]
			//cellCountry.textLabel?.text = dictVAlue["name"] as? String
            cellCountry.lblItems.text =  dictVAlue["name"] as? String
            
		} else {
			let dictVAlue = arrList[indexPath.row]
			//cellCountry.textLabel?.text = dictVAlue["name"] as? String
            cellCountry.lblItems.text =  dictVAlue["name"] as? String
        }

        cellCountry.imgItems.image = ImgValue
		return cellCountry
	}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_IPAD() ? 80 : 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    if isSearchButtonPress == true {
    localDict = arrFilteredList[indexPath.row] as! [String : AnyObject]
    }
    else{
        localDict = arrList[indexPath.row] as! [String : AnyObject]
        }
    
        if eStateCityStatus == .eCitySeleted{
            self.delegate?.didFinishSelectedCity!(forItems: localDict)
        }else{
           self.delegate?.didFinishSelectedState!(forItems: localDict)
        }
    
        self.aSearchView.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }

	func filterTableViewForEnterText(_ searchText: String) {

		let strTrim = searchText.trimString(forString: searchText)
		if strTrim == "" {
            
			isSearchButtonPress = false
			self.loadData()
		}
		else {
			let name = NSPredicate(format: "name beginswith[c] %@", searchText)
			let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
			arrFilteredList = self.arrPData.filter { compoundPredicate.evaluate(with: $0) }
		}
        

		self.tblCountry.reloadData()
    }
		func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
			searchBar.showsCancelButton = true
		
		}

		func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		}

		func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
			isSearchButtonPress = false
			searchBar.text = ""
			searchBar.showsCancelButton = false
			self.loadData()
			searchBar.resignFirstResponder()

		}

		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		isSearchButtonPress = true
            self.filterTableViewForEnterText(searchText)

		}


	}
