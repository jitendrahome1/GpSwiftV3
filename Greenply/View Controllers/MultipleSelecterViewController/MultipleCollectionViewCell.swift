//
//  MultipleSelectionCell.swift
//  Greenply
//
//  Created by Jitendra on 9/15/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MultipleCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var tblMultpleSelection: UITableView!
    var arrayName = [String]()
    var arrayValueCode = [String]()
    var dataFilter: ((_ item: Int, _ index: IndexPath, _ valuecode: String)->())?

    var dataSource: [AnyObject]? {
		didSet {
            debugPrint(dataSource)
            arrayName.removeAll()
            arrayValueCode.removeAll()
            for value in dataSource! {
                let objFilter = value as! UserFilterAttribute
                arrayName.append(objFilter.name!)
                arrayValueCode.append(objFilter.value_Code!)
                
            }
			tblMultpleSelection.tableFooterView = UIView()
			tblMultpleSelection.reloadData()
		}
	}
    
    override var datasource: AnyObject? {
        didSet {
            
        }
    }
}


extension MultipleCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil {
            return dataSource!.count
        } else {
            return 0
        }
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseTableViewCell?
		cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MultipleSelectionTableCell.self)) as! MultipleSelectionTableCell
        (cell as? MultipleSelectionTableCell)?.labelTitleName.text = arrayName[indexPath.row]
              // (cell as? MultipleSelectionTableCell)?.buttonCheckBox.selected =  false
		return cell!

	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return IS_IPAD() ? 55 : 50

	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currentCell: BaseTableViewCell?
        currentCell = tableView.cellForRow(at: indexPath)! as! MultipleSelectionTableCell
      
        
        (currentCell as? MultipleSelectionTableCell)?.datasource = true as AnyObject?
        self.dataFilter!(datasource as! Int, indexPath, arrayValueCode[indexPath.row])
        
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = .clear
	}
}
