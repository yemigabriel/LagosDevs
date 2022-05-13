//
//  FavouriteListVMTest.swift
//  LagosDevsTests
//
//  Created by Yemi Gabriel on 5/13/22.
//

import XCTest

@testable import LagosDevs
class FavouriteListVMTest: XCTestCase {

    var sut: FavouriteListVM!
    var mockPersistenceManager: MockPersistenceManager!
    
    
    override func setUp() {
        super.setUp()
        mockPersistenceManager = MockPersistenceManager()
        sut = .init(persistenceManager: mockPersistenceManager)
    }

    override func tearDown() {
        mockPersistenceManager = nil
        sut = nil
        super.tearDown()
    }
    
    func testSuccessfulInit() {
        XCTAssertNotNil(mockPersistenceManager)
        XCTAssertNoThrow(sut)
    }
    
    func testGetAllFavouriteProfilesIsSuccessful() {
        sut.getFavouriteProfiles()
        XCTAssertEqual(sut.favouriteProfiles.count, 2)
    }
    
    func testRemoveFavouriteIsSuccessful() {
        let index = 0
        sut.favouriteProfiles = Profile.sampleProfiles()
        sut.removeFavourite(at: index)
        XCTAssertEqual(sut.favouriteProfiles[index].isFavourited, false)
    }
    
    func testClearAllFavouritesIsSuccessful() {
        sut.favouriteProfiles = Profile.sampleProfiles()
        sut.clearAllFavourites()
        XCTAssertEqual(sut.favouriteProfiles[0].isFavourited, false)
        XCTAssertEqual(sut.favouriteProfiles[3].isFavourited, false)
    }

}
