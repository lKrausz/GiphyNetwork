//
//  NetworkManager.swift
//  network
//
//  Created by Виктория Козырева on 06.04.2021.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first"
    case badRequest = "Bad request"
    case outdated = "url is outdated"
    case failed = "Network request failed"
    case noData = "responce returned with no data to decode"
    case unableToDecode = "can't decode this responce"
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager {
    static let version = "v1/"
    static let giphyAPIKey = "d9P42WnocmZvCUAq8TqRf6Xuf5WHtqLY"
    private let router = Router<GiphyApi>()
    
    fileprivate func handleNetworkResponse(_ responce: HTTPURLResponse) -> Result<String> {
        switch responce.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func getGifs(query: String, offset: Int, limit: Int, completion: @escaping (_ gif: [Gif]?, _ error: String?)->()){
        router.request(.sticker(query: query, offset: offset, limit: limit), completion: { (data, response, error) in
            if error != nil {
                completion(nil, "Check your network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse =  try JSONDecoder().decode(GiphyApiResponse.self, from: responseData)
                        completion(apiResponse.data, nil)
                    } catch {
                        completion(nil,NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        })
    }
}

