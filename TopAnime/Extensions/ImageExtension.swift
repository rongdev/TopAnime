//
//  ImageExtension.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import UIKit
import Kingfisher

extension UIImage {
    class var tab1: UIImage { return UIImage(imageLiteralResourceName: "tab1") }
    class var tab2: UIImage { return UIImage(imageLiteralResourceName: "tab2") }
    class var dropdownOn: UIImage { return UIImage(imageLiteralResourceName: "dropdown") }
    class var heartOn: UIImage { return UIImage(imageLiteralResourceName: "heartOn") }
    class var heartOff: UIImage { return UIImage(imageLiteralResourceName: "heartOff") }
    class var trash: UIImage { return UIImage(imageLiteralResourceName: "trash") }
    
    convenience init(fromColor color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage)!)
        
        UIGraphicsEndImageContext()
    }
}

extension UIImageView {
    func setImageWith(_ imageUrl: String?) {
        guard imageUrl != nil, let url = URL(string: imageUrl!) else {
            self.image = nil
            return
        }

        self.kf.setImage(with: url)
    }
}

