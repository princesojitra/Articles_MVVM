//
//  ArticleTblCell.swift
//  Articles_MVVM
//
//  Created by Prince Sojitra on 12/07/20.
//  Copyright © 2020 Prince Sojitra. All rights reserved.
//

import UIKit

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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
