//
//  SToolButton.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/20.
//

import UIKit

class SToolButton: UIButton {
    static func generate(icon: UIImage, target: Any, action: Selector) -> SToolButton {
        let btnTool = SToolButton(type: .custom)
        btnTool.setImage(icon, for: .normal)
        btnTool.translatesAutoresizingMaskIntoConstraints = false
        btnTool.addTarget(target, action: action, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            btnTool.widthAnchor.constraint(equalToConstant: 56),
            btnTool.heightAnchor.constraint(equalTo: btnTool.widthAnchor, multiplier: 1.0)
        ])
        
        return btnTool
    }
}

extension UIViewController {
    private static let kToolButtonStackViewTag: Int = 8321
    
    /// 設定頁面右下角按鈕，由上往下排列
    func addToolButton(_ button: SToolButton) {
        var stackView: UIStackView! = self.view.viewWithTag(UIViewController.kToolButtonStackViewTag) as? UIStackView
        
        if stackView == nil {
            stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 15
            stackView.tag = UIViewController.kToolButtonStackViewTag
            stackView!.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(stackView!)
            
            NSLayoutConstraint.activate([
                stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
        }
        
        stackView.addArrangedSubview(button)
    }
    
    func hideToolButton(hide: Bool) {
        guard let stackView = self.view.viewWithTag(UIViewController.kToolButtonStackViewTag) as? UIStackView else {
            return
        }
        
        stackView.isHidden = hide
    }
}
