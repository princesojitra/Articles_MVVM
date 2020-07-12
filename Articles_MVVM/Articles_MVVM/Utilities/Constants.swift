//
//  Constants.swift
//  Articles_MVVM
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    //MARK: - General Constant
    static let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let mainStroyBoard =  UIStoryboard(name: "Main", bundle: nil)
    static let baseURL = "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs"
}

//MARK: - TableViewCell Identifiers
extension Constants {
    struct TblCellIdentifier {
        static let ArticleList = "ArticleTblCell"
    }
}

//MARK: - Webservcies
extension Constants {
    
    struct WebServcie {
        static let ArticleList =  baseURL
    }
}
