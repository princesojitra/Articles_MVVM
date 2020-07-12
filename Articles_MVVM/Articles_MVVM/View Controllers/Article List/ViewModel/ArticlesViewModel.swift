//
//  ArticlesViewModel.swift
//  Articles_MVVM
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ArticlesViewModel {
    
    let artiCleData:UserArticle
    
    var userName: String {
        return self.artiCleData.userName ?? ""
    }
    
    var userDesignation: String {
        return self.artiCleData.userDesignation ?? ""
    }
    
    var imgUrlUser: String {
        return self.artiCleData.imgUrlUser ?? ""
    }
    
    var articleDuration: String {
        return self.artiCleData.articleDuration ?? ""
    }
    
    var articleTitle: String {
        return self.artiCleData.articleTitle ?? ""
    }
    
    var articleContent: String {
        return self.artiCleData.articleContent ?? ""
    }
    
    var articleUrl: String {
        return self.artiCleData.articleUrl ?? ""
    }
    
    var imgUrlArticle: String {
        return self.artiCleData.imgUrlArticle ?? ""
    }
    
    var articleLikes: String {
        return self.formatPoints(from: Int(self.artiCleData.articleLikes ))
    }
    var articleComments: String {
        return self.formatPoints(from: Int(self.artiCleData.articleComments))
    }
    
    init(article: UserArticle) {
        self.artiCleData = article
    }
    
    //format numbers
    func formatPoints(from: Int) -> String {
        let number = Double(from)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        } else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        } else if billion >= 1.0 {
            return ("\(round(billion*10/10))B")
        } else {
            return "\(Int(number))"}
    }
}
