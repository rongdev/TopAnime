//
//  TATabBarController.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/18.
//

import Foundation
import UIKit

class TATabBarController: UITabBarController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Init Methods
    private func initView() {
        let nvcAnime = UINavigationController(rootViewController: TACore.shared.vcAnime)
        let nvcMy = UINavigationController(rootViewController: TACore.shared.vcMy)
        
        nvcAnime.tabBarItem = UITabBarItem(title: LString("Title:Home"), image: UIImage.tab1, tag: 100)
        nvcMy.tabBarItem = UITabBarItem(title: LString("Title:My"), image: UIImage.tab2, tag: 100)
        
        self.tabBar.backgroundColor = UIColor.clear
        self.viewControllers = [nvcAnime, nvcMy]
    }
}
