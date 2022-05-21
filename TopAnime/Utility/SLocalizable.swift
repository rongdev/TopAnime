//
//  SLocalizable.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import Foundation

func LString(_ string: String?) -> String {
    return NSLocalizedString(string ?? "", comment: "")
}

func LStringFormat(_ string: String, _ arguments: CVarArg...) -> String {
    if arguments.count == 0 {
        return LString(string)
    }
    
    let strSentance: String = LString(string)
    let strText = String(format:strSentance, arguments:arguments)
    
    return strText
}
