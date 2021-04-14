//
//  HTTPTask.swift
//  network
//
//  Created by Виктория Козырева on 04.04.2021.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    case requestParams(bodyParams: Parameters?, urlParams: Parameters?)
}
