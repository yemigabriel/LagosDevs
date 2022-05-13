//
//  ProfileCellVM.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import Foundation
import Combine
import UIKit

class ProfileCellVM: ObservableObject {
    @Published var profileImage: ProfileImage?
    @Published var profile: Profile
    private var imageService: ImageDownloadManager
    private var persistenceManger: PersistenceManager
    private var cancellables = Set<AnyCancellable>()
    
    init(profile: Profile,
         persistenceManager: PersistenceManager = RealmPersistenceManager.shared,
         imageService: ImageDownloadManager = ImageService.shared) {
        self.profile = profile
        self.imageService = imageService
        self.persistenceManger = persistenceManager
    }
    
    func addToFavourites() {
        profile.isFavourited = !(profile.isFavourited ?? false)
        persistenceManger.toggleFavourite(profile: profile)
    }
    
    func downloadImage() {
        imageService.downloadImage(profile.avatar_url)?
            .receive(on: DispatchQueue.main, options: nil)
            .sink(
                receiveCompletion: {_ in},
                receiveValue: { [weak self] profileImage in
                    self?.profileImage = profileImage
            })
            .store(in: &cancellables)
    }
    
    func cancelImageDownload() {
        if let profileImage = profileImage {
            imageService.cancelImageDownload(profileImage.uuid)
        }
    }
    
}
