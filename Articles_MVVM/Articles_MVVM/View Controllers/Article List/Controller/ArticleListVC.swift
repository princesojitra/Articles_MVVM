//
//  ArticleListVC.swift
//  Articles_MVVM
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//

import UIKit

class ArticleListVC: UIViewController {

    @IBOutlet weak var tblViewArticlesList : UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNeedsStatusBarAppearanceUpdate()
        self.setupTableView()
        self.fecthArticles()
    }
    
    func setupTableView(){
        tblViewArticlesList.register(UINib(nibName: Constants.TblCellIdentifier.ArticleList, bundle: nil), forCellReuseIdentifier: Constants.TblCellIdentifier.ArticleList)
        tblViewArticlesList.estimatedRowHeight = 50
        tblViewArticlesList.tableFooterView = UIView()
        if #available(iOS 13.0, *) {
            tblViewArticlesList.refreshControl = self.refreshControl
        }
        else{
            tblViewArticlesList.addSubview(self.refreshControl)
        }
    }
    
    func fecthArticles(){
        if  ConnectionCheck.isConnectedToInternet() {
            ArticleListService.shared.fetchArticles(isFromFirstPage: false, isShowLoader: true) { (error, isMoreResult) in
                if let error = error {
                    print("Failed to fetch articles:", error)
                    return
                }
               
            }
        }else{
            print("no internet connection, load data in offline mode")
        
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ArticleListVC : UITableViewDataSource,UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = tableView.dequeueReusableCell(withIdentifier: Constants.TblCellIdentifier.ArticleList) as! ArticleTblCell
        return articleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
