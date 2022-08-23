//
//  PhotoViewController.swift
//  StatScanner
//
//  Created by Kaleb K on 8/22/22.
//

import UIKit
import Photos

class PhotoViewController: UIView {
    let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

//    lazy private var savePhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
////        button.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
//        button.tintColor = .white
//        return button
//    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.view.addSubview(photoImageView, cancelButton, savePhotoButton)
//
//        photoImageView.makeConstraints(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 0, width: 0, height: 0)
//
//        cancelButton.makeConstraints(top: safeAreaLayoutGuide.topAnchor, left: nil, right: rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 50, height: 50)
//
//        savePhotoButton.makeConstraints(top: nil, left: nil, right: cancelButton.leftAnchor, bottom: nil, topMargin: 0, leftMargin: 0, rightMargin: 5, bottomMargin: 0, width: 50, height: 50)
//        savePhotoButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc private func handleCancel() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
}
