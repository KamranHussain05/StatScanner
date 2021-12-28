//
//  ViewController.swift
//  StatsScanner
//
//  Created by Kalb on 12/21/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var addDataSet: UIButton!
    @IBOutlet var cells: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageView.backgroundColor = .secondarySystemBackground
//
//        cameraButton.backgroundColor = .systemBlue
//        cameraButton.setTitle("Take Picture", for: .normal)
//        cameraButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func didTapCameraButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func onClick(_sender: UIButton!) {
        if(_sender == addDataSet){
            
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage else {
            return
        }
        imageView.image = image
    }
}
