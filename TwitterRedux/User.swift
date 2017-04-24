//
//  User.swift
//  TwitterRedux
//
//  Created by bis on 4/22/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var tagline: String?
    var userID: String?
    var coverImageURL: String?
    var followersCount: Int?
    var followingCount: Int?
    var tweetsCount: Int?
    
    static var _currentUser: User?
    static var currentUserKeyName = "currentUser"
    var dictionary: NSDictionary?
    
    
    init(userDictionary: NSDictionary) {
        self.dictionary = userDictionary
        userID = userDictionary["id_str"] as? String
        coverImageURL = userDictionary["profile_banner_url"] as? String
        followersCount = userDictionary["followers_count"] as? Int
        followingCount = userDictionary["friends_count"] as? Int
        tweetsCount = userDictionary["statuses_count"] as? Int
        name = userDictionary["name"] as? String
        screenName = userDictionary["screen_name"] as? String
        tagline = userDictionary["description"] as? String
        if let profileImageUrl = userDictionary["profile_image_url_https"] as? String{
            profileURL = URL(string: profileImageUrl)
        }
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let _userData = UserDefaults.standard.object(forKey: User.currentUserKeyName) as? NSData {
                    let userDict = try! JSONSerialization.jsonObject(with: _userData as Data, options: [])
                    _currentUser = User(userDictionary: userDict as! NSDictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            if let user = user {
                let userDict = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                UserDefaults.standard.set(userDict, forKey: User.currentUserKeyName)
                UserDefaults.standard.synchronize()
            }
        }
    }
}
