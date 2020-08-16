//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import ZFDragableModalTransition
import Alamofire
import AlamofireImage
import Bolts

class SearchViewController: UIViewController, SearchView {

    var presenter: SearchPresenter?
    var configurator = SearchConfiguratorImplementation()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!

    var tableData:[Post] = []
    var selectedSegment = 0

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(searchViewController: self)

        let segmentedControl3 = XMSegmentedControl(frame: CGRect(x: 0, y: 46, width: self.view.frame.width, height: 44), segmentTitle: ["people", "trending", "competition"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.bottomEdge)

        segmentedControl3.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        segmentedControl3.highlightColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        segmentedControl3.tint = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        segmentedControl3.highlightTint = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)

        segmentedControl3.delegate = self

        self.view.addSubview(segmentedControl3)

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

        self.tableData.removeAll()
        self.collectionView.reloadData()

        switch (self.selectedSegment) {
        case 1:
            self.fetchTrendingList().continueOnSuccessWith(block: { (task: BFTask!) -> AnyObject! in
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
        case 2:
            self.fetchCompetitionList().continueOnSuccessWith(block: { (task: BFTask!) -> AnyObject! in
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
        default:
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
        }

    }

    func fetchPostList() -> BFTask<AnyObject>! {
        let completionSource = BFTaskCompletionSource<AnyObject>()
        Alamofire.request(Captioned.Router.searchList(term: self.searchTextField.text!)).validate().responseJSON { response in
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

    func fetchTrendingList() -> BFTask<AnyObject>! {
        let completionSource = BFTaskCompletionSource<AnyObject>()
        Alamofire.request(Captioned.Router.trendingList()).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completionSource.set(result: JSON as AnyObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionSource.set(error: NSError(domain: "captioned.trendingList", code: 1, userInfo: nil))
            }
        }
        return completionSource.task
    }

    func fetchCompetitionList() -> BFTask<AnyObject>! {
        let completionSource = BFTaskCompletionSource<AnyObject>()
        Alamofire.request(Captioned.Router.competitionList()).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completionSource.set(result: JSON as AnyObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionSource.set(error: NSError(domain: "captioned.competitionList", code: 1, userInfo:nil))
            }
        }
        return completionSource.task
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.tableData.removeAll()
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
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath as IndexPath) as! PostCell
        if let post: Post = self.tableData[indexPath.row] {
            if let photoURL = post.photoURL() {
                let placeholderImage = UIImage(named: "profile")!
                cell.posterImageView!.af_setImage(withURL: photoURL as URL, placeholderImage: placeholderImage)
            }
        }
        return cell
    }
}

extension SearchViewController: XMSegmentedControlDelegate {
    public func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
        self.selectedSegment = selectedSegment
        self.viewWillAppear(true)
    }
}
