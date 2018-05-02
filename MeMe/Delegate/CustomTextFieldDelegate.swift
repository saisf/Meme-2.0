//
//  CustomTextFieldDelegate.swift
//  MeMe
//
//  Created by Sai Leung on 4/19/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import Foundation
import UIKit

class CustomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: TextField TextAttributes configuration
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -2.0 ]
    
    // MARK: Once user start inputing, textField will be clear and ready for user's input
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // MARK: Dismiss keyboard once return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
