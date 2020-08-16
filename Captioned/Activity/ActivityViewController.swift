//
//  ActivityViewController.swift
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
import MHPrettyDate
import Material

public class ActivityViewController: UIViewController, ActivityView {
    
    var presenter: ActivityPresenter?
    var configurator = ActivityConfiguratorImplementation()

    @IBOutlet weak var tableView: UITableView!
    
    var tableData:[Activity] = []
    var selectedSegment = 0
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(activityViewController: self)
        
        let segmentedControl3 = XMSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44), segmentTitle: ["favorites", "you"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.bottomEdge)
        
        segmentedControl3.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        segmentedControl3.highlightColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        segmentedControl3.tint = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        segmentedControl3.highlightTint = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        segmentedControl3.delegate = self
        
        self.view.addSubview(segmentedControl3)
        
        self.tableView.addPullToRefresh {() -> Void in
            self.tableData.removeAll()
            self.tableView.reloadData()
            switch (self.selectedSegment) {
            case 1:
                self.fetchYouPostList().continueOnSuccessWith(block: { (task: BFTask!) -> AnyObject! in
                    if let result = task.result as? [[String: AnyObject]] {
                        print("Activity count \(result.count)")
                        for data in result {
                            let activity:Activity = Activity(JSON:data)!
                            self.tableData.append(activity)
                        }
                    }
                    self.tableView.setNeedsLayout()
                    self.tableView.layoutIfNeeded()
                    self.tableView.reloadData()
                    self.tableView.pullToRefreshView.stopAnimating()
                    return nil
                })
            default:
                self.fetchPostList().continueOnSuccessWith(block: { (task: BFTask!) -> AnyObject! in
                    if let result = task.result as? [[String: AnyObject]] {
                        print("Activity count \(result.count)")
                        for data in result {
                            let activity:Activity = Activity(JSON:data)!
                            self.tableData.append(activity)
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
        Alamofire.request(Captioned.Router.actions()).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completionSource.set(result: JSON as AnyObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionSource.set(error: NSError(domain: "when.postList", code: 1, userInfo: nil))
            }
        }
        return completionSource.task
    }
    
    func fetchYouPostList() -> BFTask<AnyObject>! {
        let completionSource = BFTaskCompletionSource<AnyObject>()
        Alamofire.request(Captioned.Router.actionYou()).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completionSource.set(result: JSON as AnyObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionSource.set(error: NSError(domain: "when.youPostList", code: 1, userInfo: nil))
            }
        }
        return completionSource.task
    }
    
}

extension ActivityViewController: UITableViewDelegate {
}

extension ActivityViewController: UITableViewDataSource {
    public func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.tableData.count
    }
    
    public func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        var cell: ActivityViewCell = self.tableView.dequeueReusableCell(withIdentifier: "activity") as! ActivityViewCell

        let activity: Activity = self.tableData[indexPath.row]
        let trimmedText: NSString = activity.content!.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines) as NSString
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
            string: activity.from().fullname(),
            attributes: nameAttributes)
        muttableString.append(nameString)
        
        let contentString = NSAttributedString(
            string: " " + (trimmedText as String) + " ",
            attributes: contentAttributes)
        muttableString.append(contentString)
        
        let dateString = NSAttributedString(
            string: MHPrettyDate.prettyDate(from: activity.postDate() as Date!, with:MHPrettyDateLongRelativeTime),
            attributes: dateAttributes)
        muttableString.append(dateString)
        
        cell.commentContentLabel.setText(muttableString)
        
        if let profilePictureURL = activity.from().profilePictureURL() {
            let placeholderImage = UIImage(named: "profile")!
            
            cell.avatarView.af_setImage(withURL: profilePictureURL as URL, placeholderImage: placeholderImage)
        }
        if activity.target_type == "post" {
            if let mediaPictureURL = activity.post().photoURL() {
                let placeholderImage = UIImage(named: "app")!
                let filter = AspectScaledToFillSizeFilter(
                    size: CGSize(width: 38.0, height: 38.0)
                )
                cell.mediaImageView.af_setImage(withURL: mediaPictureURL as URL, placeholderImage: placeholderImage, filter: filter, completion: { (response) -> Void in
                    print(response.result.value) //# UIImage
                    print(response.result.error) //# NSError
                    
                })
            }
        }
        cell.makeFavorite.isHidden = true
        cell.mediaImageView.isHidden = false
        if activity.target_type == "user" {
            if (!activity.user().followed) {
                cell.makeFavorite.isHidden = false
                cell.mediaImageView.isHidden = true
            } else {
                if let profilePictureURL = activity.user().profilePictureURL() {
                    let placeholderImage = UIImage(named: "profile")!
                    
                    cell.mediaImageView.af_setImage(withURL: profilePictureURL as URL, placeholderImage: placeholderImage)
                }
            }
        }
        cell.delegate = self
        cell.layoutIfNeeded()
        return cell
    }
}

extension ActivityViewController: XMSegmentedControlDelegate {
    public func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
        self.selectedSegment = selectedSegment
        self.tableView.triggerPullToRefresh()
    }
}

extension ActivityViewController: ActivityViewCellDelegate {
    public func didSelectAvatar(userViewCell activityViewCell: ActivityViewCell) {
        performSegue(withIdentifier: "userSegue", sender: activityViewCell)
    }
    
    public func didSelectMakeFavorite(userViewCell activityViewCell: ActivityViewCell) {
        Alamofire.request(Captioned.Router.follow(id: activityViewCell.activity.from().id!))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    //                    self.presentBasicAlertWithTitle("Favorite")
                    self.tableView.triggerPullToRefresh()
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    self.presentBasicAlertWithTitle(title: "Sent data are incorrect")
                }
        }
    }
    
    public func didSelectFavorite(userViewCell activityViewCell: ActivityViewCell) {
        Alamofire.request(Captioned.Router.unfollow(id: activityViewCell.activity.from().id!))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    //                    self.presentBasicAlertWithTitle("Liked")
                    self.tableView.triggerPullToRefresh()
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    self.presentBasicAlertWithTitle(title: "Sent data are incorrect")
                }
        }
    }
    
}

