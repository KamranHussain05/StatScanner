//
//  DeviceHandling.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 8/16/22.
//

import Foundation
import UIKit

func isPhone() -> Bool {
    let fone = URL(string: DataBridge.getDocumentsDirectory().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://"))!
    return UIApplication.shared.canOpenURL(fone)
}

enum FileIOError : Error {
    case UnrecognizedFile
    case CorruptedFile
    case ReadingError
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIViewController {
    
    func hideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRec())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRec())
    }

    private func endEditingRec() -> UIGestureRecognizer {
        let g = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        g.cancelsTouchesInView = false
        return g
    }
}

extension UIApplication {
    class func vers() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
  
    class func build() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
  
    class func versionBuild() -> String {
        let version = vers(), build = build()
        return version == build ? "v\(version)" : "v\(version) (\(build))"
    }
}
