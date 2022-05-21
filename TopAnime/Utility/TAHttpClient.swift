//
//  TAHttpClient.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import Foundation
import Alamofire

private let kTimeoutInterval: TimeInterval = 30.0
typealias SuccessBlock<T: Decodable> = (_ response: T) -> Void
typealias FailureBlock = () -> Void

enum ApiName: String {
    case `default`
    case getTopAnime
    case getTopManga
    case getTopPeople
    case getTopCharacters
    case getTopReviews
    
    var path: String {
        switch self {
        case .getTopAnime: return "top/anime"
        case .getTopManga: return "top/manga"
        case .getTopPeople: return "top/people"
        case .getTopCharacters: return "top/characters"
        case .getTopReviews: return "top/reviews"
        default: return ""
        }
    }
    
    var method: HTTPMethod {
        if self.rawValue.hasPrefix("get") { return .get }
        else if self.rawValue.hasPrefix("post") { return .post }
        else if self.rawValue.hasPrefix("put") { return .put }
        else if self.rawValue.hasPrefix("delete") { return .delete }
        else if self.rawValue.hasPrefix("patch") { return .patch }
        else if self.rawValue.hasPrefix("query") { return .query }
        else if self.rawValue.hasPrefix("connect") { return .connect }
        else if self.rawValue.hasPrefix("head") { return .head }
        else if self.rawValue.hasPrefix("options") { return .options }
        else { return .trace }
    }
}

class TAHttpClient: NSObject {
    static let shared: TAHttpClient = TAHttpClient()
    
    private let decoder = JSONDecoder()
    private var session: Session!
    
    // MARK: - Initialization
    override private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = kTimeoutInterval
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        session = Session(configuration: configuration)
        
        super.init()
    }
 
    func sendRequest<T: Decodable>(apiName: ApiName,
                                   parameters: Encodable,
                                   success: @escaping SuccessBlock<T>,
                                   failure: @escaping FailureBlock) {
        let requestHeaders: HTTPHeaders = [
            "content-type": "application/json"
        ]
        let requestURL = kApiUrl + apiName.path
        let param: Parameters? = try? parameters.asDictionary(strategy: .convertToSnakeCase)
        let request = session.request(requestURL,
                                      method: apiName.method,
                                      parameters: param,
                                      headers: requestHeaders)
        
        HttpClientLoadingHandler.shared.isLoading(true)
        request.responseData { (response) in
            HttpClientLoadingHandler.shared.isLoading(false)
            let statusCode = response.response?.statusCode ?? 0
            
            if case 200...299 = statusCode {
                if let data = response.data {
                    do {
                        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                        self.decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        let rsp: T = try self.decoder.decode(T.self, from: data)
                        
                        success(rsp)
                    } catch (let error) {
                        SUtility.showRemind(msg: error.localizedDescription)
                    }
                }
            } else {
                SUtility.showRemind(msg: LString("AlertInfo:SystemError"))
            }
        }
    }
}

extension Encodable {
    func asDictionary(strategy: JSONEncoder.KeyEncodingStrategy? = nil) throws -> Parameters {
        let encoder = JSONEncoder()
        
        if let strategy = strategy {
            encoder.keyEncodingStrategy = strategy
        }
        
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Parameters else {
            throw NSError()
        }
        
        return dictionary
    }
}




