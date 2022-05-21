//
//  SUtility.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import UIKit

final class SUtility: NSObject {
    // MARK: - Alert controller
    static func showRemind(msg: String) {
        SUtility.showRemind(msg: msg, completionHandler: {})
    }
    
    static func showRemind(msg: String,
                           completionHandler: @escaping ()-> Void) {
        SUtility.showRemind(title: "",
                            msg: msg,
                            confirmTitle: LString("AlertAction:Confirm"),
                            completionHandler: completionHandler)
    }
    
    static func showRemind(title: String,
                           msg: String,
                           confirmTitle: String,
                           completionHandler: @escaping ()-> Void) {
        UIAlertController.showAlert(TACore.shared.vcTab,
                                    title: title,
                                    msg: msg,
                                    confirmTitle: confirmTitle,
                                    cancleTitle: nil,
                                    completionHandler: completionHandler)
    }
    
    static func showAsk(msg: String,
                        completionHandler: @escaping ()->Void) {
        SUtility.showAsk(title: "",
                         msg: msg,
                         confirmTitle: LString("AlertAction:Confirm"),
                         cancelTitle: LString("AlertAction:Cancel"),
                         completionHandler: completionHandler,
                         cancelHandler: {()})
    }
    
    static func showAsk(title: String,
                        msg: String,
                        confirmTitle: String,
                        cancelTitle: String,
                        completionHandler: @escaping ()->Void,
                        cancelHandler: @escaping ()->Void) {
        UIAlertController.showAlert(TACore.shared.vcTab,
                                    title: title,
                                    msg: msg,
                                    confirmTitle: confirmTitle,
                                    cancleTitle: cancelTitle,
                                    completionHandler: completionHandler,
                                    cancelHandler: cancelHandler)
    }
}


