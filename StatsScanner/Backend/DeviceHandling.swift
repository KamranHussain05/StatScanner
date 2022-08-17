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


