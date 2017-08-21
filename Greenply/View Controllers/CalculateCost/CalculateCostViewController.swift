//
//  CalculateCostViewController.swift
//  Greenply
//
//  Created by Jitendra on 4/17/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class CalculateCostViewController: BaseTableViewController {

    

    @IBOutlet weak var lblHeaderTitleCell5: UILabel!
    @IBOutlet weak var lblHeaderCell4: UILabel!
    @IBOutlet weak var ViewBGCell0: UIView!
    @IBOutlet weak var imgDropDownCell0: UIImageView!
    @IBOutlet weak var btnFurniture: UIButton!
    @IBOutlet weak var lblFurniture: UILabel!
    @IBOutlet weak var viewBGCell1: UIView!
    @IBOutlet weak var imgDropDownCell1: UIImageView!
    
    @IBOutlet weak var btnFittingsType: UIButton!
    
    @IBOutlet weak var lblFittingsType: UILabel!
  
   // @IBOutlet weak var lblSizeFurniture: UILabel!
   // @IBOutlet weak var btnSizeFurniture: UIButton!
    
    
    @IBOutlet weak var viewBGCell2: UIView!
    @IBOutlet weak var imgDropDropCell2: UIImageView!
    @IBOutlet weak var lblPlyWood: UILabel!
    @IBOutlet weak var btnPlywood: UIButton!
    @IBOutlet weak var viewBGCell3: UIView!
    @IBOutlet weak var lblSerfaceTyp: UILabel!
    @IBOutlet weak var imgDropDownCell3: UIImageView!
    @IBOutlet weak var btnSerfaceType: UIButton!
    @IBOutlet weak var viewBGCell4: UIView!
    @IBOutlet weak var imgDropDownCell4: UIImageView!
    @IBOutlet weak var btnVennertype: UIButton!
    @IBOutlet weak var lblVennerType: UILabel!
    @IBOutlet weak var viewBGCell5: UIView!
    @IBOutlet weak var imgDropDownCell5: UIImageView!
    @IBOutlet weak var btnPolishType: UIButton!
    @IBOutlet weak var lblPolishType: UILabel!
    @IBOutlet weak var btnCalculate: UIButton!
    var noRows: Int?
    var arrFunitureData = [String]()
    //var arrFunitureSizeData = [String]()
    var arrPlywoodData = [String]()
    var arrSurfaceData = [String]()
    var arrVannerData = [String]()
    var arrPolishData = [String]()
    var arrFittingsData = [String]()
    var arrcellIdentifier = [AnyObject]()
    
    // temp array
    var arrTempFunitureDictData = [AnyObject]()
    var arrTempCalculateDictData = [AnyObject]()
    var arrTempVannerDictData = [AnyObject]()
    var arrTempPolishDictData = [AnyObject]()
     var arrTempFittingsDictData = [AnyObject]()
    var strFunitureValue:String = ""
    var strFunitureSizeValue:String = ""
    var strPlyWoodTypeValue: String = ""
    var strSurfaceTypeValue: String = ""
    var strVannerValue: String = ""
    var strPolishValue: String = ""
    var strFittingsValue: String  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        arrcellIdentifier = ["cell0" as AnyObject,"cell1" as AnyObject,"cell2" as AnyObject,"cell3" as AnyObject,"cell4" as AnyObject,"cell5" as AnyObject,"cell6" as AnyObject]
        self.backgroundImageView.image = UIImage(named: "")
        self.UISetup()
        self.getAllFurnitureTypeAttributesApiCalling()
      
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.btnPolishType.isUserInteractionEnabled = false
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_CALCULATE
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
    
    }

  
    
    func UISetup(){
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell0")
        noRows = 5
     //self.btnSizeFurniture.userInteractionEnabled = false
        self.btnPolishType.isUserInteractionEnabled = false
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_CALCULATE
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        
        ViewBGCell0.layer.borderColor = UIColor.lightGray.cgColor
          viewBGCell1.layer.borderColor = UIColor.lightGray.cgColor
          viewBGCell2.layer.borderColor = UIColor.lightGray.cgColor
          viewBGCell3.layer.borderColor = UIColor.lightGray.cgColor
          viewBGCell4.layer.borderColor = UIColor.lightGray.cgColor
         viewBGCell5.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    

   
}
// MARk:- All Button Action

extension CalculateCostViewController{
  
