//
//  ArticleTblCell.swift
//  Articles_MVVM
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTblCell: UITableViewCell {

    
    @IBOutlet weak var lblArticleTitle: UILabel!
    @IBOutlet weak var lblArticleDuration: UILabel!
    @IBOutlet weak var lblArticleComments: UILabel!
    @IBOutlet weak var lblArticleLikes: UILabel!
    @IBOutlet weak var lblArticleUrl: UILabel!
    @IBOutlet weak var lblArticleContent: UILabel!
    @IBOutlet weak var imgVwArticle: UIImageView!
    @IBOutlet weak var lblUserDesignation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var constHeightImgArticle: NSLayoutConstraint!
    
    //set viewmodel data
    var articleViewModel :ArticlesViewModel!{
        didSet{
            self.lblUserName.text = articleViewModel.userName
            self.lblUserDesignation.text = articleViewModel.userDesignation
            self.imgVwUser.setImageWith(urlString: articleViewModel.imgUrlUser, placeholder: nil, imageIndicator: .gray, completion: nil)
            self.lblArticleDuration.text = articleViewModel.articleDuration
            self.lblArticleTitle.text = articleViewModel.articleTitle
            self.lblArticleContent.text = articleViewModel.articleContent
            self.lblArticleUrl.text = articleViewModel.articleUrl
            self.lblArticleLikes.text = articleViewModel.articleLikes
            self.lblArticleComments.text = articleViewModel.articleComments
            self.imgVwUser.layer.cornerRadius = 30
            if articleViewModel.imgUrlArticle.isEmpty {
                //no article image to show
                self.constHeightImgArticle.constant = 0
            }
            else{
                //show article image
                self.constHeightImgArticle.constant = 130.0
                self.imgVwArticle.setImageWith(urlString: articleViewModel.imgUrlArticle, placeholder: nil, imageIndicator: .gray, completion: nil)
              
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
