//
//  ParameterEncoding.swift
//  network
//
//  Created by Виктория Козырева on 04.04.2021.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError : String, Error {
    case parametersNil = "Params is nil"
    case encodingFailed = "Params encoding failed"
    case missingURL = "Url is nil"
}
