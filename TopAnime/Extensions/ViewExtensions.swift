//
//  ViewExtensions.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import UIKit


// MARK: -
extension UIView {
    private class func initFromNib<T: UIView>(_ type: T.Type) -> T {
        let objects = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: [:])
        return objects?.first as? T ?? T()
    }
    
    // MARK: View
    public class func initFromNib() -> Self {
        return initFromNib(self)
    }
    
    public class func loadFromNib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    // MARK: IBInspectable
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            setCornerRadius(newValue)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // MARK: Corner
    func setCornerRadius(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
    
    func setShadow(offsetX: CGFloat,
                   offsetY: CGFloat,
                   shadowBlur: CGFloat,
                   shadowOpacity: CGFloat = 0.5,
                   shadowColor: UIColor = UIColor(rgbaValue: 0x5b5b5b80),
                   cornerRadius: CGFloat = 0.0,
                   bgColor: UIColor? = nil) {
        layoutIfNeeded()
        
        layer.applySketchShadow(x: offsetX,
                                y: offsetY,
                                blur: shadowBlur,
                                spread: cornerRadius,
                                color: shadowColor,
                                alpha: shadowOpacity)
        layer.masksToBounds = false
    }
}

// MARK: -
extension CALayer {
    func applySketchShadow(x: CGFloat,
                           y: CGFloat,
                           blur: CGFloat,
                           spread: CGFloat,
                           color: UIColor,
                           alpha: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = Float(alpha)
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    public func applyShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            if cornerRadius != 0 {
                shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            } else {
                shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
    }
}
