//
//  LicenseTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class LicenseTableViewCell: BaseTableViewCell {

    @IBOutlet weak var collectionViewLicense: UICollectionView!
    var didSelectCollectionCell:(() -> ())?
    var isFirstTime: Bool?
    var editProf: Bool?

    var dataSource: [AnyObject]? {
        didSet {
            debugPrint(self.dataSource)
            collectionViewLicense.reloadData()
        }
    }
    
    override var datasource: AnyObject? {
        didSet {
           // debugPrint(datasource![0])
            collectionViewLicense.reloadData()
        }
    }
}


extension LicenseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.dataSource != nil {
            return self.dataSource!.count
        } else {
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionCell()), for: indexPath) as! CollectionCell
        cell.editProf = editProf
        if self.dataSource != nil {
            cell.datasource = dataSource![indexPath.item]
        }
        cell.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        cell.layer.borderWidth = IS_IPAD() ? 2.0 : 3.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.masksToBounds =  true
      
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
       return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && String(describing: dataSource![0]) == "AddPictureIcon" {
            if didSelectCollectionCell != nil {
                didSelectCollectionCell!()
            }
        }
    }
}
