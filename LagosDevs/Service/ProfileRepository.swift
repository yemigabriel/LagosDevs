//
//  ProfileRepository.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/10/22.
//

import Foundation
import Combine

protocol Repository {
    func fetchRemoteProfiles(query: String, page: Int)
    func getPersistedProfiles() -> AnyPublisher<[Profile], Error>
}

final class ProfileRepository: Repository {
    static let shared = ProfileRepository()
    private let persistenceService: PersistenceManager
    private let remoteService: ProfileServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(persistenceService: PersistenceManager = RealmPersistenceManager.shared,
         remoteService: ProfileServiceProtocol = ProfileService.shared) {
        self.persistenceService = persistenceService
        self.remoteService = remoteService
    }
    
    func fetchRemoteProfiles(query: String = "lagos", page: Int = 1) {
        remoteService.getProfiles(query: query, page: page)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("REPO error \(error)")
                }
            }, receiveValue: { [weak self] response in
                UserDefaults.standard.setProfileCount(count: response.total_count)
                self?.persistenceService.saveProfiles(response.items)
            })
            .store(in: &cancellables)
    }
    
    func getPersistedProfiles() -> AnyPublisher<[Profile], Error> {
        let profiles = persistenceService.getAllProfiles()
        return Just(profiles)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

