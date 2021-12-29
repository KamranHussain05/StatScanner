//
//  ViewController.swift
//  StatsScanner
//
//  Created by Kalb on 12/21/21.
//

import UIKit

class CameraOCRThing: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var newScanButton: UIButton!
    @IBOutlet var useImageButton: UIButton!
    
    var imgUsing: UIImage!
    
    override func loadView() {
        super.loadView()
    }
    
    @IBAction func didTapNewScanButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func afterCameraClosed() {
        if(imgUsing != nil) {
            newScanButton.setTitle("Retake Image", for: .normal)
        }
    }
    
    func processOCR() {
        // vision code using imgUsing will go here
    }
}

extension CameraOCRThing: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage else {
            return
        }
        
        imgUsing = image
        imageView.image = imgUsing
    }
}
