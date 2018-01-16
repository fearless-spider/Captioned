//
//  ActivityViewCell.swift
//  Captioned
//
//  Created by Przemysław Pająk on 06.07.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import Material

public protocol ActivityViewCellDelegate: class {
    func didSelectAvatar(userViewCell: ActivityViewCell)
    func didSelectMakeFavorite(userViewCell: ActivityViewCell);
    func didSelectFavorite(userViewCell: ActivityViewCell);
}

public class ActivityViewCell: UITableViewCell {
    @IBOutlet var commentContentLabel: TTTAttributedLabel!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var mediaImageView: UIImageView!
    @IBOutlet var makeFavorite: Button!
    
    var activity: Activity!
    
    public weak var delegate: ActivityViewCellDelegate?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        if (avatarView != nil) {
            avatarView.layer.cornerRadius = avatarView.frame.size.width / 2
            avatarView.clipsToBounds = true
        }
    }

    @IBAction func favoritePressed(sender: AnyObject) {
        delegate?.didSelectFavorite(userViewCell: self)
    }

    @IBAction func makeFavoritePressed(sender: AnyObject) {
        delegate?.didSelectMakeFavorite(userViewCell: self)
    }
}
