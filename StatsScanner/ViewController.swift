//
//  ViewController.swift
//  StatsScanner
//
//  Created by Kamran on 11/20/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    let alertBox = UIAlertController(title: "Error", message: "Default message", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
        
    }

    @IBOutlet weak var txt: UILabel!
    @IBAction func field(_ sender: UITextField) {
    }
    
    @IBAction func TakePictureButton(_ sender: UIButton) {
        openCamera()
    }
    
    @IBAction func swit(_ sender: UISwitch) {
        if(sender.isOn) {
            txt.text = "Among Us."
        } else {
            txt.text = "no"
        }
    }
    
    private func openCamera() {
        // check authorization status
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCameraSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCameraSession()
                    }
                } else {
                    self.handleDismiss()
                }
            }
            
        case .restricted:
            alertBox.message = "You have something restricting you from opening the camera."
            self.present(alertBox, animated: true, completion: nil)
            self.handleDismiss()
        case .denied:
            alertBox.message = "You have denied access to the camera previously."
            self.present(alertBox, animated: true, completion: nil)
            self.handleDismiss()
        @unknown default:
            alertBox.message = "There is some unknown reason why you can't open the camera, hmn"
            self.present(alertBox, animated: true, completion: nil)
            self.handleDismiss()
        }
    }
    
    private let photoOutput = AVCapturePhotoOutput()
    private func setupCameraSession() {
        let captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                print("There was some error: \(error)")
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = self.view.frame
            cameraLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(cameraLayer)
            
            captureSession.startRunning()
            self.setupUI()
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
        
    }
    
    private func setupUI() {
        
    }
    
    private func handleDismiss() {
        
    }
}

