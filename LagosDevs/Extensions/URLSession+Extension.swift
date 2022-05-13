//
//  URLSession+Extension.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import Foundation

extension URLSession {
    @discardableResult
    func request(_ endpoint: Endpoint) -> URLSession.DataTaskPublisher {
        return dataTaskPublisher(for: endpoint.url)
    }
    
    func downloadImage(_ url: URL) -> URLSession.DataTaskPublisher? {
        return dataTaskPublisher(for: url )
    }
}
