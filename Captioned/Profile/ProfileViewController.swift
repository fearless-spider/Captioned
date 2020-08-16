//
// Created by Przemysław Pająk on 13.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import ZFDragableModalTransition
import Alamofire
import AlamofireImage
import Bolts

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate, ProfileView {
    
    var presenter: ProfilePresenter?
    var configurator = ProfileConfiguratorImplementation()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var followersButton: UIBarButtonItem!
    
    
    var tableData:[Post] = []
    var selectedSegment = 0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(profileViewController: self)
        
        let segmentedControl3 = XMSegmentedControl(frame: CGRect(x: 0, y: 128, width: self.view.frame.width, height: 46), segmentTitle: ["pictures", "tagged in"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.bottomEdge)
        
        segmentedControl3.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        segmentedControl3.highlightColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        segmentedControl3.tint = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        segmentedControl3.highlightTint = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        self.view.addSubview(segmentedControl3)
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true
        
        collectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        //        layout.itemSize = CGSize(width: 90, height: 90)
        //        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        //        collectionView!.dataSource = self
        //        collectionView!.delegate = self
        //        collectionView!.registerClass(PostCell.self, forCellWithReuseIdentifier: "postCell")
        //        collectionView!.backgroundColor = UIColor.whiteColor()
        //        self.view.addSubview(collectionView!)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.fetchProfile().continueOnSuccessWith(block: {
            (task: BFTask!) -> AnyObject! in
            self.fetchPostList().continueOnSuccessWith(block: { (task: BFTask!) -> AnyObject! in
                if let result = task.result as? [[String: AnyObject]] {
                    print("Post count \(result.count)")
                    for data in result {
                        let post:Post = Post(JSON:data)!
                        self.tableData.append(post)
                    }
                    self.collectionView.reloadData()
                }
                return nil
            })
            return nil
        })
    }
    
    func fetchPostList() -> BFTask<AnyObject>! {
        let completionSource = BFTaskCompletionSource<AnyObject>()
        Alamofire.request(Captioned.Router.userPostList(user_id:Captioned.user.id!)).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completionSource.set(result: JSON as AnyObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionSource.set(error: NSError(domain: "captioned.postList", code: 1, userInfo: nil))
            }
        }
        return completionSource.task
    }
    
    func fetchProfile() -> BFTask<AnyObject>! {
        let completionSource = BFTaskCompletionSource<AnyObject>()
        Alamofire.request(Captioned.Router.profile()).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let data = JSON as! [String: AnyObject]
                let user:User = User(JSON:data)!
                Captioned.user = user
                if let profilePictureURL = user.profilePictureURL() {
                    let placeholderImage = UIImage(named: "profile")!
                    
                    self.avatarImageView.af_setImage(withURL: profilePictureURL as URL, placeholderImage: placeholderImage)
                }
                self.nameLabel.text = user.fullname()
                self.title = user.fullname()
                self.followersCountLabel.text = String(user.followers)
                self.postsCountLabel.text = String(user.posts)
                self.favoritesCountLabel.text = String(user.favorites)
                self.headerView.setNeedsLayout()
                self.headerView.layoutIfNeeded()
                
                completionSource.set(result: JSON as AnyObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionSource.set(error: NSError(domain: "captioned.profile", code: 1, userInfo: nil))
            }
        }
        return completionSource.task
    }
    
    @IBAction func showFollowers(sender: UIBarButtonItem) {
        let followersViewController = Storyboard.followersViewController()
        navigationController?.pushViewController(followersViewController, animated: true)
    }
    
    @IBAction func showFollowersAction(sender: UITapGestureRecognizer) {
        let followersViewController = Storyboard.followersViewController()
        navigationController?.pushViewController(followersViewController, animated: true)
    }
    
    @IBAction func showFavoritesAction(sender: UITapGestureRecognizer) {
        let favoritesViewController = Storyboard.favoritesViewController()
        navigationController?.pushViewController(favoritesViewController, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        if let post: Post = self.tableData[indexPath.row] {
            if let photoURL = post.photoURL() {
                let placeholderImage = UIImage(named: "profile")!
                cell.posterImageView!.af_setImage(withURL: photoURL as URL, placeholderImage: placeholderImage)
            }
        }
        return cell
    }
}

extension SearchViewController: ModalTransitionScrollable {
    var transitionScrollView: UIScrollView? {
        return collectionView
    }
}

