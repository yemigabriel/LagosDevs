//
//  MockImageService.swift
//  LagosDevsTests
//
//  Created by Yemi Gabriel on 5/13/22.
//

import UIKit
import Combine
@testable import LagosDevs

class MockImageService: ImageDownloadManager {
    
    var runningRequests: [UUID: AnyPublisher<ProfileImage, APIError>] = [:]
    let uuid = UUID(uuidString: "80B2EB0F-633E-4FB9-A662-EC73AC2CE707")!
    var profileImage: ProfileImage?
    
    init() {
        let profileImage = ProfileImage(image: UIImage(systemName: "person")!, uuid: uuid)
        let pub = Just(profileImage)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
        runningRequests[uuid] = pub
    }
    
    func downloadImage(_ url: String) -> AnyPublisher<ProfileImage, APIError>? {
        profileImage = ProfileImage(image: UIImage(systemName: "person")!, uuid: uuid)
        return Just(profileImage!)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
    
    func cancelImageDownload(_ uuid: UUID) {
        runningRequests.removeValue(forKey: uuid)
    }

}
