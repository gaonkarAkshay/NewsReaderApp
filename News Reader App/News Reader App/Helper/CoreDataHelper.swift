//
//  CoreDataHelper.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 15/03/26.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {

    static let shared = CoreDataHelper()

    private init() {}

    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveBookmark(article: Article) {

        let entity = BookmarkArticle(context: context)

        entity.url = article.url
        entity.title = article.title
        entity.source = article.source?.name
        entity.publishedAt = article.publishedAt
        entity.imageUrl = article.urlToImage
        entity.isBookMarked = article.isBookMarked

        do {
            try context.save()
        } catch {
            print("Save error:", error)
        }
    }

    func fetchBookmarks() -> [BookmarkArticle] {

        let request: NSFetchRequest<BookmarkArticle> = BookmarkArticle.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error:", error)
            return []
        }
    }
    
    func deleteBookmark(url: String) {

        let request: NSFetchRequest<BookmarkArticle> = BookmarkArticle.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)

        do {

            let result = try context.fetch(request)

            for object in result {
                context.delete(object)
            }

            try context.save()

        } catch {
            print("Delete error:", error)
        }
    }
    
    func bookmarkedUrls() -> Set<String> {

        let bookmarks = fetchBookmarks()

        let urls = bookmarks.compactMap { $0.url }

        return Set(urls)
    }
}
