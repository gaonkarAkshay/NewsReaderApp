//
//  NewsDashboardViewModel.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 14/03/26.
//

import Foundation
import UIKit

class NewsDashboardViewModel {

    var articles: [Article] = []
    var filteredArticles: [Article] = []
    var bookmarkArticles: [BookmarkArticle] = []
    var filteredBookmarkArticles: [BookmarkArticle] = []
    var isBookmarks: Bool = false
    var reloadData: (() -> Void)?
    var reloadRow: ((IndexPath) -> Void)?
    var currentPage = 1
    var pageSize = 11
    var totalResults = 0
    var isLoading = false
    var showLoader: (() -> Void)?
    var hideLoader: (() -> Void)?

    func fetchNews() {
        if isLoading { return }
        if articles.count >= totalResults && totalResults != 0 {
            return
        }
        
        isLoading = true
        showLoader?()
        
        let urlString = "\(Constants.API.baseURL)/top-headlines?country=us&page=\(currentPage)&pageSize=\(pageSize)&apiKey=\(Constants.API.apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        ApiHelper.shared.request(url: url) { (result: Result<NewsResponse, NetworkError>) in
            switch result {
            case .success(let response):
                defer {
                    self.isLoading = false
                }
                self.totalResults = response.totalResults ?? 0
                if (response.articles ?? []).count > 0 {
                    self.articles.append(contentsOf: self.updateBookmarkStatus(for: response.articles ?? []))
                    self.filteredArticles = self.articles
                    self.currentPage += 1
                }
                DispatchQueue.main.async {
                    self.hideLoader?()
                    self.reloadData?()
                }
            case .failure(let error):
                defer {
                    self.isLoading = false
                }
            }
        }
    }
    
    func updateBookmarkStatus(for articles: [Article]) -> [Article] {
        var updatedArticles = articles
        let bookmarkedSet = CoreDataHelper.shared.bookmarkedUrls()
        for index in updatedArticles.indices {
            if let url = updatedArticles[index].url,
               bookmarkedSet.contains(url) {
                updatedArticles[index].isBookMarked = true
            } else {
                updatedArticles[index].isBookMarked = false
            }
        }
        return updatedArticles
    }
    
    func filterDataBasedOnTab(isBookmarks: Bool){
        self.isBookmarks = isBookmarks
        if self.isBookmarks {
            bookmarkArticles = CoreDataHelper.shared.fetchBookmarks()
            filteredBookmarkArticles = bookmarkArticles
            reloadData?()
        } else {
            articles = self.updateBookmarkStatus(for: articles)
            filteredArticles = articles
            reloadData?()
        }
    }

    func numberOfRows() -> Int {
        if self.isBookmarks {
            return filteredBookmarkArticles.count
        } else {
            return filteredArticles.count
        }
    }
    
    func configureCell(cell: UITableViewCell, articleObject: Article?, bookmarkArticleObject: BookmarkArticle?, tag: Int) {
        guard let newsCell = cell as? NewsDataTableViewCell else {
            return
        }
        if let dataObject = articleObject {
            newsCell.articleTitleValueLabel.text = dataObject.title ?? ""
            newsCell.articleSourceValueLabel.text = dataObject.source?.name ?? ""
            newsCell.articlePubllicationDateValueLabel.text = CommonData.shared.formatDate(dataObject.publishedAt ?? "")
            if dataObject.isBookMarked {
                newsCell.bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                newsCell.bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            if let imageURL = dataObject.urlToImage, !imageURL.isEmpty {
                newsCell.articleImageView.loadImage(from: imageURL)
            } else {
                newsCell.articleImageView.image = UIImage(systemName: "arrow.down.circle.dotted")
            }
        } else if let dataObject = bookmarkArticleObject {
            newsCell.articleTitleValueLabel.text = dataObject.title ?? ""
            newsCell.articleSourceValueLabel.text = dataObject.source ?? ""
            newsCell.articlePubllicationDateValueLabel.text = CommonData.shared.formatDate(dataObject.publishedAt ?? "")
            if dataObject.isBookMarked {
                newsCell.bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                newsCell.bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            if let imageURL = dataObject.imageUrl, !imageURL.isEmpty {
                newsCell.articleImageView.loadImage(from: imageURL)
            } else {
                newsCell.articleImageView.image = UIImage(systemName: "arrow.down.circle.dotted")
            }
        }
        
        newsCell.detailsButton.tag = tag
        newsCell.detailsButton.addTarget(self, action: #selector(showDetails(sender:)), for: .touchUpInside)
        
        newsCell.bookMarkButton.tag = tag
        newsCell.bookMarkButton.addTarget(self, action: #selector(bookmarkAction(sender:)), for: .touchUpInside)
    }
    
    @objc func showDetails(sender: UIButton) {
        if isBookmarks {
            let article = filteredBookmarkArticles[sender.tag]
            guard let urlString = article.url,
                  let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)
        } else {
            let article = filteredArticles[sender.tag]
            guard let urlString = article.url,
                  let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @objc func bookmarkAction(sender: UIButton) {
        if isBookmarks {
            filteredBookmarkArticles[sender.tag].isBookMarked.toggle()
            let article = filteredBookmarkArticles[sender.tag]
            if !article.isBookMarked {
                if let url = article.url {
                    CoreDataHelper.shared.deleteBookmark(url: url)
                }
            }
            bookmarkArticles = CoreDataHelper.shared.fetchBookmarks()
            filteredBookmarkArticles = bookmarkArticles
            reloadData?()
        } else {
            filteredArticles[sender.tag].isBookMarked.toggle()
            if let index = articles.firstIndex(where: {$0.url == filteredArticles[sender.tag].url}) {
                articles[index].isBookMarked.toggle()
            }
            let article = filteredArticles[sender.tag]
            if article.isBookMarked {
                CoreDataHelper.shared.saveBookmark(article: article)
            } else {
                if let url = article.url {
                    CoreDataHelper.shared.deleteBookmark(url: url)
                }
            }
            let indexPath = IndexPath(row: sender.tag, section: 0)
            reloadRow?(indexPath)
        }
    }
    
    func filterData(searchText: String) {
        if !searchText.isEmpty {
            if isBookmarks {
                filteredBookmarkArticles = CommonData.shared.fuzzySearch(searchString: searchText, fromData: bookmarkArticles, keyPaths: [\.title, \.source])
            } else {
                filteredArticles = CommonData.shared.fuzzySearch(searchString: searchText, fromData: articles, keyPaths: [\.title, \.source?.name])
            }
        } else {
            if isBookmarks {
                filteredBookmarkArticles = bookmarkArticles
            } else {
                filteredArticles = articles
            }
        }
        reloadData?()
    }
}
