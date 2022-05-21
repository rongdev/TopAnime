//
//  ViewControllerExtension.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import UIKit

extension UIAlertController {
    static func showAlert(_ viewController:UIViewController,
                          title:String?,
                          msg:String?,
                          confirmTitle:String?,
                          cancleTitle:String?,
                          completionHandler: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { (action: UIAlertAction!) in
            completionHandler()
        }))
        
        if cancleTitle != nil {
            alert.addAction(UIAlertAction(title: cancleTitle, style: .cancel, handler: { (action: UIAlertAction!) in
            }))
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlert(_ viewController:UIViewController,
                          title:String?,
                          msg:String?,
                          confirmTitle:String?,
                          cancleTitle:String?,
                          completionHandler: @escaping ()->Void,
                          cancelHandler: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { (action: UIAlertAction!) in
            completionHandler()
        }))
        
        if cancleTitle != nil {
            alert.addAction(UIAlertAction(title: cancleTitle, style: .cancel, handler: { (action: UIAlertAction!) in
                cancelHandler()
            }))
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
