//
//  addButtonViewController.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 10/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class addButtonViewController: UIViewController {

    
    @IBOutlet weak var lightPicture: UIImageView!
    @IBOutlet weak var addLightTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    
    @IBAction func addLightTextField(_ sender: Any) {
    }
    
    func presentCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = self
        self.present(cameraPicker, animated: true)
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(title: "Need Camera Access", message: "Camera Access is Needed for Picture Lighting Control System", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel,
                                              handler: {(alert) -> Void in UIApplication.shared.open(settingsAppURL, options: [:], completionHandler:nil)}))
        present(alert, animated: true, completion: nil)
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in guard accessGranted == true else {return}; self.presentCamera()})
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if titleLabel.text != nil {
            var light = UserDefaults.standard.object(forKey: "Lights") as! [String]
            light.append(addLightTextField.text!)
            print("list:", light)
            UserDefaults.standard.set(light, forKey: "Lights")
            if lightPicture.image != nil {
                let imageData = lightPicture.image!.jpegData(compressionQuality: 0.0)
                let encodedImage = imageData?.base64EncodedString()
                //print(encodedImage)
                UserDefaults.standard.set(imageData, forKey: addLightTextField.text!)
                UserDefaults.standard.set(encodedImage, forKey: "encodedImage")
            }
        }
        performSegue(withIdentifier: "backToLightListScreen", sender: self)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case.authorized:
                    let myImagePickerController = UIImagePickerController()
                    myImagePickerController.delegate = self
                    myImagePickerController.sourceType = .photoLibrary
                    self.present(myImagePickerController, animated: true)
                default :
                    break
                }
            }
        }
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case.authorized: presentCamera()
        case.restricted,.denied: alertCameraAccessNeeded()
        case.notDetermined: requestPermission()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.addShadowAndRoundedCorners()
        lightPicture.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
}

extension addButtonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            lightPicture.image = photo
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}