    @IBAction func actionSelectFurniture(_ sender: UIButton) {
   
        if arrFunitureData.count > 0 {
            GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrFunitureData, position: .bottom , pickerTitle: "", preSelected: "") { (value, index) in
             
                if ((value) as! String == ""){
                    self.lblFurniture.textColor = UIColor.lightGray
                    self.lblFurniture.text = "Select Furniture Type"
                }
                else{
                self.lblFurniture.text = value as? String
                    let strFurtureSprate = value?.components(separatedBy: "(")[0]
                    self.lblFurniture.textColor = UIColor.black
                    self.strFunitureValue = (value as? String)!

                    self.searchDropDownSeletedValueWith(forArrData: self.arrTempFunitureDictData, searchKey: strFurtureSprate, keyValue: KEY_FURNITURE)
                }
            }
        }else{
            
        }
   
    }


//    


    @IBAction func actionSeletedPlywood(_ sender: UIButton) {
        
        if arrPlywoodData.count > 0{
            GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrPlywoodData, position: .bottom , pickerTitle: "", preSelected: "") { (value, index) in
                self.lblPlyWood.text = value as? String
                if ((value) as! String == ""){
                    self.lblPlyWood.textColor = UIColor.lightGray
                    self.lblPlyWood.text = "Select Plywood Type"
                }
                else{
                      self.lblPlyWood.textColor = UIColor.black
                self.searchDropDownSeletedValueWith(forArrData: self.arrTempCalculateDictData, searchKey: value as? String, keyValue: KEY_PLYWOOD)
                }
                
           
            }
        }
        else{
            
        }
    
    }
    
    
    @IBAction func actionFittingsType(_ sender: UIButton) {
        
        if arrFittingsData.count > 0{
            
            GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: self.arrFittingsData, position: .bottom, pickerTitle: "", preSelected: "", selected: { (value, index) in
                if ((value) as! String == ""){
                    self.lblFittingsType.textColor = UIColor.lightGray
                    self.lblFittingsType.text = "Select Fittings Type"
                }else{
                    self.lblFittingsType.textColor = UIColor.black
                    self.lblFittingsType.text = value as? String
               
                 self.searchDropDownSeletedValueWith(forArrData: self.arrTempFittingsDictData, searchKey: value as? String, keyValue: KEY_FITTINGS)
                }
                
               
                
            })
        }
            
            
        else{
            
        }
        
        
    }

    @IBAction func actionSeletedSerface(_ sender: UIButton) {
   
        if arrSurfaceData.count > 0{
            GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrSurfaceData, position: .bottom , pickerTitle: "", preSelected: "") { (value, index) in
                if ((value) as! String == ""){
                 self.lblSerfaceTyp.text = "Select Serface Type"
                    self.strPolishValue = ""
                    self.strVannerValue = ""
                    self.lblSerfaceTyp.textColor = UIColor.lightGray
                }
                    
                else{
                    self.lblSerfaceTyp.textColor = UIColor.black
                  self.lblSerfaceTyp.text = value as? String
                    self.lblPolishType.textColor = UIColor.lightGray
                    self.lblVennerType.textColor = UIColor.lightGray
                    self.strPolishValue = ""
                    self.strVannerValue = ""
                    self.lblPolishType.text = "Select Polish Type"
                    self.lblVennerType.text = "Select Veneer Type"
            
                    if value as! String == KEY_VANNER{
                        self.btnPolishType.backgroundColor = UIColor.clear
                        self.btnPolishType.alpha = 1.0
                        self.noRows = 6
                    }else{
                        
                        self.btnPolishType.backgroundColor = UIColor.lightGray
                           self.btnPolishType.alpha = 0.5
                  
                       self.noRows = 5
                    }
                    
                  self.setTextWithAsterisk(forTextValue: "Types of \(value)", inLableValue: self.lblHeaderCell4)
                    self.searchDropDownSeletedValueWith(forArrData: self.arrTempCalculateDictData, searchKey: value as? String, keyValue: KEY_SERFACE)
                }
                
            }
        }
        else{
            
        }
    }

    @IBAction func actionSeletedCVenner(_ sender: UIButton) {
   
        if arrVannerData.count > 0{
            GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrVannerData, position: .bottom , pickerTitle: "", preSelected: "") { (value, index) in
                if ((value) as! String == ""){
                    self.lblVennerType.textColor = UIColor.lightGray
                    self.lblVennerType.text = "Select Veneer Type"
                }
                    
                else{
                       self.lblVennerType.textColor = UIColor.black
                    self.lblVennerType.text = value as? String
                    self.strVannerValue = (value as? String)!
                    self.searchDropDownSeletedValueWith(forArrData: self.arrTempVannerDictData, searchKey: value as? String, keyValue: KEY_VANNER)
                }
                
            }
        }
        else{
            
        }
    }

    @IBAction func actionSeletedPolish(_ sender: UIButton) {
    
        if arrPolishData.count > 0 {
            GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrPolishData, position: .bottom , pickerTitle: "", preSelected: "") { (value, index) in
                if ((value) as! String == ""){
                     self.lblPolishType.textColor = UIColor.lightGray
                    self.lblPolishType.text = "Select Polish Type"
                }
                    
                else{
                       self.lblPolishType.textColor = UIColor.black
                    self.lblPolishType.text = value as? String
                    self.strPolishValue = (value as? String)!
                    self.searchDropDownSeletedValueWith(forArrData: self.arrTempPolishDictData, searchKey: value as? String, keyValue: KEY_POLISH)
                }
                
            }
        }
        
        
        else{
            
        }
    
    }
    
    @IBAction func actionCalculate(_ sender: UIButton) {
   
        if !(self.ValidateFieldsWithNoCount(forNoRows: noRows!))
        {
            print(" some thing is missing")
            return;
        }
        
        self.clculatorAttributesCostApiCalling()
        
}
 // This Function Set text  Value With asterisk
    
    func setTextWithAsterisk(forTextValue strTextValue: String?, inLableValue: UILabel?){
        let text = "\(strTextValue!)*"
        
        let range = (text as NSString).range(of: "*")
        
        let attributedString = NSMutableAttributedString(string:text)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: range)
        
        inLableValue!.attributedText = attributedString
        

    }
    
   
 // MARK:- This Function Parsing the response value
    
    func parseResponseAttributesValuesWith(forArrResponseData pData:[AnyObject]?, KeyValue: String? ){
      var arrTempSerface = [AnyObject]()
        if KeyValue == KEY_FURNITURE{
         // parse furniture and size
        for index in 0..<pData!.count {
       let dictValue = pData![index] as! [String : AnyObject]
        // Temp Store Store data
         self.arrTempFunitureDictData.append(dictValue as AnyObject)
   
            
            let funtName = (dictValue["name"] as! String) + "(" + (dictValue["size_label"] as! String) + ")"
      
         self.arrFunitureData.append(funtName)
          
      
        }
     
        }
        // pase serface and plywood
        else if KeyValue == KEY_PLY_SERFACE{
            for index in 0..<pData!.count {
                let dictValue = pData![index] as! [String : AnyObject]
                 self.arrTempCalculateDictData.append(dictValue as AnyObject)
                switch dictValue["type"] as! String {
                case "ply":
                    arrPlywoodData.append(dictValue["name"] as! String)
               
                 case "surface":
                    
                arrTempSerface.append(dictValue as AnyObject)
                self.arrSurfaceData = self.parseSerfaceValueWith(forArrSurface: arrTempSerface)
                case "fitting":
                    arrTempFittingsDictData.append(dictValue as AnyObject)
                    arrFittingsData.append(dictValue["name"] as! String)
                    
                default: break
                    
                }
            }
            
        }
        
        else if KeyValue == KEY_VANNER {
            self.arrVannerData.removeAll()
            self.arrTempVannerDictData.removeAll()
            
            for index in 0..<pData!.count {
                let dictValue = pData![index] as! [String : AnyObject]
                // Temp Store Store data
                self.arrTempVannerDictData.append(dictValue as AnyObject)
                self.arrVannerData.append(dictValue["name"] as! String)
            }
        }
        else if KeyValue == KEY_POLISH{
            
            self.arrPolishData.removeAll()
            self.arrTempPolishDictData.removeAll()
            for index in 0..<pData!.count {
                let dictValue = pData![index] as! [String : AnyObject]
                // Temp Store Store data
                self.arrTempPolishDictData.append(dictValue as AnyObject)
                self.arrPolishData.append(dictValue["name"] as! String)
            }
        }
        
    self.tableView.reloadData()
    }
  
  // Mark:- This FunctionParse Only Surface if parent  = 0
    func parseSerfaceValueWith(forArrSurface pData:[AnyObject]?)-> [String]{
        var arrResult = [String]()
        for index in 0..<pData!.count {
            let dictValue = pData![index] as! [String : AnyObject]
            if dictValue["parent"] as! Int == 0 {
                arrResult.append(dictValue["name"] as! String)
            }
            
        }
        return arrResult

    }
    
  // MARk:- This Function Set the dropDown Picker Value
   
    func searchDropDownSeletedValueWith(forArrData pData:[AnyObject]?, searchKey: String?, keyValue:String?){
        
        if keyValue == KEY_FURNITURE{
            let name = NSPredicate(format: "name contains[c] %@", searchKey!)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
            let filteredArray = pData!.filter { compoundPredicate.evaluate(with: $0) }
            let dict = filteredArray.first
        
            self.strFunitureSizeValue =  (dict!["size"] as? String)!

            print("Find Dict \(dict)")
        }
        
        else if keyValue == KEY_PLYWOOD{
         
            let name = NSPredicate(format: "name contains[c] %@", searchKey!)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
            let filteredArray = pData!.filter { compoundPredicate.evaluate(with: $0) }
            let dict = filteredArray.first
            strPlyWoodTypeValue = (dict!["price"] as? String)!
            print("Find Dict \(dict)")
            
        }
            
            else if keyValue == KEY_FITTINGS{
            
            let name = NSPredicate(format: "name contains[c] %@", searchKey!)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
            let filteredArray = pData!.filter { compoundPredicate.evaluate(with: $0) }
            let dict = filteredArray.first
            strFittingsValue = (dict!["price"] as? String)!
            print("Find Dict \(dict)")
            
        }
        else if keyValue == KEY_SERFACE{
         
            let name = NSPredicate(format: "name contains[c] %@", searchKey!)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
            let filteredArray = pData!.filter { compoundPredicate.evaluate(with: $0) }
            let dict = filteredArray.first
            print("Find Dict \(dict)")
            strSurfaceTypeValue = (dict!["price"] as? String)!
            if dict!["name"] as? String == KEY_VANNER{
                self.btnPolishType.isUserInteractionEnabled = true
            }else{
                self.btnPolishType.isUserInteractionEnabled = false
  
            }
            self.getAllVannerAttributesApiCalling(forSerfaceID: dict!["id"] as? Int, keyValue: dict!["name"] as? String)
            }
        
        
        else if keyValue == KEY_VANNER{
            
            let name = NSPredicate(format: "name contains[c] %@", searchKey!)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
            let filteredArray = pData!.filter { compoundPredicate.evaluate(with: $0) }
            let dict = filteredArray.first
            strVannerValue = (dict!["price"] as? String)!
            print("Find Dict \(dict)")
            
        }
        
            
        else if keyValue == KEY_POLISH{
            
            let name = NSPredicate(format: "name contains[c] %@", searchKey!)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
            let filteredArray = pData!.filter { compoundPredicate.evaluate(with: $0) }
            let dict = filteredArray.first
            strPolishValue = (dict!["price"] as? String)!
            print("Find Dict \(dict)")
            
        }
        
    }
    // mark-  ValidateFields
    func ValidateFieldsWithNoCount(forNoRows noRowsValue:Int) -> Bool
    {	let result = true
        if noRowsValue == 5{
            if self.strFunitureValue == "" {
                Toast.show(withMessage: SELECT_FURNITURE_TYPE)
                return false
            }
                
           else if self.strPlyWoodTypeValue == "" {
                Toast.show(withMessage: SELECT_PLYWOOD_TYPE)
                return false
            }
            else if self.strFittingsValue == "" {
                Toast.show(withMessage: SELECT_FITTINGS_SIZE)
                return false
            }
                
            else if self.strSurfaceTypeValue == "" {
                Toast.show(withMessage: SELECT_SERFACE_TYPE)
                return false
            }
            else if self.strVannerValue == "" {
                Toast.show(withMessage: SELECT_VENEER_TYPE)
                return false
            }
 
        }
        else{
            
            if self.strFunitureValue == "" {
                Toast.show(withMessage: SELECT_FURNITURE_TYPE)
                return false
            }
          
            else if self.strPlyWoodTypeValue == "" {
                Toast.show(withMessage: SELECT_PLYWOOD_TYPE)
                return false
            }
            else if self.strFittingsValue == "" {
                Toast.show(withMessage: SELECT_FITTINGS_SIZE)
                return false
            }
            else if self.strSurfaceTypeValue == "" {
                Toast.show(withMessage: SELECT_SERFACE_TYPE)
                return false
            }
            else if self.strVannerValue == "" {
                Toast.show(withMessage: SELECT_VENEER_TYPE)
                return false
            }
            else if self.strPolishValue == "" {
                Toast.show(withMessage: SELECT_POLISH_TYPE)
                return false
            }
       
        }
        
     
        return result
    }
   
