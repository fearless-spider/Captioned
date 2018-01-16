//
//  FeedPostCell.swift
//  Captioned
//
//  Created by Przemysław Pająk on 22.06.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import Foundation
import Material
import AlamofireImage
import MHPrettyDate

public protocol PostViewCellDelegate: class {
    func didSelectAvatar(postViewCell: PostViewCell)
    func didSelectLike(postViewCell: PostViewCell);
    func didSelectComments(postViewCell: PostViewCell);
    func didSelectShare(postViewCell: PostViewCell);
}


public class PostViewCell: UITableViewCell {
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var postDateLabel: UILabel!
    @IBOutlet var likesCountLabel: UILabel!
    @IBOutlet var commentsCountLabel: UILabel!
    @IBOutlet var shareCountLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var mediaView: UIImageView!
    @IBOutlet var likeButton: Button!
    @IBOutlet var commentsButton: Button!
    @IBOutlet var shareButton: Button!
    @IBOutlet var commentsTableView: UITableView!
    var post: Post!
    public weak var delegate: PostViewCellDelegate?
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.post = nil
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.mediaView.clipsToBounds = true
        if let postDateLabel = postDateLabel {
            if let font = UIFont(name: "Lato-Italic.ttf", size: 10) {
                postDateLabel.font = font
            }
        }
        if let userNameLabel = userNameLabel {
            if let font = UIFont(name: "Lato-Bold.ttf", size: 15) {
                userNameLabel.font = font
            }
        }
        if let likesCountLabel = likesCountLabel {
            if let font = UIFont(name: "Lato-Bold.ttf", size: 11) {
                likesCountLabel.font = font
            }
        }
        if let commentsCountLabel = commentsCountLabel {
            if let font = UIFont(name: "Lato-Bold.ttf", size: 11) {
                commentsCountLabel.font = font
            }
        }
        if let shareCountLabel = shareCountLabel {
            if let font = UIFont(name: "Lato-Bold.ttf", size: 11) {
                shareCountLabel.font = font
            }
        }
        if let commentsTableView = commentsTableView {
            commentsTableView.register(UINib(nibName: "CommentViewCell", bundle: nil), forCellReuseIdentifier: "comment")
        }
        
        if (avatarView != nil) {
            avatarView.layer.cornerRadius = avatarView.frame.size.width / 2
            avatarView.clipsToBounds = true
        }
    }

    class func updateCellHeight(post: Post) -> CGFloat {
        return 40 * CGFloat(post.comments_count)
    }

    @IBAction func likePressed(sender: AnyObject) {
        delegate?.didSelectLike(postViewCell: self)
        likeButton.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
    }

    @IBAction func commentsPressed(sender: AnyObject) {
        delegate?.didSelectComments(postViewCell: self)
    }

    @IBAction func sharePressed(sender: AnyObject) {
        delegate?.didSelectShare(postViewCell: self)
    }
}

extension PostViewCell: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension PostViewCell: UITableViewDataSource {
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        if self.post != nil {
            return self.post.comments_count
        }
        return 0
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell = self.commentsTableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath as IndexPath) as! CommentViewCell
        let comment: Comment = self.post.comments()[indexPath.row] as! Comment
        let trimmedText: NSString = comment.content!.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines) as NSString
        //let textCheckingResults: NSMutableArray = NSMutableArray();
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        var fontBold = UIFont.boldSystemFont(ofSize: 15.0)
        if let font = UIFont(name: "Lato-Bold.ttf", size: 15.0) {
            fontBold = font
        }
        var fontRegular = UIFont.systemFont(ofSize: 15.0)
        if let font = UIFont(name: "Lato-Regular.ttf", size: 15.0) {
            fontRegular = font
        }
        let blue:UIColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        let gray:UIColor = UIColor.colorWithHex("A2A2A2")!
        let black:UIColor = UIColor.black
        
        let muttableString = NSMutableAttributedString()
        
        let nameAttributes = [NSAttributedStringKey.paragraphStyle:paragraphStyle,
                              NSAttributedStringKey.font:fontBold,
                              NSAttributedStringKey.foregroundColor:blue] as [NSAttributedStringKey : Any]
        let contentAttributes = [NSAttributedStringKey.paragraphStyle:paragraphStyle,
                                 NSAttributedStringKey.font:fontRegular,
                                 NSAttributedStringKey.foregroundColor:black] as [NSAttributedStringKey : Any]
        let dateAttributes = [NSAttributedStringKey.paragraphStyle:paragraphStyle,
                              NSAttributedStringKey.font:fontRegular,
                              NSAttributedStringKey.foregroundColor:gray] as [NSAttributedStringKey : Any]
        
        let nameString = NSAttributedString(
            string: comment.from().fullname(),
            attributes: nameAttributes)
        muttableString.append(nameString)
        
        let contentString = NSAttributedString(
            string: " " + (trimmedText as String) + " ",
            attributes: contentAttributes)
        muttableString.append(contentString)
        
        let dateString = NSAttributedString(
            string: MHPrettyDate.prettyDate(from: comment.postDate() as Date!, with:MHPrettyDateLongRelativeTime),
            attributes: dateAttributes)
        muttableString.append(dateString)
        
        cell.commentContentLabel.setText(muttableString)
        
        cell.layoutIfNeeded()

        return cell
    }
}
