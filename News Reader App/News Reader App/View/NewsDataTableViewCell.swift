//
//  NewsDataTableViewCell.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 15/03/26.
//

import UIKit

class NewsDataTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleHeaderLabel: UILabel!
    @IBOutlet weak var articleTitleValueLabel: UILabel!
    @IBOutlet weak var articleSourceHeaderLabel: UILabel!
    @IBOutlet weak var articleSourceValueLabel: UILabel!
    @IBOutlet weak var articlePubllicationDateHeaderLabel: UILabel!
    @IBOutlet weak var articlePubllicationDateValueLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var bookMarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderColor = UIColor.lightGray.cgColor
        mainView.layer.borderWidth = 1.0
        mainView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
