//
//  ProfileListVMTest.swift
//  LagosDevsTests
//
//  Created by Yemi Gabriel on 5/13/22.
//

import XCTest

@testable import LagosDevs
class ProfileListVMTest: XCTestCase {

    var sut: ProfileListVM!
    var mockProfileRepository: MockProfileRepository!
    
    override func setUp() {
        super.setUp()
        mockProfileRepository = MockProfileRepository()
        sut = .init(profileRepository: mockProfileRepository)
    }

    override func tearDown() {
        mockProfileRepository = nil
        sut = nil
        super.tearDown()
    }
    
    func testSuccessfulInit() {
        XCTAssertNotNil(mockProfileRepository)
        XCTAssertNoThrow(sut)
    }
    
    func testFetchRemoteProfilesIsSuccessful() {
        sut.isFetchingProfiles = true
        let expectation = expectation(description: "Profiles result returned")
        sut.fetchRemoteProfiles()
        DispatchQueue.main.async {
            self.sut.profileResults.append(contentsOf: self.mockProfileRepository.fetchedProfiles )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(sut.profileResults.count, 8)
    }
    
    func testGetPersistedProfilesIsSuccessful() {
        let expectation = expectation(description: "Profiles result returned")
        sut.getPersistedProfiles()
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(sut.profileResults.count, 8)
    }
    
    func testGroupProfilesBySectionsIsSucccessful() {
        sut.groupBySection(profiles: Profile.sampleProfiles())
        XCTAssertEqual(sut.groupedProfileResults.count, 5)
    }

}
