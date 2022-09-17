//
//  iOSEngineerCodeCheckSlowTests.swift
//  iOSEngineerCodeCheckSlowTests
//
//  Created by イツキ on 2022/09/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck


final class iOSEngineerCodeCheckSlowTests: XCTestCase {
    var repositoryDataManager: RepositoryDataManager!
    var repoDataList: [RepositoryModel]?
    var imgData: Data?
    var expectation: XCTestExpectation?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        repositoryDataManager = RepositoryDataManager()
        repositoryDataManager.delegate = self
        repoDataList = nil
        imgData = nil
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        repositoryDataManager = nil
        repoDataList = nil
        imgData = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_RepositoryDataMangager_fetchRepoData() {
        // Act
        expectation = expectation(description: "fetch repository data")
        repositoryDataManager.fetchRepoData("test")

        // Assert
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(repoDataList, "success in fetching repository Data")
    }
    
    func test_RepositoryDataMangager_fetchImgData() {
        // Act
        expectation = expectation(description: "fetch Image data")
        repositoryDataManager.fetchAvatarImage(from: "https://avatars.githubusercontent.com/u/11684617?v=4")

        // Assert
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(imgData, "success in fetching Image Data")
    }
    
    
    
}

extension iOSEngineerCodeCheckSlowTests: RepositoryDataDelegate {
    func carryRepoData(_ repositoryDataManager: RepositoryDataManager, didFetchRepoData repoData: [RepositoryModel]) {
        self.repoDataList = repoData
        self.expectation?.fulfill()
        self.expectation = nil
    }

    func carryError(_ repositoryDataManager: RepositoryDataManager, didFailWithError error: String) {
        self.repoDataList = nil
        self.imgData = nil
        self.expectation = nil
    }
    
    func carryImgData(_ repositoryDataManager: RepositoryDataManager, didFetchImageData imgData: Data) {
        self.imgData = imgData
        self.expectation?.fulfill()
        self.expectation = nil
        
    }

    
}
