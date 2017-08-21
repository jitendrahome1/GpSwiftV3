//
//  CertificateCellCustom.swift
//  Greenply
//
//  Created by Jitendra on 4/5/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class CertificateTableCellCustom: BaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    var CellHight: Float?
    var CellWidth: Float?
     var arrItems = [AnyObject]()
    @IBOutlet weak var aCollectionView: UICollectionView!
    var didButtonHanderResponse: ((_ imageID: Int?, _ IndexValue:Int?, _ keyValueData: String?) -> ())?
  
    var dataSource: [AnyObject]? {
        didSet {
            debugPrint(self.dataSource)
            aCollectionView.reloadData()
        }
    }
    
//    override var datasource: AnyObject? {
//        didSet {
//            // debugPrint(datasource![0])
//            aCollectionView.reloadData()
//        }
//    }
    
    override func awakeFromNib() {
       
    self.aCollectionView.register(UINib(nibName: "CertificateCollectionCustomCell", bundle: nil), forCellWithReuseIdentifier: "CertificateCollectionCustomCell")
  
        CellHight = IS_IPAD() ? 150 : 120
        CellWidth = IS_IPAD() ? 175 : 120
        aCollectionView.delegate = self
        aCollectionView.dataSource = self
       // self.setupCollectionView()
  
    }

}
// MARK:- Collection View Delegate
extension CertificateTableCellCustom  {
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        //layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
        aCollectionView.collectionViewLayout = layout
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
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CertificateCollectionCustomCell.self), for: indexPath) as! CertificateCollectionCustomCell
        cell.indexValueTemp = indexPath.row
        cell.datasource = self.dataSource![indexPath.row]
        cell.didTapButtonHanderImage = {(imageID,getIndexValue, keyValue)in
            self.didButtonHanderResponse!(imageID!, getIndexValue!, keyValue!)
        }
       
        
        return cell
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: IS_IPAD() ? CGFloat(CellWidth!): SCREEN_WIDTH / 2 - 20, height: IS_IPAD() ? CGFloat(CellHight!):SCREEN_WIDTH / 2 - 15.0 )
   
    }

}
