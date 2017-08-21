//
//  GPPickerViewController.swift
//  Greenply
//
//  Created by Chinmay Das on 26/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

public enum PickerPosition {
    case center
    case bottom
}

class GPPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerView: UIView!
    @IBOutlet var labelSetDate: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var listPicker: UIPickerView!
    var listPickerArray = [String]()
    var pickerSelected: ((_ value: AnyObject?, _ index: Int?) -> ())?
    var selectedValue: AnyObject!
    var selectedIndex: Int!
    var isDatePicker = false
    var preValue: String?
    var preIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTap(_:))))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    internal class func showPickerController(_ sourceViewController: UIViewController, isDatePicker: Bool, pickerArray: [String], position: PickerPosition, pickerTitle: String, preSelected: String, selected: @escaping (_ value: AnyObject?, _ index: Int?) -> ()) {
        if !isDatePicker && pickerArray.count == 0 {
            Toast.show(withMessage: NO_LISTING)
            return
        }
        let viewController = otherStoryboard.instantiateViewController(withIdentifier: String(describing: GPPickerViewController.self)) as! GPPickerViewController
        viewController.pickerSelected = selected
        viewController.isDatePicker = isDatePicker
        
        viewController.presentPickerWith(sourceViewController, isDatePicker: isDatePicker, pickerArray: pickerArray,position:position, pickerTitle: pickerTitle, preSelected: preSelected)
    }
    
    func presentPickerWith(_ sourceController: UIViewController, isDatePicker: Bool, pickerArray: [String], position: PickerPosition, pickerTitle: String, preSelected: String) {
        self.view.frame = UIScreen.main.bounds
        UIApplication.shared.windows.first!.addSubview(self.view)
        sourceController.addChildViewController(self)
        self.didMove(toParentViewController: sourceController)
        sourceController.view.bringSubview(toFront: self.view)
        pickerView.translatesAutoresizingMaskIntoConstraints = true
        labelSetDate.text = pickerTitle
        if isDatePicker {
            datePicker.isHidden = false
            listPicker.isHidden = true
            self.datePicker.maximumDate = Date()
            selectedIndex = 0
            getDatePickerDate()
        } else {
            datePicker.isHidden = true
            listPicker.isHidden = false
            listPicker.delegate = self
            listPicker.dataSource = self
            listPickerArray.removeAll()
            listPickerArray = pickerArray
            selectedValue = listPickerArray[0] as AnyObject!
            selectedIndex = 0
        }
        
                if !isDatePicker {
                    preValue = preSelected
                    if pickerArray.contains(preSelected) {
                        preIndex = pickerArray.index(of: preSelected)!
                        listPicker.selectRow(pickerArray.index(of: preSelected)!, inComponent: 0, animated: false)
                    }
                }
        if !IS_IPAD() {
            pickerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200.0)
        }
        pickerView.center = CGPoint(x: self.view.frame.midX, y: IS_IPAD() ? self.view.frame.midY : (SCREEN_HEIGHT - (pickerView.frame.height/2)))
        //presentAnimationToView()
        
        
        
//        if !isDatePicker {
//            preValue = preSelected
//            if pickerArray.contains(preSelected) {
//                preIndex = pickerArray.indexOf(preSelected)!
//                listPicker.selectRow(pickerArray.indexOf(preSelected)!, inComponent: 0, animated: false)
//            }
//        }
//        if !IS_IPAD() {
//            if position == .Center {
//                pickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 50 , 200.0)
//                pickerView.layer.cornerRadius = 10.0
//                pickerView.layer.masksToBounds = true
//            }else{
//                pickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200.0)
//            }
//        }else{
//            pickerView.layer.cornerRadius = 10.0
//            pickerView.layer.masksToBounds = true
//        }
//        if position == .Center {
//            pickerView.center = CGPoint(x: CGRectGetMidX(self.view.frame), y:CGRectGetMidY(self.view.frame))
//        }else if position == .Bottom{
//            pickerView.center = CGPoint(x: CGRectGetMidX(self.view.frame), y: (SCREEN_HEIGHT - (CGRectGetHeight(pickerView.frame) / 2)))
//        }
//        
        
        
        // Old Code
        
        //		if !IS_IPAD() {
        //			pickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200.0)
        //		}
        //		pickerView.center = CGPoint(x: CGRectGetMidX(self.view.frame), y: IS_IPAD() ? CGRectGetMidY(self.view.frame) : (SCREEN_HEIGHT - (CGRectGetHeight(pickerView.frame) / 2)))
        
        
        // End Old Code
        presentAnimationToView()
    }
    
    // MARK: - Picker View Delegate & Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listPickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: IS_IPAD() ? 24 : 16)
        let listArr = listPickerArray[row].components(separatedBy: "+")
        pickerLabel.text = listArr[0]
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = listPickerArray[row] as AnyObject!
        selectedIndex = row
    }
    
    // MARK: - Animation
    func presentAnimationToView() {
        pickerView.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView.transform = CGAffineTransform.identity
        }, completion: { (complete) in
        }) 
    }
    
    func dismissAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerView.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }, completion: { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }) 
    }
    
    func getDatePickerDate() {
        selectedValue = datePicker.date.dateToStringWithCustomFormat("dd-MM-yyyy") as AnyObject!
        labelSetDate.text = selectedValue as? String
    }
    
    // MARK: IBAction
    func didTap(_ gesture: UITapGestureRecognizer) {
        pickerSelected!(preValue as AnyObject?, preIndex)
        dismissAnimate()
    }
    
    @IBAction func dateSelectAction(_ sender: AnyObject) {
        pickerSelected!(selectedValue, selectedIndex)
        dismissAnimate()
    }
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
        getDatePickerDate()
    }
}
