//
//  UIImageView+Extension.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 15/03/26.
//

import UIKit

extension UIImageView {

    func loadImage(from urlString: String) {
        ImageLoaderHelper.shared.loadImage(from: urlString) { [weak self] image in
            self?.image = image
        }
    }
}
