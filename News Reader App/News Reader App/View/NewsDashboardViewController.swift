//
//  NewsDashboardViewController.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 14/03/26.
//

import UIKit

class NewsDashboardViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serachView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var allNewsButton: UIButton!
    @IBOutlet weak var bookmarkedNewsButton: UIButton!
    @IBOutlet weak var newsTableView: UITableView!
    
    let spinner = UIActivityIndicatorView(style: .medium)
    
    private let viewModel = NewsDashboardViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
    }
    
    
    @IBAction func allNewsButtonAction(_ sender: UIButton) {
        viewModel.filterDataBasedOnTab(isBookmarks: false)
        toggleButtonDesign(isBookmarks: false)
    }
    
    @IBAction func bookmarkedNewsButtonAction(_ sender: UIButton) {
        viewModel.filterDataBasedOnTab(isBookmarks: true)
        toggleButtonDesign(isBookmarks: true)
    }
}

extension NewsDashboardViewController {
    
    func uiSetup(){
        titleLabel.text = "News"
        serachView.layer.borderColor = UIColor.lightGray.cgColor
        serachView.layer.borderWidth = 1.0
        serachView.layer.cornerRadius = 5
        searchTextField.delegate = self
        allNewsButton.layer.cornerRadius = 5
        bookmarkedNewsButton.layer.cornerRadius = 5
        toggleButtonDesign(isBookmarks: false)
        setupTableView()
        bindViewModel()
        viewModel.fetchNews()
    }
    
    func toggleButtonDesign(isBookmarks: Bool){
        if isBookmarks {
            allNewsButton.backgroundColor = .white
            allNewsButton.layer.borderColor = UIColor.tintColor.cgColor
            allNewsButton.layer.borderWidth = 1.0
            allNewsButton.setTitleColor(UIColor.tintColor, for: .normal)
            
            bookmarkedNewsButton.backgroundColor = .tintColor
            bookmarkedNewsButton.layer.borderColor = UIColor.clear.cgColor
            bookmarkedNewsButton.layer.borderWidth = 0.0
            bookmarkedNewsButton.setTitleColor(.white, for: .normal)
        } else {
            allNewsButton.backgroundColor = .tintColor
            allNewsButton.layer.borderColor = UIColor.clear.cgColor
            allNewsButton.layer.borderWidth = 0.0
            allNewsButton.setTitleColor(.white, for: .normal)
            
            bookmarkedNewsButton.backgroundColor = .white
            bookmarkedNewsButton.layer.borderColor = UIColor.tintColor.cgColor
            bookmarkedNewsButton.layer.borderWidth = 1.0
            bookmarkedNewsButton.setTitleColor(UIColor.tintColor, for: .normal)
        }
    }
    
    func setupTableView(){
        newsTableView.register(UINib(nibName: "NewsDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsDataTableViewCell")
        newsTableView.delegate = self
        newsTableView.dataSource = self
    }
    
    func setupLoader() {

        spinner.frame = CGRect(
            x: 0,
            y: 0,
            width: newsTableView.frame.width,
            height: 50
        )

        spinner.hidesWhenStopped = true

        newsTableView.tableFooterView = spinner
    }
    
    private func bindViewModel() {
        viewModel.reloadData = { [weak self] in
            self?.newsTableView.reloadData()
        }
        
        viewModel.reloadRow = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.newsTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        viewModel.showLoader = { [weak self] in
            self?.spinner.startAnimating()
        }
        
        viewModel.hideLoader = { [weak self] in
            self?.spinner.stopAnimating()
        }
    }
}

extension NewsDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRows() > 0 {
            tableView.restore()
            return viewModel.numberOfRows()
        } else {
            tableView.setEmptyView(message: "No data available.")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDataTableViewCell", for: indexPath) as? NewsDataTableViewCell else {
            return UITableViewCell()
        }
        if viewModel.isBookmarks {
            let article = viewModel.filteredBookmarkArticles[indexPath.row]
            viewModel.configureCell(cell: cell, articleObject: nil, bookmarkArticleObject: article, tag: indexPath.row)
        } else {
            let article = viewModel.filteredArticles[indexPath.row]
            viewModel.configureCell(cell: cell, articleObject: article, bookmarkArticleObject: nil, tag: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !viewModel.isBookmarks {
            let lastIndex = viewModel.articles.count - 1
            if indexPath.row == lastIndex {
                if viewModel.articles.count < viewModel.totalResults {
                    viewModel.fetchNews()
                }
            }
        }
    }
}

extension NewsDashboardViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.isEmpty == true && (string.isEmpty || string == " ") {
            return false
        }
        
        let searchText = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        viewModel.filterData(searchText: searchText)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
