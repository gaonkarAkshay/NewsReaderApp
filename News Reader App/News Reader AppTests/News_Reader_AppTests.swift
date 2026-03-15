//
//  News_Reader_AppTests.swift
//  News Reader AppTests
//
//  Created by Akshay  Ashok Gaonkar on 14/03/26.
//


import XCTest
@testable import News_Reader_App

final class News_Reader_AppTests: XCTestCase {
    
    var viewModel: NewsDashboardViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = NewsDashboardViewModel()
    }
    
    override func tearDown(){
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Helper
    
    func mockArticle(title: String) -> Article {
        return Article(
            source: nil,
            author: "Author",
            title: title,
            desc: "Description",
            url: "https://test.com/\(title)",
            urlToImage: nil,
            publishedAt: "2026-03-15",
            content: "Content",
            isBookMarked: false
        )
    }
    
    // MARK: - Tests
    func testNumberOfRowsWhenArticlesExist() {
        let article1 = mockArticle(title: "News1")
        let article2 = mockArticle(title: "News2")
        viewModel.filteredArticles = [article1, article2]
        XCTAssertEqual(viewModel.numberOfRows(), 2)
    }
    
    func testNumberOfRowsWhenNoArticles() {
        viewModel.filteredArticles = []
        XCTAssertEqual(viewModel.numberOfRows(), 0)
    }
    
    func testArticleAtIndex() {
        let article = mockArticle(title: "Apple News")
        viewModel.filteredArticles = [article]
        let result = viewModel.article(at: 0)
        XCTAssertEqual(result.title, "Apple News")
    }
    
    func testFilterDataWithEmptySearchText() {
        let article1 = mockArticle(title: "Apple")
        let article2 = mockArticle(title: "Google")
        viewModel.articles = [article1, article2]
        viewModel.filterData(searchText: "")
        XCTAssertEqual(viewModel.filteredArticles.count, 2)
    }
    
    func testFilterDataWithSearchText() {
        let article1 = mockArticle(title: "Apple News")
        let article2 = mockArticle(title: "Google News")
        viewModel.articles = [article1, article2]
        viewModel.filterData(searchText: "Apple")
        XCTAssertNotNil(viewModel.filteredArticles)
    }
    
    func testFilterDataBasedOnTabFalse() {
        let article1 = mockArticle(title: "News1")
        viewModel.articles = [article1]
        viewModel.filterDataBasedOnTab(isBookmarks: false)
        XCTAssertFalse(viewModel.isBookmarks)
        XCTAssertEqual(viewModel.filteredArticles.count, 1)
    }
    
    func testPaginationInitialValues() {
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.pageSize, 11)
        XCTAssertEqual(viewModel.totalResults, 0)
    }
}
