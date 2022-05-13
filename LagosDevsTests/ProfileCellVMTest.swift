//
//  ProfileCellVMTest.swift
//  LagosDevsTests
//
//  Created by Yemi Gabriel on 5/13/22.
//

import XCTest

@testable import LagosDevs
class ProfileCellVMTest: XCTestCase {

    var sut: ProfileCellVM!
    var mockPersistenceManager: MockPersistenceManager!
    var mockImageService: MockImageService!
    let profile = Profile.sampleProfiles()[1]
    let uuid = UUID(uuidString: "80B2EB0F-633E-4FB9-A662-EC73AC2CE707")!
    
    override func setUp() {
        super.setUp()
        mockPersistenceManager = MockPersistenceManager()
        mockImageService = MockImageService()
        sut = .init(profile: profile,
                    persistenceManager: mockPersistenceManager,
                    imageService: mockImageService)
    }

    override func tearDown() {
        mockPersistenceManager = nil
        mockImageService = nil
        sut = nil
        super.tearDown()
    }
    
    func testSuccessfulInit() {
        XCTAssertNotNil(mockPersistenceManager)
        XCTAssertNotNil(mockImageService)
        XCTAssertNoThrow(sut)
    }
    
    func testAddToFavouritesIsSuccessful() {
        sut.profile = profile
        sut.addToFavourites()
        XCTAssertEqual(sut.profile.isFavourited!, true)
    }
    
    func testDownloadImageIsSuccessful() {
        let expectation = expectation(description: "Image returned")
        sut.downloadImage()
        DispatchQueue.main.async {
            self.sut.profileImage = self.mockImageService.profileImage
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(sut.profileImage)
    }
    

}
