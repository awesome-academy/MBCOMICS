//
//  UIView+.swift
//  MBComics
//
//  Created by HoaPQ on 5/25/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

extension UIView {
    var width: CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    var size: CGSize {
        get { return self.frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }

    var origin: CGPoint {
        get { return self.frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    var x: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var centerX: CGFloat {
        get { return self.center.x }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    var centerY: CGFloat {
        get { return self.center.y }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    var top: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var bottom: CGFloat {
        get { return frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }

    var right: CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }

    var left: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
}

// MARK: Corner radius
extension UIView {
    func applyCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

    func applyRoundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func applyCircle() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) * 0.5
        self.clipsToBounds = true
    }
}

// MARK: Gesture
extension UIView {
    func addTapGesture(target: Any?, action: Selector?) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
    }
}

//MARK: SHADOW
extension UIView {
    enum ShadowDirection: Int {
        case top, left, bottom, right
        case topLeft, topRight, bottomLeft, bottomRight
        case all, none
    }
    
    func applyShadowWithColor(color: UIColor, opacity: Float, radius: CGFloat, offset: CGFloat = 2.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: offset, height: offset)
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }

    func applyShadowWithColor(color: UIColor, opacity: Float, radius: CGFloat, edge: ShadowDirection, shadowSpace: CGFloat) {

        var sizeOffset: CGSize = CGSize.zero
        switch edge {
        case .top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)


        case .topLeft:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .topRight:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .bottomLeft:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .bottomRight:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)

        case .all:
            sizeOffset = CGSize(width: 0, height: 0)
        case .none:
            sizeOffset = CGSize.zero
        }

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
}

// MARK: Gradient
extension UIView {
    enum GradientDirection {
        case topBottom, bottomTop, leftRight, rightLeft
        case topLeftBottomRight, topRightBottomLeft, bottomLeftTopRight, bottomRightTopLeft
    }

    func addGradientBackground(colors: UIColor..., direction: GradientDirection) {
        self.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.cgColor)
        }
        gradientLayer.colors = cgColors
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

        switch direction {
        case .topBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .bottomTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .leftRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .topLeftBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .topRightBottomLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .bottomLeftTopRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        case .bottomRightTopLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }

        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: Add line
extension UIView {
    enum LinePosition {
        case top
        case bottom
    }

    func addLineToView(position: LinePosition, color: UIColor = UIColor.lightGray, height: Double = 0.3) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width": NSNumber(value: height)]
        let views = ["lineView": lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))

        switch position {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
            break
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
            break
        }
    }
}

// MARK: Border
extension UIView {
    enum BorderPosition: Int {
        case top, left, bottom, right
    }
    
    func applyBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func addBorderWithColor(color: UIColor, edge: BorderPosition, thicknessOfBorder: CGFloat) {
        DispatchQueue.main.async {
            var rect: CGRect = CGRect.zero
            switch edge {
            case .top:
                rect = CGRect(x: 0, y: 0, width: self.width, height: thicknessOfBorder)
            case .left:
                rect = CGRect(x: 0, y: 0, width: thicknessOfBorder, height: self.width)
            case .bottom:
                rect = CGRect(x: 0, y: self.height - thicknessOfBorder, width: self.width, height: thicknessOfBorder)
            case .right:
                rect = CGRect(x: self.width - thicknessOfBorder, y: 0, width: thicknessOfBorder, height: self.height)
            }

            let layerBorder = CALayer()
            layerBorder.frame = rect
            layerBorder.backgroundColor = color.cgColor
            self.layer.addSublayer(layerBorder)
        }
    }
}

extension UIView {
    //MARK:- ROTATE
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * .pi
        self.transform = self.transform.rotated(by: radians)
    }

    func animateVibrate() {
        let duration = 0.05
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration/5.0) {
                self.transform = self.transform.translatedBy(x: 5, y: 0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: duration/5.0, relativeDuration: duration/5.0) {
                self.transform = self.transform.translatedBy(x: -10, y: 0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2*duration/5.0, relativeDuration: duration/5.0) {
                self.transform = self.transform.translatedBy(x: 10, y: 0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 3*duration/5.0, relativeDuration: duration/5.0) {
                self.transform = self.transform.translatedBy(x: -10, y: 0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 4*duration/5.0, relativeDuration: duration/5.0) {
                self.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
}

extension UIView {
    func removeAllLayer() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}
