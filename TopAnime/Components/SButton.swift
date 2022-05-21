//
//  SButton.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/20.
//

import UIKit

enum SButtonStyle: Int {
    case none = 0
    case round = 1
}

class SButton: UIButton {
    private let radius: CGFloat = 8
    
    @IBInspectable var buttonStyle: Int = 0 {
        didSet {
            updateView()
        }
    }
    
    // MARK: - Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: Init Methods
    private func updateView() {
        let style = SButtonStyle(rawValue: self.buttonStyle)
        
        if style == .round {
            setCornerRadius(radius)
            titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }
    }
}

