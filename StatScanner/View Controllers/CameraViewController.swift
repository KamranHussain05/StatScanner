//
//  CameraViewController.swift
//  StatScanner
//
//  Created by Kaleb K on 8/22/22.
//

import UIKit
import AVFoundation

///Responsible for opening the camera when a picture is needed
class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
//    lazy private var backButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "xmark"), for: .normal)
//        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//        button.tintColor = .white
//        return button
//    }()
//
//    lazy private var takePhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraAuthorization()
    }
//    private func setupUI() {
//        view.addSubviews(backButton, takePhotoButton)
//
//        takePhotoButton.makeConstraints(top: nil, left: nil, right: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 15, width: 80, height: 80)
//        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        backButton.makeConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 50, height: 50)
//    }
    
    private func cameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("Camera access has already been granted, opening camera...")
            self.openCamera()
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("Camera access granted, opening camera...")
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                } else {
                    print("Camera access denied.")
                    self.handleDismiss()
                }
            }
        case .denied:
            print("Camera access denied.")
            self.handleDismiss()
        
        case .restricted:
            print("Camera access has been restricted.")
            self.handleDismiss()
            
        default:
            print("Camera access prevented due to unknown error.")
            self.handleDismiss()
        }
    }
    
    private let photoOutput = AVCapturePhotoOutput()
    private func openCamera() {
        let captureSession = AVCaptureSession()
        
        // Configure capture device
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if(captureSession.canAddOutput(photoOutput)) {
                captureSession.addOutput(photoOutput)
            }
            
            print("Input and output added successfully")
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = self.view.frame
            cameraLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(cameraLayer)
            
            print("Done creating camera layer")
            
            captureSession.startRunning() // transfers data from input to output
//            self.setupUI()
        }
    }
    
    @objc private func handleTakePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        let photoPreviewContainer = PhotoViewController(frame: self.view.frame)
        photoPreviewContainer.photoImageView.image = previewImage
        self.view.addSubview(photoPreviewContainer)
    }
    
    @objc private func handleDismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
