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
    var sut_repositoryDataManager: RepositoryDataManager!
    var repoDataList: [RepositoryModel]?
    var imgData: Data?
    var expectation_testSuccess: XCTestExpectation?
    var expectation_testFailure: XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut_repositoryDataManager = RepositoryDataManager()
        sut_repositoryDataManager.delegate = self
        repoDataList = nil
        imgData = nil
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut_repositoryDataManager = nil
        repoDataList = nil
        imgData = nil
        try super.tearDownWithError()
    }

    func test_RepositoryDataMangager_fetchRepoData_validInput() {
        // Act
        expectation_testSuccess = expectation(description: "fetch repository data")
        sut_repositoryDataManager.fetchRepoData("test")

        // Assert
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(repoDataList, "fail in fetching repository Data")
    }
    
    func test_RepositoryDataMangager_fetchImgData_validInput() {
        // Act
        expectation_testSuccess = expectation(description: "fetch Image data")
        sut_repositoryDataManager.fetchAvatarImage(from: "https://avatars.githubusercontent.com/u/11684617?v=4")

        // Assert
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(imgData, "fail in fetching Image Data")
    }
    
    
    func test_RepositoryDataMangager_filterRepoList() {
        
        expectation_testSuccess = expectation(description: "fetch repository data")
        sut_repositoryDataManager.fetchRepoData("test")
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(repoDataList, "fail in fetching repository Data")
        
        // button
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "RootViewController") as? RootViewController
        guard let rootVC = rootVC else {
            return
        }
        
        rootVC.loadViewIfNeeded()
        rootVC.starSwitch.isOn = true
        rootVC.langButtonC.isSelected = false
        rootVC.sortNewestButton.isSelected = true
        
        let filteredList = sut_repositoryDataManager.manageRepoList(starSwitch: rootVC.starSwitch, langButtons: rootVC.langButtonList, repoList: repoDataList ?? [], dateSortType: .byNewest)
          
  
        var currentDate = stringToDate(dateTimeString: filteredList[0].updated_at)
        var prevDate = Date.now
        
        for repo in filteredList {
            XCTAssertTrue(rootVC.starSwitch.isOn == repo.showStar, "failed in filtering star repository")
            
            
            currentDate = stringToDate(dateTimeString: repo.updated_at)
            print(currentDate)
            print(prevDate)
            
            
            XCTAssertTrue(currentDate <= prevDate, "failed in sorting by newest order")
            prevDate = currentDate
            
            for langButton in rootVC.langButtonList {
                if langButton.titleLabel?.text == repo.language {
                    XCTAssertTrue(langButton.isSelected, "failed in language filtering for major language.")
                } else if (langButton.titleLabel?.text == "Other" && !K.languages.allCases.contains(where: { $0.rawValue == (repo.language ?? "")})) {
                    XCTAssertTrue(langButton.isSelected == true, "failed in language filtering for other languages.")
                }
            }
            
        }
        
    }
    
    
    func test_RepositoryDataMangager_fetchRepoData_InvalidInput() {
        // Act
        expectation_testFailure = expectation(description: "try fetch repository data: expected to fail")
        sut_repositoryDataManager.fetchRepoData("t. t")

        // Assert
        waitForExpectations(timeout: 10)
        XCTAssertNil(repoDataList, "fetch request went through when it supposes to fail")
        
    }

    func test_RepositoryDataMangager_fetchImgData_InvalidURL() {
        
        // Act
        expectation_testFailure = expectation(description: "try fetch image data: expected to fail")
        sut_repositoryDataManager.fetchAvatarImage(from: "")

        // Assert
        waitForExpectations(timeout: 10)
        XCTAssertNil(imgData, "fetch request went through when it supposes to fail")
    }
    
    
    
    
    // MARK: - performance test

    func test_RepoListFetchingPerformance() throws {
        
        measure(
            metrics: [
                XCTClockMetric(),
                XCTCPUMetric(),
                XCTStorageMetric(),
                XCTMemoryMetric()
            ]
        ) {
            self.test_RepositoryDataMangager_fetchRepoData_validInput()
        }
    }
    
    func test_ImgFetchingPerformance() throws {
        
        measure(
            metrics: [
                XCTClockMetric(),
                XCTCPUMetric(),
                XCTStorageMetric(),
                XCTMemoryMetric()
            ]
        ) {
            self.test_RepositoryDataMangager_fetchImgData_validInput()
        }
    }


}



// MARK: - delegate functions

extension iOSEngineerCodeCheckSlowTests: RepositoryDataDelegate {
    func carryRepoData(_ repositoryDataManager: RepositoryDataManager, didFetchRepoData repoData: [RepositoryModel]) {
        self.repoDataList = repoData
        self.expectation_testSuccess?.fulfill()
        self.expectation_testSuccess = nil
    }
    
    func carryError(_ repositoryDataManager: RepositoryDataManager, didFailWithError error: String) {
        self.repoDataList = nil
        self.imgData = nil
        expectation_testFailure?.fulfill()
        self.expectation_testFailure = nil
    }
    
    func carryImgData(_ repositoryDataManager: RepositoryDataManager, didFetchImageData imgData: Data) {
        self.imgData = imgData
        self.expectation_testSuccess?.fulfill()
        self.expectation_testSuccess = nil
        
    }
}
    
extension iOSEngineerCodeCheckSlowTests{
    
    private func stringToDate(dateTimeString: String?) -> Date {
        guard let dateTimeString = dateTimeString else {
            return Date(timeIntervalSince1970: TimeInterval(0))
        }
        let formatter_StringToDate = DateFormatter()
        formatter_StringToDate.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let time_dateTime = formatter_StringToDate.date(from: dateTimeString)
        return time_dateTime ?? Date(timeIntervalSince1970: TimeInterval(0))
    }
    
}
