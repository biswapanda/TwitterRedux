//
//  TweetsViewController.swift
//  TwitterRedux
//
//  Created by bis on 4/22/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetsTableViewCellDelegate {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var tweetsTableView: UITableView!
    @IBOutlet weak var totalTweetCount: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userScreenLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var user: User? = nil {
        didSet {
            view.layoutIfNeeded()
            if let user = user {
                profileView.isHidden = false
                userLabel.text = user.name
                userScreenLabel.text = user.screenName
                if let coverImageURL = user.coverImageURL {
                    coverImageView.setImageWith(URL(string: coverImageURL)!)
                }
                if let followingCount = user.followingCount {
                    followingCountLabel.text = "\(followingCount)"
                }
                if let followerCount = user.followersCount {
                    followerCountLabel.text = "\(followerCount)"
                }
                if let totalTweets = user.tweetsCount {
                    totalTweetCount.text = "\(totalTweets)"
                }
                if let profileURL = user.profileURL {
                    userProfileImage.setImageWith(profileURL)
                }
            }
            else {  
                profileView.isHidden = true
            }
        }
    }
    var tweets: [Tweet] = [] {
        didSet {
            view.layoutIfNeeded()
            tweetsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.estimatedRowHeight = 120
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TweetsTableViewCell = tweetsTableView.dequeueReusableCell(
            withIdentifier: "TweetsTableViewCell", for: indexPath) as! TweetsTableViewCell
        cell.tweet = tweets[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func onProfileImageTap(cell: TweetsTableViewCell) {
        if let userDict = cell.tweet.userDict {
            let navController = self.parent as! UINavigationController
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TweetsViewController")
                as! TweetsViewController
            let userID = userDict["id_str"] as! String
            let _user = User(userDictionary: userDict)
            vc.user = _user
            TwitterClient.sharedInstance.userTimeline(userID: userID, success: { (tweets: [Tweet]) in
                vc.tweets = tweets
            }, error: { (error:Error?) in
                print("\(error)")
            })
            navController.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
}
