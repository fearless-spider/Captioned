//
//  UserViewCell.swift
//  Captioned
//
//  Created by Przemysław Pająk on 26.06.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import UIKit
import Material

public protocol UserViewCellDelegate: class {
    func didSelectAvatar(userViewCell: UserViewCell)
    func didSelectMakeFavorite(userViewCell: UserViewCell);
    func didSelectFavorite(userViewCell: UserViewCell);
}

public class UserViewCell: UITableViewCell {
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var followButton: Button!
    @IBOutlet var unfollowButton: Button!
    var user: User!
    public weak var delegate: UserViewCellDelegate?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.user = nil
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        if let userNameLabel = userNameLabel {
            if let font = UIFont(name: "Lato-Bold.ttf", size: 15) {
                userNameLabel.font = font
            }
        }
        
        if (avatarView != nil) {
            avatarView.layer.cornerRadius = avatarView.frame.size.width / 2
            avatarView.clipsToBounds = true
        }
    }
    
    @IBAction func makeFavoritePressed(sender: AnyObject) {
        delegate?.didSelectMakeFavorite(userViewCell: self)
    }
    
    @IBAction func favoritePressed(sender: AnyObject) {
        delegate?.didSelectFavorite(userViewCell: self)
    }
}
