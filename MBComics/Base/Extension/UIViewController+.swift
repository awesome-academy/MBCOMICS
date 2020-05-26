//
//  UIViewController+.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//

import UIKit
import MBProgressHUD
    
extension UIViewController {
    /// Hiển thị alert với 1 nút OK
    ///
    /// - Parameters:
    ///   - title: title của alert
    ///   - message: message của alert
    ///   - confirmTitle: Text hiển thị của nút ấn (Mặc định là OK)
    ///   - handler: Xử lý khi ấn vào nút
    func showAlert(title: String?,
                   message: String?,
                   confirmTitle: String = "OK",
                   handler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Custom action
        let btnOK = UIAlertAction(title: confirmTitle, style: .cancel) { (_) in handler?() }
        alert.addAction(btnOK)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// Hiển thị alert với 2 nút ấn (OK và Cancel)
    ///
    /// - Parameters:
    ///   - title: title của alert
    ///   - message: message của alert
    ///   - confirmTitle: Text hiển thị của nút OK (Mặc định là OK)
    ///   - confirmHandler: Xử lý khi ấn vào nút OK
    ///   - cancelTitle: Text hiển thị của nút Cancel
    ///   - cancelHandler: Xử lý khi ấn vào nút Cancel (Mặc định là Cancel)
    func showAlertConfirm(title: String?,
                   message: String?,
                   confirmTitle: String = "OK",
                   confirmHandler: (() -> Void)? = nil,
                   cancelTitle: String = "Cancel",
                   cancelHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Custom action
        let btnCancel = UIAlertAction(title: cancelTitle, style: .destructive) { (_) in cancelHandler?() }
        alert.addAction(btnCancel)
        let btnConfirm = UIAlertAction(title: confirmTitle, style: .default) { (_) in confirmHandler?() }
        alert.addAction(btnConfirm)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// Hiển thị alert với nhiều nút ấn
    ///
    /// - Parameters:
    ///   - title: title của alert
    ///   - message: message của alert
    ///   - actions: Danh sách các nút ấn muốn hiển thị
    func showAlertMultiAction(title: String?, message: String?, actions: UIAlertAction...) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Custom action
        for action in actions {
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
}


extension UIViewController {
    func showPopupLoading(animated: Bool = false) {
        MBProgressHUD.showAdded(to: view, animated: animated)
    }
    
    func hidePopupLoading(animated: Bool = false) {
        MBProgressHUD.hide(for: view, animated: animated)
    }
}

extension UIViewController {
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = true) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_prevous"), style: .plain, target: nil, action: nil)
                //                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_next"), style: .plain, target: nil, action: nil)
                //                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    if textField.returnKeyType == .continue {
                        textField.addTarget(textFields[index+1], action: #selector(UITextField.becomeFirstResponder), for: .editingDidEndOnExit)
                    }
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
}

extension UINavigationController {
    /**
     It removes all view controllers from navigation controller then set the new root view controller and it pops.
     
     - parameter vc: root view controller to set a new
     */
    func changeRootViewController(_ vc: UIViewController, transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        addTransition(transitionType: type, duration: duration)
        viewControllers.removeAll()
        pushViewController(vc, animated: false)
        popToRootViewController(animated: false)
    }
    
    /**
     It adds the animation of navigation flow.
     
     - parameter type: kCATransitionType, it means style of animation
     - parameter duration: CFTimeInterval, duration of animation
     */
    private func addTransition(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = type
        view.layer.add(transition, forKey: nil)
    }
}
