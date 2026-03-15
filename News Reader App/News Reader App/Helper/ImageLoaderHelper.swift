//
//  ImageLoaderHelper.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 15/03/26.
//

import UIKit

class ImageLoaderHelper {

    static let shared = ImageLoaderHelper()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func loadImage(from urlString: String,
                   completion: @escaping (UIImage?) -> Void) {

        // Check cache first
        if let cachedImage = cache.object(forKey: NSString(string: urlString)) {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in

            guard let data = data,
                  let image = UIImage(data: data) else {

                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Save to cache
            self.cache.setObject(image, forKey: NSString(string: urlString))

            DispatchQueue.main.async {
                completion(image)
            }

        }.resume()
    }
}

