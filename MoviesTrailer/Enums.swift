//
//  Enums.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 04/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation
import Alamofire

enum UDKeys: String {
    case City = "City"
}


enum MovieRequestError {
    case invalidJSON
    case url
    case noResponse
    case noData
    case noInternetConnection
    case httpError(code: Int)
}



enum UrlRouter: URLRequestConvertible {
    static let baseURLString = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "6d9e6c4a455c5f11950eec7162e3317b"
    
    case getPopular(Int)
    case getDetail(Int)
    case getVideos(Int)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getPopular, .getDetail, .getVideos:
                return .get
            }
        }
        
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            switch self {
            case .getPopular(let number):
                relativePath = "popular?api_key=\(UrlRouter.apiKey)&page=\(number)"
            case .getDetail(let number):
                relativePath = "\(number)?api_key=\(UrlRouter.apiKey)"
            case .getVideos(let number):
                relativePath = "\(number)/videos?api_key=\(UrlRouter.apiKey)"
            }
            
            var url = URL(string: UrlRouter.baseURLString)!
            if let relativePath = relativePath {
                url = URL(string:url.appendingPathComponent(relativePath).absoluteString.removingPercentEncoding!)!
            }
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: nil)
    
    }
}
