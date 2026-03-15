//
//  Article.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 14/03/26.
//

import Foundation

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let desc: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    var isBookMarked: Bool = false
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case desc = "description"
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

struct NewsResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Source: Codable {

    let id: String?
    let name: String?
}
