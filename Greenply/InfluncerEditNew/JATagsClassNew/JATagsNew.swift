//
//  JATagsNew.swift
//  Greenply
//
//  Created by Jitendra on 4/14/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class JATagsNew: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    var buttonTagsHandler:((_ dictValue: [String: AnyObject], _ indexValue: Int)->())?
 
    @IBOutlet weak var aTagCollectionsView: UICollectionView!
  
    
    
    
    
    var dataSource: [AnyObject]? {
        didSet {
            debugPrint(self.dataSource)
       
            aTagCollectionsView.reloadData()
        }
    }
    
    
    
//    override var datasource: AnyObject? {
//        didSet {
//            if self.datasource != nil{
//                
//                print("Data Source \(datasource)")
//                
//                
//                
//            }
//        }
//    }

    override func awakeFromNib() {
        
        self.aTagCollectionsView.register(UINib(nibName: "JATagsItemsCell", bundle: nil), forCellWithReuseIdentifier: "JATagsItemsCell")
        
        self.aTagCollectionsView.reloadData()
//        aTagCollectionsView.delegate = self
//        aTagCollectionsView.dataSource = self
        self.setupCollectionView()
        
    }
    
    // Button Action
    
    func actionTagsSeleted(_ sender: UIButton){
//        let pointInTable: CGPoint  = sender.convertPoint(sender.bounds.origin, toView: self.aTagCollectionsView)
//        let cellIndexPath =  self.aTagCollectionsView.indexPathForItemAtPoint(pointInTable)
        let dict = self.dataSource![sender.tag]
        if buttonTagsHandler != nil{
            buttonTagsHandler!(dict as! [String : AnyObject],sender.tag)
            
        }

        
        
     
    }

}
extension JATagsNew  {
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
       layout.sectionInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
       // layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
        aTagCollectionsView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataSource != nil {
            return (dataSource?.count)!
        } else {
            return 0
        }


        // return self.dataSource!.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JATagsItemsCell.self), for: indexPath) as! JATagsItemsCell
       cell.btnTags.tag = indexPath.row
          cell.btnTags.addTarget(self, action:#selector(actionTagsSeleted), for:.touchUpInside)
          cell.datasource = self.dataSource![indexPath.row]
               return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let strTagsItems = self.dataSource![indexPath.row]["skill_name"] as! String
        
      let tagsWidth =   strTagsItems.requiredWidth(forHeight: 30, andFont: PRIMARY_FONT(IS_IPAD() ? 16 : 14)!)
       
        
        
        return CGSize(width: tagsWidth + 35,height: 30)
        
  
    }
    }
