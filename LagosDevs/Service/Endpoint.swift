//
//  Endpoint.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

//MARK: computed property to construct url using URLComponents
extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
}

//MARK: Available endpoints
extension Endpoint {
    
    static func getProfiles(query: String = "lagos", itemsPerPage: Int = 20, currentPage: Int = 1) -> Self {
        Endpoint(path: "search/users",
                 queryItems: [
                    URLQueryItem(name: "q", value: "\(query)"),
                    URLQueryItem(name: "per_page", value: String(itemsPerPage)),
                    URLQueryItem(name: "page", value: String(currentPage))
                 ])
    }
}
