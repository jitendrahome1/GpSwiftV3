//
//  TagViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 08/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
@objc protocol SkillsTagsDeleagte{
    
    @objc optional func didFinishSelectedSkills(forSelectedAllTags pArrTags:[AnyObject])
    
}
import UIKit

class TagViewController: BaseViewController {

    @IBOutlet weak var tagViewDescription: KSTokenView!
    
  
    
    var list = [String]()
    var isSearch: Bool?
    var delegateSkills: SkillsTagsDeleagte?
    var arrTagsResult = [AnyObject]()
    var arrAllTagsID = [AnyObject]()
    var arrSkils = [AnyObject]()
    var arrResultTagsData = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagViewDescription.layer.borderWidth = 1.0
        tagViewDescription.layer.borderColor = UIColor.darkGray.cgColor
        
        tagViewDescription.style = .squared
        tagViewDescription.delegate = self
        tagViewDescription.searchResultSize = self.view.frame.size
        
        
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_SKILLS

            NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
      
                     NavigationHelper.helper.enableSideMenuSwipe = false
        
            NavigationHelper.helper.tabBarViewController!.hideTabBar()
        
        
        
        getAllSkillsList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        if arrResultTagsData.count > 0{
            self.delegateSkills?.didFinishSelectedSkills!(forSelectedAllTags:self.arrResultTagsData)
           // NavigationHelper.helper.contentNavController?.popViewControllerAnimated(true)
        }
        
        NavigationHelper.helper.contentNavController?.popViewController(animated: true)

    }
}


//MARK:- Api Call SkillList
extension TagViewController {
    func getAllSkillsList() {
        APIHandler.handler.getSkillList({ (response) in
            
            self.arrTagsResult = response!["Skill"].arrayObject! as [AnyObject]
            if self.arrTagsResult.count > 0 {
                for value in (response?["Skill"].arrayObject!)! {
                    let objTags = SkillTags(withDictionary: value as! [String: AnyObject])
                    
                    
                    let dictTemp = ["skill_name":objTags.skillName!, "id":objTags.tagID!] as [String : Any]

                    
                    
                    self.arrSkils.append(dictTemp as AnyObject)
                    self.list.append(objTags.skillName!)
                }
                debugPrint("AddIdeaTags ==>\(self.arrSkils)")
            }
        }) { (error) in
        }
    }
}



extension TagViewController: KSTokenViewDelegate {
    func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        var data: Array<String> = []
        for value: String in list {
            if value.lowercased().range(of: string.lowercased()) != nil {
                data.append(value)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        let idea = (object as! String).components(separatedBy: "+")
  
        
        
        return idea[0]
    }
    
    func tokenView(_ tokenView: KSTokenView, didAddToken token: KSToken) {
//        if isSearch == true {
//            self.getTagsID(self.arrTagsResult, keySearch: String(token))
//        }
//        isSearch = false
//        debugPrint(token)
        
        
          self.addSkillsWith(self.arrSkils, keySearch: String(describing: token))
        
        
        
        
    }
    
    func tokenView(_ token: KSTokenView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.isSearch = true
        
    }
    
    func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
        self.removeTagsID(self.arrSkils, keySearch: String(describing: token))
        debugPrint(token)
    }
    
    //MARK:- Remove Tags
    func removeTagsID(_ pArry: [AnyObject], keySearch: String)
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        let dict = filteredArray.first
        
        if let dictFilter = dict {
            if let _ = dict!["id"] {
                let index = dictFilter["id"] as! Int
                self.arrResultTagsData.removeObject(index)
            }
        }
    }
    
//    //MARK:- GetTagIDs
//    func getTagsID(pArry: [AnyObject], keySearch: String)
//    {
//       
//      
//        
//
//        
//        
//        
//        
//        
//        
//        let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
//        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
//        let filteredArray = pArry.filter { compoundPredicate.evaluateWithObject($0) }
//        let dict = filteredArray.first
//        
//        if let dictFilter = dict {
//            if let _ = dict!["id"] {
//                self.arrAllTagsID.append(dictFilter["id"] as! Int)
//            }
//        }
//    }
    
    
    // Add skills ID
    func addSkillsWith(_ pArry: [AnyObject], keySearch: String)
    {   var dictTemp = [String: AnyObject]()
        // var arrSelectedSkillsID = [String]()
        let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        
        if filteredArray.count > 0{
            let dict = filteredArray.first
            
            if let dictFilter = dict {
                if let _ = dict!["id"] {
                   // let index = dictFilter["id"] as! Int
                    
                   // arrSeletedSkillsID.append(String(index))
                    dictTemp = ["skill_name":dictFilter["skill_name"]!! as AnyObject, "id":dictFilter["id"] as! Int as AnyObject]
                    self.arrResultTagsData.append(dictTemp as AnyObject)
                    
                }
            }
        }else{
            dictTemp = ["skill_name":keySearch as AnyObject, "id":0 as AnyObject]
            //arrSeletedSkillsID.append(keySearch)
            self.arrResultTagsData.append(dictTemp as AnyObject)
        }
        
        
        
        
    }
    
    
    
}

