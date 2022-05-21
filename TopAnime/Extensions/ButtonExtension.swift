//
//  ButtonExtension.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/20.
//

import UIKit

extension UIButton {
    func setFavorite(_ isFavorite: Bool) {
        let title = isFavorite == true ? LString("Text:RemoveFavorite") : LString("Text:AddFavorite")
        let image = isFavorite == true ? UIImage.heartOn : UIImage.heartOff
        
        setNormal(title: title, image: image)
    }
    
    func setNormal(title: String?, image: UIImage?) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
    }
    
    func setBackgroundColor(normalColor: UIColor, disabledColor: UIColor) {
        setBackgroundImage(UIImage.init(fromColor: normalColor), for: .normal)
        setBackgroundImage(UIImage.init(fromColor: disabledColor), for: .disabled)
    }
    
    func setTitleColor(normalColor: UIColor, disabledColor: UIColor) {
        setTitleColor(normalColor, for: .normal)
        setTitleColor(disabledColor, for: .disabled)
    }
}
