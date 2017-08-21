//
//  GPImagePickerController.swift
//  Greenply
//
//  Created by Chinmay Das on 23/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class GPImagePickerController: NSObject {
    
    let imagePicker: UIImagePickerController?
    var sourceViewController: UIViewController?
    var didPickImage:((_ image: UIImage) -> ())?
    var didCancelPicker:(() -> ())?
    
    static let controller = GPImagePickerController()
    fileprivate override init() {
        imagePicker = UIImagePickerController()
    }
    class func pickImage(onController sourceController:UIViewController, didPick:@escaping ((_ image: UIImage) -> ()), didCancel:@escaping (() -> ())){
        GPImagePickerController.pickImage(onController: sourceController, sourceRect: nil, didPick: didPick, didCancel: didCancel)
    }
    class func pickImage(onController sourceController:UIViewController, sourceRect: CGRect?, didPick:@escaping ((_ image: UIImage) -> ()), didCancel:@escaping (() -> ())){
        let picker = GPImagePickerController.controller
        picker.sourceViewController = sourceController
        picker.didPickImage = didPick
        picker.didCancelPicker = didCancel
        picker.imagePicker!.delegate = picker
        let alert = UIAlertController.showStandardActionSheetWith(APP_TITLE, messageText: "Choose source type", arrayButtons: ["Camera","Gallery"]) { (index) in
            picker.imagePicker!.allowsEditing = true
            switch index {
                case 0:
                    picker.imagePicker!.sourceType = .camera
                case 1:
                    picker.imagePicker!.sourceType = .photoLibrary
                default:break
            }
            debugPrint(picker.imagePicker!.delegate)
            picker.sourceViewController!.present(picker.imagePicker!, animated: true, completion: nil)
        }
        
        if IS_IPAD(){
        alert.popoverPresentationController?.sourceView = sourceController.view
            alert.popoverPresentationController?.sourceRect = (sourceRect != nil) ? sourceRect! : CGRect(x: sourceController.view.bounds.width/2, y: sourceController.view.bounds.height, width: 0, height: 0)
        }
        picker.sourceViewController!.present(alert, animated: true, completion: nil)
    }
}

extension GPImagePickerController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if didPickImage != nil {
            didPickImage!((info[UIImagePickerControllerEditedImage] as? UIImage)!)
        }
        GPImagePickerController.controller.sourceViewController!.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if didCancelPicker != nil {
            didCancelPicker!()
        }
        GPImagePickerController.controller.sourceViewController!.dismiss(animated: true, completion: nil)
    }
}
