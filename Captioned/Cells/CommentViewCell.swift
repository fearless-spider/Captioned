//
//  CommentViewCell.swift
//  Captioned
//
//  Created by Przemysław Pająk on 27.05.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class CommentViewCell: UITableViewCell {
    @IBOutlet var commentContentLabel: TTTAttributedLabel!
    @IBOutlet var avatarView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let commentContentLabel = commentContentLabel {
            if let font = UIFont(name: "Lato-Bold.ttf", size: 15) {
                commentContentLabel.font = font
            }
        }
        
        if (avatarView != nil) {
            avatarView.layer.cornerRadius = avatarView.frame.size.width / 2
            avatarView.clipsToBounds = true
        }
    }
}
