//
//  TACore.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/20.
//

import Foundation

class TACore: NSObject {
    static let shared: TACore = TACore()
    
    private(set) var vcTab: TATabBarController!
    private(set) var vcAnime: TAAnimeViewController!
    private(set) var vcMy: TAMyViewController!
    private(set) var aryFavorite: [Favorite] = []
    
    override private init() {
        super.init()
    }
    
    func initValue() {
        vcAnime = TAAnimeViewController()
        vcMy = TAMyViewController()
        vcTab = TATabBarController()
        
        loadFavorite()
    }
    
    func loadFavorite() {
        aryFavorite = Favorite.findAll(sortedBy: "updateTime", ascending: true)
    }
    
    func removeFavorite(_ uuid: String) {
        Favorite.deleteBy(for: NSPredicate(format: "uuid = %@", uuid))
        SUtility.showRemind(msg: LString("AlertInfo:RemoveFavorite"))
        
        loadFavorite()
        reloadView()
    }
    
    func removeFavorite(type: SegmentType) {
        Favorite.deleteBy(for: NSPredicate(format: "type = %d", type.rawValue))
        SUtility.showRemind(msg: LString("AlertInfo:RemoveFavorite"))
        
        loadFavorite()
        reloadView()
    }
    
    func removeFavorite(type: SegmentType, malId: Int) {
        Favorite.deleteBy(for: NSPredicate(format: "type = %d &&  malId = %d", type.rawValue, malId))
        SUtility.showRemind(msg: LString("AlertInfo:RemoveFavorite"))
        
        loadFavorite()
        reloadView()
    }
    
    func addFavorite(type: SegmentType, anime: AnimeItem?, manga: MangaItem?) {
        if let title = type == .anime ? anime?.title : manga?.title
          ,let url = type == .anime ? anime?.url : manga?.url
          ,let img = type == .anime ? anime?.images.jpg.largeImageUrl : manga?.images.jpg.largeImageUrl
          ,let malId = type == .anime ? anime?.malId : manga?.malId  {
            
            guard Favorite.findBy(for: NSPredicate(format: "type = %d &&  malId = %d", type.rawValue, malId)).first == nil else {
                return
            }
            
            let favorite = Favorite.createObject()
            favorite.uuid = SCoreDataManager.newId()
            favorite.type = Int32(type.rawValue)
            favorite.malId = Int32(malId)
            favorite.title = title
            favorite.img = img
            favorite.url = url
            favorite.updateTime = Date()
            
            SCoreDataManager.saveContext()
            SUtility.showRemind(msg: LString("AlertInfo:AddFavorite"))
        }
        
        loadFavorite()
        reloadView()
    }
    
    static func isFavorite(type: SegmentType, malId: Int) -> Bool {
        guard TACore.shared.aryFavorite.first(where: { $0.type == type.rawValue && $0.malId == malId }) != nil else {
            return false
        }
        
        return true
    }
    
    // MARK: -
    private func reloadView() {
        TACore.shared.vcAnime.reladView()
        TACore.shared.vcMy.reloadFavorite()
    }
}
