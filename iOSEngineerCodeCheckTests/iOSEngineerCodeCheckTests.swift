//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class iOSEngineerCodeCheckTests: XCTestCase {
    var sut_repositoryDataManager: RepositoryDataManager!

    var sut_repoList: RepositoryList!
    var sut_repoModel_1: RepositoryModel!
    var sut_repoModel_2: RepositoryModel!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut_repositoryDataManager = RepositoryDataManager()
        sut_repoModel_1 = RepositoryModel(
            id: 53357782,
            full_name: "acidanthera/AppleALC",
            owner: RepositoryModel.OwnerModel(avatar_url: "https://avatars.githubusercontent.com/u/39672954?v=4"),
            language: "C++",
            stargazers_count: 3052,
            wachers_count: 3052,
            forks_count: 882,
            open_issues_count: 2
        )
        sut_repoModel_2 = RepositoryModel(
            id: 50328557,
            full_name: "gongjianhui/AppleDNS",
            owner: RepositoryModel.OwnerModel(avatar_url: "https://avatars.githubusercontent.com/u/4310161?v=4"),
            language: "Python",
            stargazers_count: 2353,
            wachers_count: 2353,
            forks_count: 308,
            open_issues_count: 0
        )
        sut_repoList = RepositoryList(items: [sut_repoModel_1, sut_repoModel_2])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut_repoList = nil
        sut_repoModel_1 = nil
        sut_repoModel_2 = nil
        sut_repositoryDataManager = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func test_customCodingModel_returnsExpectedValue() throws {
        // Given
        let repositoryList = sut_repoList

        //When
        let encodedRepositoryList = try JSONEncoder().encode(repositoryList)
        let decodedRepositoryList = try JSONDecoder().decode(RepositoryList.self, from: encodedRepositoryList)

        //Then
        XCTAssertEqual(
            decodedRepositoryList,
            repositoryList,
            "Decoded Object doesn't match the given RepositoryList object"
        )
    }
    
    func test_RepositoryDataMangager_decodeRepoData() throws {
        let result_expected = sut_repoList.items
        let encodedRepositoryList = try JSONEncoder().encode(sut_repoList)
        let result = sut_repositoryDataManager.decodeRepoData(encodedRepositoryList)
        XCTAssertEqual(
            result_expected,
            result,
            "Decoded Object doesn't match the given RepositoryList object"
        )
    }
    

}
