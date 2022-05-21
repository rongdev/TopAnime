//
//  ColorExtension.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import UIKit

extension UIColor {
    convenience init(rgbValue: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((rgbValue & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((rgbValue & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( rgbValue & 0x0000FF       ) / divisor
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(rgbaValue: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((rgbaValue & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((rgbaValue & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((rgbaValue & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( rgbaValue & 0x000000FF       ) / divisor
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
