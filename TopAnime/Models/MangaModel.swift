//
//  MangaModel.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import Foundation

extension TAHttpClient {
    static func getTopManga<T: TAMangaRsDTO>(request: TAMangaRqDTO,
                                             success: @escaping SuccessBlock<T>,
                                             failure: @escaping FailureBlock) {
        TAHttpClient.shared.sendRequest(apiName: .getTopManga,
                                        parameters: request,
                                        success: success,
                                        failure: failure)
    }
}

// MARK: - Request
class TAMangaRqDTO: Encodable {
    var type: MangaType
    var filter: MangaFilter
    var page: Int
    
    private enum CodingKeys: CodingKey {
        case type
        case filter
        case page
    }
    
    init(type: MangaType, filter: MangaFilter, page: Int) {
        self.type = type
        self.filter = filter
        self.page = page
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type == .all ? "" : self.type.rawValue, forKey: .type)
        try container.encode(self.filter == .all ? "" : self.filter.rawValue, forKey: .filter)
        try container.encode(self.page, forKey: .page)
    }
}

// MARK: - Response
class TAMangaRsDTO: Decodable {
    var pagination: Pagination
    var data: [MangaItem]
    
    private enum CodingKeys: CodingKey {
        case pagination
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decodeIfPresent(Pagination.self, forKey: .pagination) ?? Pagination()
        data = try container.decodeIfPresent([MangaItem].self, forKey: .data) ?? []
    }
}

class MangaItem: Decodable {
    var malId: Int
    var url: String
    var images: Images
    var title: String
    var rank: Int
    var publishing: Bool
    var published: DateInfo
    
    private enum CodingKeys: CodingKey {
        case malId
        case url
        case images
        case title
        case rank
        case publishing
        case published
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        malId = try container.decodeIfPresent(Int.self, forKey: .malId) ?? 0
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        images = try container.decodeIfPresent(Images.self, forKey: .images) ?? Images()
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        rank = try container.decodeIfPresent(Int.self, forKey: .rank) ?? 0
        publishing = try container.decodeIfPresent(Bool.self, forKey: .publishing) ?? false
        published = try container.decodeIfPresent(DateInfo.self, forKey: .published) ?? DateInfo()
    }
}

