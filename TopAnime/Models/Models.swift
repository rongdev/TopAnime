//
//  Models.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import Foundation

// MARK: - Pagination
class Pagination: Codable {
    var lastVisiblePage: Int
    var hasNextPage: Bool
    var currentPage: Int
    var items: PaginationItem
    
    private enum CodingKeys: CodingKey {
        case lastVisiblePage
        case hasNextPage
        case currentPage
        case items
    }
    
    init() {
        self.lastVisiblePage = 0
        self.hasNextPage = false
        self.currentPage = 0
        self.items = PaginationItem()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lastVisiblePage = try container.decodeIfPresent(Int.self, forKey: .lastVisiblePage) ?? 0
        hasNextPage = try container.decodeIfPresent(Bool.self, forKey: .hasNextPage) ?? false
        currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage) ?? 0
        items = try container.decodeIfPresent(PaginationItem.self, forKey: .items) ?? PaginationItem()
    }
}

class PaginationItem: Codable {
    var count: Int
    var total: Int
    var perPage: Int
    
    private enum CodingKeys: CodingKey {
        case count
        case total
        case perPage
    }
    
    init() {
        self.count = 0
        self.total = 0
        self.perPage = 0
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
        total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        perPage = try container.decodeIfPresent(Int.self, forKey: .perPage) ?? 0
    }
}

// MARK: - Images
class Images: Codable {
    var jpg: ImagesItem
    var webp: ImagesItem
    
    private enum CodingKeys: CodingKey {
        case jpg
        case webp
    }
    
    init() {
        self.jpg = ImagesItem()
        self.webp = ImagesItem()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jpg = try container.decodeIfPresent(ImagesItem.self, forKey: .jpg) ?? ImagesItem()
        webp = try container.decodeIfPresent(ImagesItem.self, forKey: .webp) ?? ImagesItem()
    }
}

class ImagesItem: Codable {
    var imageUrl: String
    var smallImageUrl: String
    var largeImageUrl: String
    
    private enum CodingKeys: CodingKey {
        case imageUrl
        case smallImageUrl
        case largeImageUrl
    }
    
    init() {
        self.imageUrl = ""
        self.smallImageUrl = ""
        self.largeImageUrl = ""
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
        smallImageUrl = try container.decodeIfPresent(String.self, forKey: .smallImageUrl) ?? ""
        largeImageUrl = try container.decodeIfPresent(String.self, forKey: .largeImageUrl) ?? ""
    }
}

// MARK: - DateInfo
class DateInfo: Codable {
    var from: Date?
    var to: Date?
    
    private enum CodingKeys: CodingKey {
        case from
        case to
    }
    
    init() {
        self.from = nil
        self.to = nil
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        from = try? container.decodeIfPresent(Date.self, forKey: .from)
        to = try? container.decodeIfPresent(Date.self, forKey: .to)
    }
}

