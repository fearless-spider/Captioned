//
//  UserProfileManager.swift
//  Captioned
//
//  Created by Przemysław Pająk on 14.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import Foundation
import RSKImageCropper
import Bolts

public protocol UserProfileManagerDelegate: class {
    func selectedAvatar(avatar: UIImage)
}

public class UserProfileManager: NSObject {
    
    static let ImageMinimumSideSize: CGFloat = 120
    static let ImageMaximumSideSize: CGFloat = 400
    
    var viewController: UIViewController!
    var delegate: UserProfileManagerDelegate?
    var imagePicker: UIImagePickerController!
    
    public func initWith(controller: UIViewController, delegate: UserProfileManagerDelegate) {
        self.viewController = controller
        self.delegate = delegate
    }
    
    public func selectAvatar() {
        selectImage()
    }
    
    func selectImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            if imagePicker == nil {
                imagePicker = UIImagePickerController()
            }
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Internal functions
    
    func avatarThumbImageToPFFile(avatar: UIImage) -> NSData {
        let thumbAvatar = UIImage.imageWithImage(image: avatar, newSize: CGSize(width: UserProfileManager.ImageMinimumSideSize, height: UserProfileManager.ImageMinimumSideSize))
        let avatarThumbData = UIImagePNGRepresentation(thumbAvatar)
        return avatarThumbData! as NSData
    }
    
    func avatarRegularImageToPFFile(avatar: UIImage) -> NSData {
        let regularAvatar = UIImage.imageWithImage(image: avatar, maxSize: CGSize(width: UserProfileManager.ImageMaximumSideSize, height: UserProfileManager.ImageMaximumSideSize))
        let avatarRegularData = UIImagePNGRepresentation(regularAvatar)
        return avatarRegularData! as NSData
    }
    
}

extension UserProfileManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        viewController.dismiss(animated: true, completion: { () -> Void in
            
            if image.size.width < UserProfileManager.ImageMinimumSideSize || image.size.height < UserProfileManager.ImageMinimumSideSize {
                self.viewController.presentBasicAlertWithTitle(title: "Pick a larger image", message: "Select an image with at least 120x120px")
            } else {
                let imageCropVC: RSKImageCropViewController!
                
                imageCropVC = RSKImageCropViewController(image: image)
                
                imageCropVC.delegate = self
                self.viewController.present(imageCropVC, animated: true, completion: nil)
            }
        })
    }
}

extension UserProfileManager: RSKImageCropViewControllerDelegate {
    public func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        controller.dismiss(animated: true, completion: nil)
        
        delegate?.selectedAvatar(avatar: croppedImage)
    }
    
    public func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UserProfileManager: RSKImageCropViewControllerDataSource {
    
    public func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        let imageHeight: CGFloat = 120
        let yPosition = (viewController.view.bounds.size.height - imageHeight) / 2
        return CGRect(x: 0, y: yPosition, width: viewController.view.bounds.size.width, height: imageHeight)
    }
    
    public func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        let imageHeight: CGFloat = 120
        let yPosition = (viewController.view.bounds.size.height - imageHeight) / 2
        return UIBezierPath(rect: CGRect(x: 0, y: yPosition, width: viewController.view.bounds.size.width, height: imageHeight))
    }
    
    public func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
}
