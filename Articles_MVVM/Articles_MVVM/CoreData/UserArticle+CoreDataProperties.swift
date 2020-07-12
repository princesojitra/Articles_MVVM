//
//  UserArticle+CoreDataProperties.swift
//  Articles_MVVM
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//
//

import Foundation
import CoreData


extension UserArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserArticle> {
        return NSFetchRequest<UserArticle>(entityName: "UserArticle")
    }

    @NSManaged public var articleComments: Int32
    @NSManaged public var articleContent: String?
    @NSManaged public var articleDuration: String?
    @NSManaged public var articleID: Int64
    @NSManaged public var articleLikes: Int32
    @NSManaged public var articleTitle: String?
    @NSManaged public var articleUrl: String?
    @NSManaged public var imgUrlArticle: String?
    @NSManaged public var imgUrlUser: String?
    @NSManaged public var userDesignation: String?
    @NSManaged public var userName: String?

}
