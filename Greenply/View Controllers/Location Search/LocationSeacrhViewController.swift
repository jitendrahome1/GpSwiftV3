//
//  LocationSeacrhViewController.swift
//  Greenply
//
//  Created by Jitendra on 10/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
@objc protocol SelectCityDeleagte{

    @objc optional func didFinishCitySelected(_ selectCity: String?)
    
}
import UIKit
import MapKit
class LocationSeacrhViewController: BaseViewController {
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    fileprivate var responseData:NSMutableData?
    fileprivate var selectedPointAnnotation:MKPointAnnotation?
    fileprivate var dataTask:URLSessionDataTask?
    var delegateCity: SelectCityDeleagte?

    override func viewDidLoad() {
        super.viewDidLoad()
        autocompleteTextfield.becomeFirstResponder()
        self.backButtonEnabled = true
       self.setNavigationTitle(TITLE_SELECT_CITY)
        configureTextField()
        handleTextFieldInterfaces()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.black
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    fileprivate func handleTextFieldInterfaces(){
        
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text)
            }
        }
        
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
         
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                self?.view.endEditing(true)
                
                self!.delegateCity?.didFinishCitySelected!(text)
            	self!.navigationController?.popViewController(animated: true)
//                let location: CLLocation = (placemark?.location)!
//                let coordinate: CLLocationCoordinate2D = location.coordinate
              
            })
        }
    }
    
    fileprivate func fetchAutocompletePlaces(_ keyword:String) {
      
        let urlString = "\(GOOGLE_BASE_URL_STRING)?key=\(GOOGLE_MAP_KEY)&input=\(keyword)"
          CDSpinner.show(onViewControllerView:self.view)
        let s = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        s.addCharacters(in: "+&")
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s as CharacterSet) {
            if let url = URL(string: encodedString) {
                let request = URLRequest(url: url)
                dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        
                        do{
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                            
                            if let status = result["status"] as? String{
                                if status == "OK"{
                                    if let predictions = result["predictions"] as? NSArray{
                                        print("filter location ==\(predictions)")
                                        
                                        var locations = [String]()
                                        for dict in predictions as! [NSDictionary]{
                                            let city = (dict["description"] as! String).components(separatedBy: ",")
                                            if locations.contains(city[0]) {
                                                //............
                                            } else {
                                                 locations.append(city[0])
                                            }
                                        }
                                        
                                        DispatchQueue.main.async(execute: { () -> Void in
                                           CDSpinner.hide()
                                            self.autocompleteTextfield.autoCompleteStrings = locations
                                        })
                                        return
                                    }
                                }
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                 CDSpinner.hide()
                                self.autocompleteTextfield.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                             CDSpinner.hide()
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
                dataTask?.resume()
            }
        }
    }
}