//    func ValidateFieldsWith() -> Bool
//    {
//    
//    }
}

// MARK:- TAbleView Delegte And DataSource
extension CalculateCostViewController {
// override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
// 
//    return noRows!
//    
//    }
//override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//   var cell: UITableViewCell?
//    if indexPath.row == noRows{
//    cell = tableView.dequeueReusableCellWithIdentifier("cell6", forIndexPath: indexPath)
//   
//    
//    }
//    else{
//        cell = tableView.dequeueReusableCellWithIdentifier(String(arrcellIdentifier[indexPath.row]), forIndexPath: indexPath)
//    
//    }
//    
//    return cell!
//    
//
//    }
override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return IS_IPAD() ? 125 : 90
    }
   
    
}
// MARK:- Working on Api Callig
extension CalculateCostViewController {
// This APi gives only Furniture and Furniture Size
    func getAllFurnitureTypeAttributesApiCalling(){
     
        APIHandler.handler.getAllFurnitureTypeAttributes({ (response) in
         
            
            
            let pRsponseData = response?["furniture"].arrayObject
              self.getAllgetCalculateTypeAttributesApiCalling()
            self.parseResponseAttributesValuesWith(forArrResponseData: pRsponseData! as [AnyObject], KeyValue:KEY_FURNITURE)
            
        }) { (error) in
            
        }
        
    }
    
