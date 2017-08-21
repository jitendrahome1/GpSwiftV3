//
//  ImageViewController.swift
//  Greenply
//
//  Created by Jitendra on 10/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ImageViewController: BaseViewController {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageView: UIImageView!
	var objIdeaDetails: IdeaListing!
    
    var imageURl: String?
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.scrollView.minimumZoomScale = 1.0;
		self.scrollView.maximumZoomScale = 8.0;

        imageView.contentMode = .scaleAspectFit
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
	NavigationHelper.helper.headerViewController?.labelHeaderTitle.text = "Image"
		
		NavigationHelper.helper.enableSideMenuSwipe = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		NavigationHelper.helper.enableSideMenuSwipe = true
	}
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
//        imageView.setImage(withURL: NSURL(string: objIdeaDetails.ideaImageOriginal!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .CrossDissolve(0.4))
     
        
        if let  _ =  imageURl{
        imageView.setImage(withURL: URL(string: imageURl!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .crossDissolve(0.4))
        }else{
            imageView.image = UIImage(named: "DefultProfileImage")
        }
    }
}



extension ImageViewController {
//MARK:- UIScrollViewDelegate Delegate

	func viewForZoomingInScrollView(_ scrollView: UIScrollView) -> UIView?
	{
		return self.imageView
	}
}
