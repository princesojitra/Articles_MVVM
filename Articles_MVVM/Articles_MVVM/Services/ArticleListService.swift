//
//  ArticleListService.swift
//  Articles_MVVM
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//

import Foundation

import CoreData

class ArticleListService: NSObject {
    
    static let shared = ArticleListService()
    static let pageLimit = 10
    
    //pagination
    var page = 1
    var isMoreResult = false
    var pageOffset = 0
    var articlesData = [NSManagedObject]()
    
    func fetchArticles(isFromFirstPage:Bool,isShowLoader:Bool,completion: @escaping (Error?,Bool) -> ()) {
        
        
        if isShowLoader {
            CustomLoader.shared.showLoader(color:AppColor.Color_NavyBlue)
        }
        
        //check start page load
        if isFromFirstPage {
            self.page = 1
            self.pageOffset = 0
            self.articlesData.removeAll()
            CoreDataContext.deleteAndRebuild()
        }
        
        let urlString = Constants.WebServcie.ArticleList + "?page=" + "\(page)" + "&limit=" + "\(ArticleListService.pageLimit)"
        
        guard let url = URL(string: urlString) else { return }
        
        print("******* API Log ******")
        print("URL : ", urlString )
        print("Method : ", "Get")
        print("Params :")
        print("Headers :")
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
              print("Failed to fetch courses:", err)
                if isShowLoader {
                    CustomLoader.shared.hideLoader()
                }
                print("******* API Log ******")
                completion(err, false)
            }
            
            // check response
            guard let data = data else { return }
            do {
                let articles = try JSONDecoder().decode([ArticlesDataModel].self, from: data)
                DispatchQueue.main.async {
                    
                    //check more pages available to load
                    if articles.count == ArticleListService.pageLimit {
                        self.isMoreResult = true
                        self.page = self.page + 1
                        
                    }
                    else{
                        self.isMoreResult = false
                    }
                    
                    if articles.count > 0 {
                        
                        for articleData in articles {
                            let article = UserArticle(context: CoreDataContext.persistentContainer.viewContext)
                            self.configure(article: article, usingArticleDataModel: articleData)
                        }
                    }
                    print("Response:",articles )
                    if isShowLoader {
                        CustomLoader.shared.hideLoader()
                    }
                    print("******* API Log ******")
                    completion(nil, self.isMoreResult)
                }
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
                if isShowLoader {
                    CustomLoader.shared.hideLoader()
                }
                print("******* API Log ******")
            }
        }.resume()
    }
    
    
    func  configure(article: UserArticle, usingArticleDataModel: ArticlesDataModel)  {
        
        let articleId = Int64(usingArticleDataModel.id ?? "1") ?? 0
        
        let fetchRequest: NSFetchRequest<UserArticle> = UserArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "articleID = %d", articleId )
        
        var results: [NSManagedObject] = []
        
        do {
            results = try CoreDataContext.persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        if results.count > 0 {
            print("record exist, id:",articleId)
            if let articleFromDatabase = results[0] as? UserArticle {
                self.setUpdatedArticleDetails(article: articleFromDatabase, usingArticleDataModel: usingArticleDataModel)
                CoreDataContext.persistentContainer.viewContext.refresh(articleFromDatabase, mergeChanges: true)
                
            }
        }
        else{
            print("record not exist, id:",articleId)
            self.setUpdatedArticleDetails(article: article, usingArticleDataModel: usingArticleDataModel)
            CoreDataContext.saveContext()
            
        }
        
    }
    
    
    func setUpdatedArticleDetails(article: UserArticle, usingArticleDataModel: ArticlesDataModel) {
        article.articleComments = Int32(usingArticleDataModel.comments ?? 0)
        article.articleLikes = Int32(usingArticleDataModel.likes ?? 0)
        article.articleContent = usingArticleDataModel.content
        article.articleDuration = "1 hr"
        article.articleID = Int64(usingArticleDataModel.id ?? "1") ?? 0
        if usingArticleDataModel.user?.count ?? 0 > 0 {
            let userData = usingArticleDataModel.user?[0]
            article.userName = userData?.name ?? ""
            article.userDesignation = userData?.designation ?? ""
            article.imgUrlUser = userData?.avatar ?? ""
        }
        
        if usingArticleDataModel.media?.count ?? 0 > 0 {
            let mediaData = usingArticleDataModel.media?[0]
            article.articleTitle = mediaData?.title ?? ""
            article.imgUrlArticle = mediaData?.image ?? ""
            article.articleUrl = mediaData?.url ?? ""
        }
    }
    
    func loadSavedArticlesDataOnline() -> [NSManagedObject]{
        
        let fetchRequest: NSFetchRequest<UserArticle> = UserArticle.fetchRequest()
        fetchRequest.fetchOffset = pageOffset
        fetchRequest.fetchLimit = ArticleListService.pageLimit
        do {
            
            let articlesData = try CoreDataContext.persistentContainer.viewContext.fetch(fetchRequest)
            print("Got \(articlesData.count) articles")
            self.pageOffset = self.pageOffset + 10
            self.articlesData.append(contentsOf: articlesData)
            return self.articlesData
            
        } catch {
            print("Fetch failed")
        }
        return [NSManagedObject]()
    }
    
    func loadSavedArticlesDataOffline() -> ([NSManagedObject],Bool){
        
        CustomLoader.shared.showLoader(color:AppColor.Color_NavyBlue)
        
        var isMoreResult = false
        let totalRecords = ArticleListService.shared.getArticleRecordsCount()
        
        if self.articlesData.count < totalRecords {
            if self.articlesData.count % ArticleListService.pageLimit == 0{
                isMoreResult = true
            }
            else{
                isMoreResult = false
            }
        }
        
        let fetchRequest: NSFetchRequest<UserArticle> = UserArticle.fetchRequest()
        fetchRequest.fetchOffset = pageOffset
        fetchRequest.fetchLimit = ArticleListService.pageLimit
        do {
            
            let articlesData = try CoreDataContext.persistentContainer.viewContext.fetch(fetchRequest)
            print("Got \(articlesData.count) articles")
            self.pageOffset = self.pageOffset + 10
            self.articlesData.append(contentsOf: articlesData)
            return (self.articlesData, isMoreResult)
            
        } catch {
            print("Fetch failed")
        }
        return ([NSManagedObject](), isMoreResult)
    }
    
    func getArticleRecordsCount() -> Int {
        let fetchRequest: NSFetchRequest<UserArticle> = UserArticle.fetchRequest()
        do {
            let count = try CoreDataContext.persistentContainer.viewContext.count(for: fetchRequest)
            print("Total Count:",count)
            return count
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }
    
    
    func loadArticlesDataFromStartPage() -> ([NSManagedObject] ,Bool){
        ArticleListService.shared.articlesData.removeAll()
        ArticleListService.shared.pageOffset = 0
        return self.loadSavedArticlesDataOffline()
    }
}
