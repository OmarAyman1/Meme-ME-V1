//
//  TextFieldDelegate.swift
//  meme Me V1
//
//  Created by OMAR on 4/29/19.
//  Copyright © 2019 OMAR. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor:  UIColor.black,
        .foregroundColor:  UIColor.white ,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth:  -3.5
    ]
    
}
