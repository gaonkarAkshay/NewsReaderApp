//
//  UITableView+Extension.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 15/03/26.
//

import UIKit

extension UITableView {
    func setEmptyView(message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.systemGray
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.text = message
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        emptyView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -15).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -15).isActive = true
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
