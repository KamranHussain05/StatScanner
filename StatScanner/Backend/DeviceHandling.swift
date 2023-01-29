//
//  DeviceHandling.swift
//  StatsScanner
//
//  Created by Kamran Hussain on 8/16/22.
//
// Functions and extensions for device specific operations.

import Foundation
import UIKit

/// Check if the app is running on a device running iOS by checking the file directory structure.
///
/// - Returns: Type ``Bool`` that presents True if an iOS device is detected and False otherwise.
/// - Note: This function may work improperly in the future if file structures are changed
/// - Authors: Kamran Hussain
///
func isPhone() -> Bool {
    let fone = URL(string: DataBridge.getDocumentsDirectory().absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://"))!
    return UIApplication.shared.canOpenURL(fone)
}

/// File reading or writing error that is thrown when an error occurs in the DataBridge reading or writing process. Catch this error and display a message to the user accordingly.
/// - Authors: Kamran Hussain
enum FileIOError : Error {
    case UnrecognizedFile
    case CorruptedFile
    case ReadingError
}

/// Collection iterator extension that interates through an array and cleans out empty (nil) values.
///
/// - Parameters: Extend this in a class then use the standard interation subscript.
/// - Authors: Kamran Hussain
extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

/// Extensions for view controller gesture recognitions
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

/// Extensions for the entire application to iterate build and version numbers and display them in app
///
/// - Authors: Caden Pun
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
