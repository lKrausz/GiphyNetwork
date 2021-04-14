//
//  GiphyModel.swift
//  network
//
//  Created by Виктория Козырева on 06.04.2021.
//

import Foundation

struct GiphyApiResponse {
    let pagination: Pagination
    let data: [Gif]
}

extension GiphyApiResponse: Decodable {
    
    private enum GiphyApiResponseCodingKeys: String, CodingKey {
        case pagination
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GiphyApiResponseCodingKeys.self)
        
        pagination = try container.decode(Pagination.self, forKey: .pagination)
        data = try container.decode([Gif].self, forKey: .data)

    }
}

struct Gif: Decodable {
    let id: String
    let title: String
    let images: ImagesType
}


struct ImagesType: Decodable {
    let original: Image
    let downsized: Image
}

struct Image: Decodable {
    let height: String
    let width: String
    let url: String
}


struct Pagination {
    let numberOfResults: Int
    let offset: Int
    let count: Int
}

extension Pagination: Decodable {
    
    private enum PaginationCodingKeys: String, CodingKey {
        case numberOfResults = "total_count"
        case offset
        case count
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PaginationCodingKeys.self)
        
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        offset = try container.decode(Int.self, forKey: .offset)
        count = try container.decode(Int.self, forKey: .count)

    }
}
