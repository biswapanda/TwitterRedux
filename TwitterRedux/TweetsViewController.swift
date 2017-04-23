//
//  TweetsViewController.swift
//  TwitterRedux
//
//  Created by bis on 4/22/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetsTableViewCellDelegate {

    @IBOutlet weak var tweetsTableView: UITableView!
    
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
        if let userID = cell.tweet.userId {
            let navController = self.parent as! UINavigationController
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
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
