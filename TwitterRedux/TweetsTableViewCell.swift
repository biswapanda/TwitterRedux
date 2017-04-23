//
//  TweetsTableViewCell.swift
//  TwitterRedux
//
//  Created by bis on 4/22/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit


protocol TweetsTableViewCellDelegate: class  {
    func onProfileImageTap(cell: TweetsTableViewCell) -> ()
}


class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorScreenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var delegate: TweetsTableViewCellDelegate?
    
    @IBAction func onProfileImageTap(_ sender: UIButton) {
        delegate?.onProfileImageTap(cell: self)
    }
    
    weak var tweet: Tweet! {
        didSet {
            tweetLabel.text = tweet.text
            authorNameLabel.text = tweet.authorName
            authorScreenNameLabel.text = tweet.authorScreenName
            if let timestamp = tweet.timestamp {
                let df = DateFormatter()
                df.dateFormat = "hh"
                createdTimeLabel.text = "\(df.string(from: timestamp)) h"
            }
            if let profileImageURL = tweet.authorProfileURL {
                profileImageView.setImageWith(profileImageURL)
            }
            retweetCountLabel.text = "0"
            if let retweetCount = tweet.retweetCount {
                if retweetCount > 0 {
                    retweetCountLabel.text = "\(retweetCount)"
                }
            }
            favoriteCountLabel.text = "0"
            if let favoriteCount = tweet.favoriteCount {
                if favoriteCount > 0 {
                    favoriteCountLabel.text = "\(favoriteCount)"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
