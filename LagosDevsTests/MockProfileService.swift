//
//  MockProfileService.swift
//  LagosDevsTests
//
//  Created by Yemi Gabriel on 5/13/22.
//

import Foundation
import Combine
@testable import LagosDevs

class MockProfileService: ProfileServiceProtocol {
    private let sampleResponse = ProfileResponse.init(total_count: 8, items: Profile.sampleProfiles())
    
    func getProfiles(query: String, page: Int) -> AnyPublisher<ProfileResponse, Error> {
        return Just(sampleResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockProfileRepository: Repository {
    var fetchedProfiles: [Profile] = []
    
    func fetchRemoteProfiles(query: String, page: Int) {
        fetchedProfiles.append(contentsOf: Profile.sampleProfiles() )
    }
    
    func getPersistedProfiles() -> AnyPublisher<[Profile], Error> {
        return Just(Profile.sampleProfiles())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
