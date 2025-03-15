//
//  ViewControllerExtensions.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 15.03.2025.
//

import UIKit

extension UIViewController {
    
    func setupKeyboardHidding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight / 1.2
        }
    }
    
    @objc func keyboardWillHide(_ sender: NSNotification) {
            view.frame.origin.y = 0
    }
}
