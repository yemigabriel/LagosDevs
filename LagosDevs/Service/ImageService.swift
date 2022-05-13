//
//  ImageService.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/13/22.
//

import UIKit
import Combine

protocol ImageDownloadManager {
    func downloadImage(_ url: String) -> AnyPublisher<ProfileImage, APIError>?
    func cancelImageDownload(_ uuid: UUID)
}

class ImageService: ImageDownloadManager {
    static let shared = ImageService()
    
    private var loadedImages: [URL: ProfileImage] = [:]
    private var runningRequests: [UUID: AnyPublisher<ProfileImage, APIError>] = [:]
    
    func downloadImage(_ url: String) -> AnyPublisher<ProfileImage, APIError>? {
        guard let url = URL(string: url) else { return nil}
        
        if let image = loadedImages[url] {
            return Just(image)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        
        let uuid = UUID()
        let task = URLSession.shared.downloadImage(url)?
            .mapError({error in
                return APIError.networkError(error)
            })
            .map{ [weak self] data -> ProfileImage in
                if let image = UIImage(data: data.data) {
                    let profileImage = ProfileImage(image: image, uuid: uuid)
                    self?.loadedImages[url] = profileImage
                    return profileImage
                }
                return ProfileImage(image: UIImage(systemName: "person.circle.fill")!, uuid: uuid)
            }
            .eraseToAnyPublisher()
        
        runningRequests[uuid] = task
        
        return task
    }
    
    func cancelImageDownload(_ uuid: UUID) {
        let cancellable: AnyCancellable? = runningRequests[uuid]?.sink(
            receiveCompletion: {_ in }, receiveValue: {_ in})
        cancellable?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
