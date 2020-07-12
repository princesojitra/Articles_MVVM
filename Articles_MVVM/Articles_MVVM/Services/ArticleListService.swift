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
    var currentPage = 1
    var pageOffset = 0
    var isMoreResult = false
    
    func fetchArticles(isFromFirstPage:Bool,isShowLoader:Bool,completion: @escaping (Error?,Bool) -> ()) {
        
        //check loader to show
        if isShowLoader {
        CustomLoader.shared.showLoader(color:AppColor.Color_NavyBlue)
        }
        
        //check start page to load
        if isFromFirstPage {
            self.currentPage = 1
            self.pageOffset = 0
        }
        
        let urlString = Constants.WebServcie.ArticleList + "?page=" + "\(currentPage)" + "&limit=" + "\(ArticleListService.pageLimit)"
        
        guard let url = URL(string: urlString) else { return }
        
        print("******* API Log ******")
        print("URL : ", urlString )
        print("Method : ", "Get")
        print("Params :")
        print("Headers :")
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                
                //check loader to hide
                if isShowLoader {
                  CustomLoader.shared.hideLoader()
                }
                
                print("Failed to fetch courses:", err)
                print("******* API Log ******")
                completion(err, false)
            }
            
            // check response
            guard let data = data else { return }
            do {
                let articles = try JSONDecoder().decode([ArticlesDataModel].self, from: data)
                print("Response:",articles )
                
                DispatchQueue.main.async {
                
                    //check more pages available to load
                    if articles.count == ArticleListService.pageLimit {
                        self.isMoreResult = true
                        self.currentPage = self.currentPage + 1
                    }else{
                        self.isMoreResult = false
                    }
                    
                    //check loader to hide
                    if isShowLoader {
                      CustomLoader.shared.hideLoader()
                    }
                    print("******* API Log ******")
                    completion(nil, self.isMoreResult)
                }
            } catch let jsonErr {
                //check loader to hide
                if isShowLoader {
                  CustomLoader.shared.hideLoader()
                }
                print("Failed to decode:", jsonErr)
                print("******* API Log ******")
            }
        }.resume()
    }
}
