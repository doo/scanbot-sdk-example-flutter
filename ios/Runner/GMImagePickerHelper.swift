//
//  GMImagePickerHelper.swift
//  Runner
//
//  Created by Mayank Patil on 11/02/22.
//  Copyright © 2022 The Chromium Authors. All rights reserved.
//
import Foundation
import UIKit
import GMImagePicker
import Flutter
import AVFoundation
/**
 - GMImagePicker Helper class
 Helps in picking image for the older versions of iOS
 */
class GMImagePickerHelper : NSObject, GMImagePickerControllerDelegate {
    
    let IMAGE_PICKER_CHANNEL_NAME = "imagePicker_old_version_ios"
    var result : FlutterResult?
    public override init() {
        super.init()
        self.initGMImagePickerHelper()
    }
    
    /** Finish selecting photos from Photos App */
    public func assetsPickerController(_ picker: GMImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        // background thread
        DispatchQueue.global(qos: .background).async {
            if assets is [PHAsset] {
                let paths = self.getAbsoluteUrl(assets: assets as! [PHAsset])
                DispatchQueue.main.async {
                    // main thread
                    let resultData : [String:Any] = ["uris":paths]
                    self.result?(resultData.jsonString)
                    picker.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    /** Photos app cancelled */
    func assetsPickerControllerDidCancel(_ picker: GMImagePickerController!) {
        self.result?([])
        picker.dismiss(animated: true, completion: nil)
    }
    
    /** Init the image picker helper class */
    func initGMImagePickerHelper() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let controller = appDelegate?.window?.rootViewController as? FlutterViewController {
            
            let imagePickerChannel = FlutterMethodChannel(name: IMAGE_PICKER_CHANNEL_NAME,binaryMessenger: controller.binaryMessenger);
            imagePickerChannel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                DispatchQueue.main.async {
                    if call.method == "pickImagesFromPhotosApp" {
                        self.result = result
                        self.pickImagesFromPhotosApp()
                    } else if call.method == "versionLessThanIOSFourteen"{
                        result(self.versionLessThanIOSFourteen())
                    }
                }
            })
        }
    }
    
    /** Opens the pickerViewController to show Photos App View */
    private func pickImagesFromPhotosApp() {
        
        let picker = GMImagePickerController()
        picker.delegate = self
        picker.title = "Select"
        picker.allowsMultipleSelection = true
        picker.displaySelectionInfoToolbar = true
        picker.displayAlbumsNumberOfAssets = true
        picker.modalPresentationStyle = .fullScreen
        // below line is added to avoid/fix a library specific crash
        picker.navigationController?.toolbar?.addSubview(UIView())
        
        if let viewController = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController {
            viewController.present(picker, animated: true, completion: nil)
        }
    }
    
    /** Get the absolute url from the image path */
    func getAbsoluteUrl(assets: [PHAsset]) -> [String] {
        var paths: [String] = []
        
        let group = DispatchGroup()
        var path = ""
        for asset in assets {
            group.enter()
            asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: {(data,args) in
                path = data?.fullSizeImageURL?.path ?? ""
                group.leave()
            })
            group.wait()
            paths.append(path)
        }
        return paths
    }
    
    /**
     Is version less than iOS 14
     */
    func versionLessThanIOSFourteen() -> String {
        if #available(iOS 14, *) {
            return "false"
        } else {
            return "true"
        }
    }
}

/** Extension added for json conversion*/
extension Dictionary {
    
    var jsonString: String? {
        if let json = try? JSONSerialization.data(withJSONObject: self) {
            let convertedString = String(data: json, encoding: String.Encoding.utf8)
            return convertedString
        }
        return nil
    }
}
