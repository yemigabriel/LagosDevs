//
//  ProfileListVM.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import Foundation
import Combine

class ProfileListVM: ObservableObject {
    @Published var appState: AppState = .ready
    @Published var errorMessage: String = ""
    @Published var profileResults: [Profile] = []
    @Published var groupedProfileResults: [Section] = []
    private var profileRepository: Repository
    private var cancellables = Set<AnyCancellable>()
    
    lazy var pages = {
        UserDefaults.standard.getProfileCount() / 20
    }()
    var currentPage = 1
    var isFetchingProfiles = false
    
    init(profileRepository: Repository = ProfileRepository.shared) {
        self.profileRepository = profileRepository
    }
    
    func fetchRemoteProfiles() {
        if isFetchingProfiles {
            profileRepository.fetchRemoteProfiles(query: "lagos", page: currentPage)
        }
    }
    
    func getPersistedProfiles() {
        appState = .loading
        
        profileRepository.getPersistedProfiles()
            .receive(on: DispatchQueue.main, options: nil)
            .removeDuplicates()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.appState = .error
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: {[weak self] profiles in
                self?.appState = .ready
                
                self?.profileResults.appendDistinct(contentsOf: profiles, where: {
                    $0.id != $1.id
                })
                self?.groupBySection(profiles: self?.profileResults ?? [])
                self?.isFetchingProfiles = false
            }
            .store(in: &cancellables)
    }
    
    func groupBySection(profiles: [Profile]) {
        let groupedDictionary = Dictionary(grouping: profiles, by: {String($0.login.lowercased().prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        groupedProfileResults = keys.map{ Section(letter: $0.lowercased(), profiles: groupedDictionary[$0]!.sorted{$0.login.lowercased() < $1.login.lowercased()} )}
    }
    
}

enum AppState {
    case ready
    case loading
    case error
}

struct Section {
    let letter : String
    let profiles : [Profile]
}
