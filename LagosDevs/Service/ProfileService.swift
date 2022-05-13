//
//  ProfileService.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import Foundation
import Combine

protocol ProfileServiceProtocol {
    func getProfiles(query: String, page: Int) -> AnyPublisher<ProfileResponse, Error>
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()
    
    func getProfiles(query: String, page: Int) -> AnyPublisher<ProfileResponse, Error> {
       return URLSession.shared.request(.getProfiles(query: query, currentPage: page))
            .mapError({ error in
                return APIError.networkError(error)
            })
            .map(\.data)
            .tryMap { data in
              let decoder = JSONDecoder()
              do {
                  let decodedData = try decoder.decode(ProfileResponse.self, from: data)
                  return decodedData
              }
              catch {
                throw APIError.decodingError(error)
              }
            }
            .eraseToAnyPublisher()
    }
    
}

enum APIError: LocalizedError {
    case invalidUrl(String)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl(let string):
            return string
        case .decodingError(let error):
            return error.localizedDescription
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
