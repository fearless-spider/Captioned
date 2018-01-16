//
//  FavoritesViewController.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Bolts
import SVPullToRefresh
import ZFDragableModalTransition
import MHPrettyDate


public class FavoritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var tableData:[Post] = []
    var animator: ZFModalTransitionAnimator!


    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "PostViewCell", bundle: nil), forCellReuseIdentifier: "postCell")

        self.tableView.addPullToRefresh {() -> Void in
            self.tableData.removeAll()
            self.tableView.reloadData()
            self.fetchFavoritePostList().continueOnSuccessWith(block: { (task: BFTask!) -> AnyObject! in
                if let result = task.result as? [[String: AnyObject]] {
                    print("Post count \(result.count)")
                    for data in result {
                        let post:Post = Post(JSON:data)!
                        self.tableData.append(post)
                    }
                }
                self.tableView.setNeedsLayout()
                self.tableView.layoutIfNeeded()
                self.tableView.reloadData()
                self.tableView.pullToRefreshView.stopAnimating()
                return nil
            })
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.triggerPullToRefresh()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchFavoritePostList() -> BFTask<AnyObject>! {
        let completionSource = BFTaskCompletionSource<AnyObject>()
        Alamofire.request(Captioned.Router.favoriteList()).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                completionSource.set(result: json as AnyObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionSource.set(error: NSError(domain: "captioned.favoriteList", code: 1, userInfo: nil))
            }
        }
        return completionSource.task
    }

}

extension FavoritesViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 635
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension FavoritesViewController: UITableViewDataSource {

    public func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.tableData.count
    }

    public func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath as IndexPath) as! PostViewCell
        cell.delegate = self
        if let post: Post = self.tableData[indexPath.row] {
            if let profilePictureURL = post.user().profilePictureURL() {
                let placeholderImage = UIImage(named: "profile")!

                cell.avatarView.af_setImage(withURL: profilePictureURL as URL, placeholderImage: placeholderImage)
            }
            if let photoURL = post.photoURL() {
                let placeholderImage = UIImage(named: "profile")!
                cell.mediaView.af_setImage(withURL: photoURL as URL, placeholderImage: placeholderImage)
            }
            cell.likesCountLabel.text = String(post.likes_count)
            cell.commentsCountLabel.text = String(post.comments_count)
            cell.shareCountLabel.text = ""
            cell.userNameLabel.text = post.user().fullname()
            cell.postDateLabel.text = MHPrettyDate.prettyDate(from: post.postDate() as Date!, with:MHPrettyDateLongRelativeTime)
            cell.delegate = self
            cell.post = post
            var multiplier = post.comments_count
            if (multiplier! > 2) {
                multiplier = 2
            }
            let heightConstraint = NSLayoutConstraint(item: cell.commentsTableView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(multiplier!)*40)
            if (post.comments_count > 0) {
                cell.commentsTableView.addConstraint(heightConstraint)
            } else {
                cell.commentsTableView.removeConstraints(cell.commentsTableView.constraints)
            }
            cell.commentsTableView.updateConstraints()
            cell.commentsTableView.reloadData()
            cell.layoutIfNeeded()
            return cell
        }
        return cell
    }
}

extension FavoritesViewController: PostViewCellDelegate {
    public func didSelectAvatar(postViewCell: PostViewCell) {
    }

    public func didSelectComments(postViewCell: PostViewCell) {
        //let commentsViewController = Storyboard.commentsViewController()
        //let post: Post = postViewCell.post
        //commentsViewController.post = post
        //navigationController?.pushViewController(commentsViewController, animated: true)
    }

    public func didSelectShare(postViewCell: PostViewCell) {
        let textToShare = "Captioned is awesome! Check out this website about it!"

        if let myWebsite = NSURL(string: "http://www.captionedapp.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.popoverPresentationController?.sourceView = postViewCell
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    public func didSelectLike(postViewCell: PostViewCell) {
        Alamofire.request(Captioned.Router.like(id: postViewCell.post.postID()))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        self.presentBasicAlertWithTitle(title: "Liked")
                        self.tableView.triggerPullToRefresh()

                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        self.presentBasicAlertWithTitle(title: "Sent data are incorrect")
                    }
                }
    }
}
