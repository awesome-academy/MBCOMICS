//
//  UITextField+.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//

import UIKit

extension UITextField {
    
    enum ImageDirection {
        case left
        case right
    }
    
    /// add image to textfield
    ///
    /// - Parameters:
    ///   - direction: Vị trí image
    ///   - image: Image
    ///   - margin: Khoảng cách với các view xung quanh
    ///   - padding: Khoảng cách vào bên trong image (Làm image nhỏ đi)
    func withImage(direction: ImageDirection, image: UIImage?, margin: CGFloat, padding: CGFloat = 5) {
        
        let width = self.height + margin
        let height = self.height
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: width,
                                        height: height))
        view.backgroundColor = .clear
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        if ImageDirection.left == direction { // image left
            imageView.frame = CGRect(x: padding,
                                     y: padding,
                                     width: height - padding * 2,
                                     height: height - padding * 2)
            self.leftViewMode = .always
            self.leftView = view
        } else { // image right
            imageView.frame = CGRect(x: padding,
                                     y: padding,
                                     width: height - padding * 2,
                                     height: height - padding * 2)
            self.rightViewMode = .always
            self.rightView = view
        }
    }
}
