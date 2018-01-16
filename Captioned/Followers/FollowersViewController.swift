//
//  FollowersViewController.swift
//  Captioned
//
//  Created by Przemysław Pająk on 08.01.2018.
//  Copyright © 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import SVPullToRefresh
import MHPrettyDate

public class FollowersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var tableData:[User] = []

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.addPullToRefresh {() -> Void in
            self.tableData.removeAll()
            self.tableView.reloadData()
            self.fetchPostList().continueOnSuccessWith(block: { (task: BFTask!) -> AnyObject! in
                if let result = task.result as? [[String: AnyObject]] {
                    print("User count \(result.count)")
                    for data in result {
                        let user:User = User(JSON:data)!
                        self.tableData.append(user)
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

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.triggerPullToRefresh()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchPostList() -> BFTask<AnyObject>! {
        let completionSource = BFTaskCompletionSource<AnyObject>()
        Alamofire.request(Captioned.Router.users()).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completionSource.set(result: JSON as AnyObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionSource.set(error: NSError(domain: "when.users", code: 1, userInfo: nil))
            }
        }
        return completionSource.task
    }

}

extension FollowersViewController: UITableViewDelegate {
}

extension FollowersViewController: UITableViewDataSource {
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.tableData.count
    }

    public func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell: UserViewCell = self.tableView.dequeueReusableCell(withIdentifier: "user") as! UserViewCell
        let user: User = self.tableData[indexPath.row]
        cell.userNameLabel.text = user.fullname()
        if let profilePictureURL = user.profilePictureURL() {
            let placeholderImage = UIImage(named: "profile")!

            cell.avatarView.af_setImage(withURL: profilePictureURL as URL, placeholderImage: placeholderImage)
        }
        cell.followButton.isHidden = user.followed
        cell.delegate = self
        cell.user = user
        return cell
    }
}

extension FollowersViewController: UserViewCellDelegate {
    public func didSelectAvatar(userViewCell: UserViewCell) {
        performSegue(withIdentifier: "userSegue", sender: userViewCell)
    }

    public func didSelectMakeFavorite(userViewCell: UserViewCell) {
        Alamofire.request(Captioned.Router.follow(id: userViewCell.user.id!))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        self.tableView.triggerPullToRefresh()

                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        self.presentBasicAlertWithTitle(title: "Sent data are incorrect")
                    }
                }
    }

    public func didSelectFavorite(userViewCell: UserViewCell) {
        Alamofire.request(Captioned.Router.unfollow(id: userViewCell.user.id!))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        self.tableView.triggerPullToRefresh()

                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        self.presentBasicAlertWithTitle(title: "Sent data are incorrect")
                    }
                }
    }

}
