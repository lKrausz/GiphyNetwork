//
//  GiphyEndPoint.swift
//  network
//
//  Created by Виктория Козырева on 06.04.2021.
//

import Foundation

public enum GiphyApi {
    case sticker(query: String, offset: Int, limit: Int)
    case gif(query: String, offset: Int, limit: Int)
}

extension GiphyApi: EndPointType {
    
    var baseUrl: URL {
        guard let url = URL(string: "http://api.giphy.com/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .sticker:
            return "stickers/search"
        case .gif:
            return "gifs/search"

        }
    }
    
    var HTTPMethod: HTTPMethod {
        return .get
    }
    
    // HELP ME HERE
    var task: HTTPTask {
        switch self {
        case .sticker(let query, let offset, let limit):
            return .requestParams(bodyParams: nil,
                                  urlParams: ["api_key":NetworkManager.giphyAPIKey, "q":query, "offset": offset, "limit": limit])
        case .gif(let query, let offset, let limit):
            return .requestParams(bodyParams: nil,
                                  urlParams: ["api_key":NetworkManager.giphyAPIKey, "q":query, "offset": offset, "limit": limit])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
