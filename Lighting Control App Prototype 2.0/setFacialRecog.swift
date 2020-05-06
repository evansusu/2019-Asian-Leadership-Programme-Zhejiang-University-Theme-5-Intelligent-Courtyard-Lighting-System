//
//  setFacialRecog.swift
//  Lighting Control App Prototype 1.5
//
//  Created by Cornelius Yap on 27/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import SwiftSocket

class setFacialRecog: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        client = TCPClient(address: host, port: Int32(port))

    }
    
    @IBOutlet weak var userPicture: UIImageView!
    
    let host = "192.168.2.146"
    let port = 4001
    var client: TCPClient?
    
    
    @IBAction func backButton(_ sender: Any) {
        if client != nil {
            _ = client!.send(string: "EXIT")
            print("Closing Socket")
            client!.close()
        }
    }
    
    @IBAction func setFaceIdButton(_ sender: Any) {
        guard let client = client else { return }
        switch client.connect(timeout: 10) {
        case .success:
            print("Connected to host \(client.address)")
            _ = sendRequest(string: "UserID: \(dataClass.userID!)\n", using: client)
            if userPicture.image != nil {
                print("Attempting to resize Image")
                let resizedImage = resizeImage(image: userPicture.image!, targetSize: CGSize(width:240.0 ,height: 160.0))
                print("Attempting to convert Image")
                let userPictureData = resizedImage.pngData()
                print("Attempting to encode Image")
                let encodedUserPicture = userPictureData?.base64EncodedString()
                print("Attempting to send Image")
                _ = client.send(string: encodedUserPicture!)
                _ = client.send(string: "\n")
                print("Image has been sent")

            }
        case .failure(let error):
            print(String(describing: error))
        }
    }
    
    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        print("Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            print(String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*10) else { return nil }
        
        return String(bytes: response, encoding: .utf8)
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
    
    
    @IBAction func cameraButton(_ sender: Any) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case.authorized: presentCamera()
        case.restricted,.denied: alertCameraAccessNeeded()
        case.notDetermined: requestPermission()
        }
    }
    
    
    @IBAction func photoButton(_ sender: Any) {
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
    
}


extension setFacialRecog: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userPicture.image = photo
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}
