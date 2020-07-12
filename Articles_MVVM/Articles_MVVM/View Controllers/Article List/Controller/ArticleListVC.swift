//
//  ArticleListVC.swift
//  Articles_MVVM
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//

import UIKit
import CoreData

class ArticleListVC: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var tblViewArticlesList : UITableView!
    
    
    //MARK: - Variables
    var articleViewModels = [ArticlesViewModel]()
    var isPageRefresh = false
    var isMoreResult = false
    
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
        self.setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    //MARK: - Action Methods
    @objc func refreshData(_ refreshControl: UIRefreshControl) {
        self.isPageRefresh = true
        self.fetchArticlesData(isFromStart: true, isShowLoader: false)
        
    }
    
    //MARK: - Other Methods
    
    func setupNavBar() {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func setupTableView(){
        
        tblViewArticlesList.register(UINib(nibName: Constants.TblCellIdentifier.ArticleList, bundle: nil), forCellReuseIdentifier: Constants.TblCellIdentifier.ArticleList)
        tblViewArticlesList.estimatedRowHeight = 50
        tblViewArticlesList.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            tblViewArticlesList.refreshControl = refreshControl
        } else {
            
            tblViewArticlesList.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        self.isPageRefresh = true
        self.fetchArticlesData( isFromStart: true, isShowLoader: true)
    }
    
    func fetchArticlesData(isFromStart:Bool,isShowLoader:Bool){
        if  ConnectionCheck.isConnectedToInternet() {
            ArticleListService.shared.fetchArticles(isFromFirstPage: isFromStart, isShowLoader: isShowLoader) { (error, isMoreResult) in
                if let error = error {
                    print("Failed to fetch articles:", error)
                    return
                }
                self.isMoreResult = isMoreResult
                let articlesData = ArticleListService.shared.loadSavedArticlesDataOnline()
                self.reloadArticles(artticles: articlesData)
            }
        }else{
            print("no internet connection, load data in offline mode")
            
            if isFromStart {
                let articlesDataTuple =  ArticleListService.shared.loadArticlesDataFromStartPage()
                self.isMoreResult = articlesDataTuple.1
                self.reloadArticles(artticles: articlesDataTuple.0)
            }else {
                let articlesDataTuple =  ArticleListService.shared.loadSavedArticlesDataOffline()
                self.isMoreResult = articlesDataTuple.1
                self.reloadArticles(artticles: articlesDataTuple.0)
            }
            
        }
    }
    
    
    func reloadArticles(artticles: [NSManagedObject]){
        self.articleViewModels = artticles.map({
            return ArticlesViewModel(article: $0 as! UserArticle)
        })
        
        self.stopLoaderWithEndRefreshing()
        
        if self.isPageRefresh {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                self.isPageRefresh = false
            })
        }
        self.tblViewArticlesList.reloadData()
        
    }
    
    //Stop Refresh control
    func stopLoaderWithEndRefreshing(){
        DispatchQueue.main.async {  [weak self] in
            CustomLoader.shared.hideLoader()
            guard let strongSelf = self else { return }
            if strongSelf.refreshControl.isRefreshing {
                strongSelf.refreshControl.endRefreshing()
            } else if !strongSelf.refreshControl.isHidden {
                strongSelf.refreshControl.beginRefreshing()
                strongSelf.refreshControl.endRefreshing()
            }
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate Methods
extension ArticleListVC :  UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTblCell") as! ArticleTblCell
        let articleViewModel = articleViewModels[indexPath.row]
        articleCell.articleViewModel = articleViewModel
        return articleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - UIScrollViewDelegate Methods
extension ArticleListVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.height
        
        if bottomEdge >= scrollView.contentSize.height {
            if !self.isPageRefresh  {
                if self.isMoreResult {
                    self.isPageRefresh = true
                    self.fetchArticlesData(isFromStart: false, isShowLoader: true)
                    print("page refresh:",ArticleListService.shared.page)
                }
            }
        }
    }
}
