//
//  SIndicatorView.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import UIKit

class HttpClientLoadingHandler {
    
    static let shared: HttpClientLoadingHandler = HttpClientLoadingHandler()
    
    func isLoading(_ isLoading: Bool) {
        if isLoading {
            GlobalIndicator.shared.show()
        } else {
            GlobalIndicator.shared.hide()
        }
    }
}

class GlobalIndicator {
    
    static let shared: GlobalIndicator = GlobalIndicator()
    
    private var animatingCount: Int = 0
    private var minimumDisplayMS: Int = 100
    
    func show() {
        DispatchQueue.main.async {
            self.animatingCount += 1
            self._show()
        }
    }
    
    func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(minimumDisplayMS)) {
            self.animatingCount -= 1
            if self.animatingCount > 0 {
                return
            }
            self._hide()
        }
    }
    
    private func _show() {
        let vContainer = UIView(frame: UIScreen.main.bounds)

        vContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        vContainer.restorationIdentifier = "restorationIdentifier"
        vContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let vIndicator = SIndicatorView()
        vIndicator.translatesAutoresizingMaskIntoConstraints = false
        vContainer.addSubview(vIndicator)
        
        vIndicator.centerXAnchor.constraint(equalTo: vContainer.centerXAnchor).isActive = true
        vIndicator.centerYAnchor.constraint(equalTo: vContainer.centerYAnchor).isActive = true
        
        guard let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow) else {
            return
        }
        
        keyWindow.addSubview(vContainer)
        vContainer.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
        vContainer.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor).isActive = true
        vContainer.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor).isActive = true
        vContainer.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor).isActive = true
    }
    
    private func _hide() {
        for window in UIApplication.shared.windows {
            for item in window.subviews
            where item.restorationIdentifier == "restorationIdentifier" {
                item.removeFromSuperview()
            }
        }
    }
}

class SIndicatorView: UIView {
    
    private var vIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.applyShadow(color: .black, alpha: 0.2, x: 0, y: 2, blur: 10, spread: 0)
        
        vIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vIndicator)
        vIndicator.startAnimating()
        
        vIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        vIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