  //This APi gives serface, plywood value
    func getAllgetCalculateTypeAttributesApiCalling(){
        APIHandler.handler.getAllCalculatorTypeAttributes({ (response) in
            
            let pRsponseData = response?["attributes"].arrayObject
            self.parseResponseAttributesValuesWith(forArrResponseData: pRsponseData! as [AnyObject], KeyValue:KEY_PLY_SERFACE)

        }) { (error) in
            
        }
    }
    // This Api Gives All Vanner Arributs Value
    func getAllVannerAttributesApiCalling(forSerfaceID pSerfaceID:Int?, keyValue: String?){
        APIHandler.handler.getAllVannerTypeAttributes(forSerfaceID: pSerfaceID!, success: { (response) in
            
    
             let pRsponseData = response?["attributes"].arrayObject
            self.parseResponseAttributesValuesWith(forArrResponseData: pRsponseData as! [AnyObject], KeyValue: KEY_VANNER)
            
            if keyValue == KEY_VANNER{   // Call polish attribute Api
            self.getAllPolishAttributesApiCalling(forSerfaceID: pSerfaceID!)
            }
          
            }) { (error) in
                
        }
    }
    
    
    // This Api Gives All Polish Arributs Value
    func getAllPolishAttributesApiCalling(forSerfaceID pSerfaceID:Int?){
        APIHandler.handler.getAllPolishTypeAttributes(forSerfaceID: pSerfaceID!, success: { (response) in
            let pRsponseData = response?["attributes"].arrayObject
            self.parseResponseAttributesValuesWith(forArrResponseData: pRsponseData as! [AnyObject], KeyValue: KEY_POLISH)
      
            
        }) { (error) in
            
        }
    }
    func clculatorAttributesCostApiCalling(){
      APIHandler.handler.calculatorCostOfAttributes(forFurnitureSize: strFunitureSizeValue, surfacePrice: strVannerValue, plyWoodPrice: strPlyWoodTypeValue, fittingPrice: strFittingsValue, polishPrice: strPolishValue, success: { (response) in
        
        let dictObj = response?["total"].dictionaryObject
 
        CalculatePopUpViewController.showAddOrClearPopUp(NavigationHelper.helper.mainContainerViewController!, pDictValue:dictObj! as [String : AnyObject]) {
            
        }
        
        
     
      }) { (error) in
        
        }
    }
    
}
