//
//  Enums.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import Foundation

enum AnimeType: String, Codable, CaseIterable {
    case all
    case tv
    case movie
    case ova
    case special
    case ona
    case music
    
    static func allValue() -> [String] {
        return AnimeType.allCases.map { $0.rawValue }
    }
}

enum AnimeFilter: String, Codable, CaseIterable {
    case all
    case airing
    case upcoming
    case bypopularity
    case favorite
    
    static func allValue() -> [String] {
        return AnimeFilter.allCases.map { $0.rawValue }
    }
}

enum MangaType: String, Codable, CaseIterable {
    case all
    case manga
    case novel
    case lightnovel
    case oneshot
    case doujin
    case manhwa
    case manhua
    
    static func allValue() -> [String] {
        return MangaType.allCases.map { $0.rawValue }
    }
}

enum MangaFilter: String, Codable, CaseIterable {
    case all
    case publishing
    case upcoming
    case bypopularity
    case favorite
    
    static func allValue() -> [String] {
        return MangaFilter.allCases.map { $0.rawValue }
    }
}
