//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck
// @testable import Git_Repo_Search


class iOSEngineerCodeCheckUITests: XCTestCase {
    var app: XCUIApplication!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func test_UISearchBar_typing() {
        // let searchBarElement = app.tables.searchFields["GitHubのリポジトリを検索"]
        let textFieldElement = app.textFields["textField"]
        XCTAssertTrue(textFieldElement.exists, "search bar does not exists")
        textFieldElement.tap()
        textFieldElement.typeText("test")
        
    }
    
    func test_navigation() {
        
        let textFieldElement = app.textFields["textField"]
        XCTAssertTrue(textFieldElement.exists, "search bar does not exists")
        
        let repolisttableTable = app.tables["RepoListTable"]
        XCTAssertTrue(repolisttableTable.exists, "table does not exists")
        
        
        textFieldElement.tap()
        textFieldElement.typeText("test")
        
        app.buttons["Return"].tap()
        
        // wait for data to load
        let tableCell_0 = repolisttableTable.cells["0"]
        let exists = NSPredicate(format: "exists == 1")
        let expectation = expectation(for: exists, evaluatedWith: tableCell_0)
        waitForExpectations(timeout: 10, handler: nil)
        
        
        XCTAssertTrue(tableCell_0.exists, "cell 0 is not on the table")
        tableCell_0.tap()
        expectation.fulfill()
        // repolisttableTable.cells["0"].staticTexts.element(boundBy: 0).tap()
        
        let backButton = app.navigationBars["NavBar"].buttons["GitHub Repository Search"]
        backButton.tap()
        
        repolisttableTable.cells["1"].staticTexts.element(boundBy: 0).tap()
        backButton.tap()
        
    }
    
    
    func test_tableViewScroll() {
        
        let textFieldElement = app.textFields["textField"]
        let repolisttableTable = app.tables["RepoListTable"]
        
        textFieldElement.tap()
        textFieldElement.typeText("google")
        
        app.buttons["Return"].tap()
        
        // wait for data to load
        let tableCell_0 = repolisttableTable.cells["0"]
        let exists = NSPredicate(format: "exists == 1")
        let expectation = expectation(for: exists, evaluatedWith: tableCell_0)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(tableCell_0.exists, "cell 0 is not on the table")
        expectation.fulfill()

        let cellCount = repolisttableTable.cells.count
        let lastTableCell = repolisttableTable.cells[String(cellCount - 1)]
            
        // scroll to the end
        while !lastTableCell.isHittable {
            repolisttableTable.swipeUp()
        }
        XCTAssertTrue(lastTableCell.isHittable, "Not able to scroll to the end of the Table")
        
        // scroll back to the top
        while !tableCell_0.isHittable {
            repolisttableTable.swipeDown()
        }
        XCTAssertTrue(tableCell_0.isHittable, "Not able to scroll to the beginning of the Table")

    }
    
    
    func testStarFilter() {
        
        let textFieldElement = app.textFields["textField"]
        let repolisttableTable = app.tables["RepoListTable"]
        
        textFieldElement.tap()
        textFieldElement.typeText("test")
        
        app.buttons["Return"].tap()
        
        
        // wait for data to load
        let tableCell_0 = repolisttableTable.cells["0"]
        let exists = NSPredicate(format: "exists == 1")
        let expectation = expectation(for: exists, evaluatedWith: tableCell_0)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(tableCell_0.exists, "cell 0 is not on the table")
        expectation.fulfill()
        
        
        app.buttons["control center"].tap()
        app.switches["starSwitch"].tap()
        
        // wait for data to load
        let cellCount = repolisttableTable.cells.count
        
        for i in 0..<cellCount {
            XCTAssertTrue(repolisttableTable.cells[String(i)].images["starImage"].exists, "star filter does not work properly")
        }
        
    }
    
    
    func testLanguageFilter() {
        
        let textFieldElement = app.textFields["textField"]
        let repolisttableTable = app.tables["RepoListTable"]
        
        textFieldElement.tap()
        textFieldElement.typeText("test")
        
        app.buttons["Return"].tap()
        
        
        // wait for data to load
        let tableCell_0 = repolisttableTable.cells["0"]
        let exists = NSPredicate(format: "exists == 1")
        let expectation = expectation(for: exists, evaluatedWith: tableCell_0)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(tableCell_0.exists, "cell 0 is not on the table")
        expectation.fulfill()
        
        
        app.buttons["control center"].tap()
        // unselect C
        app.buttons["C"].tap()
        app.buttons["C++"].tap()

        app.buttons["control center"].tap()

        
        // wait for data to load
        let cellCount = repolisttableTable.cells.count
        
        for i in 0..<cellCount {
            let langLabel = repolisttableTable.cells[String(i)].staticTexts["repoLanguageLabel"]
            if langLabel.exists {
                XCTAssertTrue(langLabel.label != "C", "language filter does not work properly")
                XCTAssertTrue(langLabel.label != "C++", "language filter does not work properly")
            }
        }
        
        
    }
    
    
    
    func test_detailViewLabelExist() {
        
        let textFieldElement = app.textFields["textField"]
        let repolisttableTable = app.tables["RepoListTable"]
        
        textFieldElement.tap()
        textFieldElement.typeText("google")
        
        app.buttons["Return"].tap()
        
        // wait for data to load
        let tableCell_0 = repolisttableTable.cells["0"]
        let exists = NSPredicate(format: "exists == 1")
        let expectation = expectation(for: exists, evaluatedWith: tableCell_0)
        waitForExpectations(timeout: 10, handler: nil)
        
        
        XCTAssertTrue(tableCell_0.exists, "cell 0 is not on the table")
        tableCell_0.tap()
        expectation.fulfill()
        
        // detail view
        
        let imgView = app.images["AvatarImage"]
        XCTAssertTrue(imgView.exists, "title label does not exist")

        
        let titleLabel = app.staticTexts["TitleLabel"]
        XCTAssertTrue(titleLabel.exists, "title label does not exist")
        
        let languageLabel = app.staticTexts["LanguageLabel"]
        XCTAssertTrue(languageLabel.exists, "title label does not exist")


        let starsLabel = app.staticTexts["StarsLabel"]
        XCTAssertTrue(starsLabel.exists, "title label does not exist")
        let watchesLabel = app.staticTexts["WatchesLabel"]
        XCTAssertTrue(watchesLabel.exists, "title label does not exist")
        let forksLabel = app.staticTexts["ForksLabel"]
        XCTAssertTrue(forksLabel.exists, "title label does not exist")
        let issuesLabel = app.staticTexts["IssuesLabel"]
        XCTAssertTrue(issuesLabel.exists, "title label does not exist")

        let gitHubOpenButton = app.buttons["gitHubOpenButton"]
        XCTAssertTrue(gitHubOpenButton.exists, "gitHub open Button does not exist")

    }
    
    func test_alertView() {
        
        let textFieldElement = app.textFields["textField"]

        textFieldElement.tap()
        textFieldElement.typeText("t. t")
        
        app.buttons["Return"].tap()
        
        // wait for data to load
      
        let alertView = app.alerts.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let expectation = expectation(for: exists, evaluatedWith: alertView)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(alertView.exists, "alert does not show up")
        expectation.fulfill()
        let okButton = alertView.buttons["OK"]
        okButton.tap()

    }
    
    // MARK: - performance test
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
}
