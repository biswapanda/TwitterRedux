//
//  HamburgerViewController.swift
//  TwitterRedux
//
//  Created by bis on 4/21/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var hamburgerMenuView: UIView!
    @IBOutlet weak var hamburgurMenuLeftConstraint: NSLayoutConstraint!
    
    var kOriginalHamburgurMenuLeftConstraint :CGFloat!
    var viewControllers: [UIViewController] = []
    var viewControllersConfig: [[String: String]] = [
        ["menuText": "Profile", "viewControllerID": "TweetsNavigationViewController"],
        ["menuText": "TimeLine", "viewControllerID": "TweetsNavigationViewController"],
        ["menuText": "Mentions", "viewControllerID": "TweetsNavigationViewController"],
    ]
    
    
    var menuViewController: MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            hamburgerMenuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet {
            contentView.addSubview(contentViewController.view)
            snapHamburgerMenu(open: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        for vcConfig in viewControllersConfig {
            viewControllers.append(storyBoard.instantiateViewController(
                    withIdentifier: vcConfig["viewControllerID"]!))
        }
        TwitterClient.sharedInstance.mentions(success: { (tweets: [Tweet]) in
            let tnvc = self.viewControllers[2] as! UINavigationController
            let tvc = tnvc.topViewController as! TweetsViewController
            tvc.tweets = tweets
        }) { (error: Error?) in
            print("\(String(describing: error))")
        }
        
        TwitterClient.sharedInstance.homeTimeLine(success: { (tweets: [Tweet]) in
            let tnvc = self.viewControllers[1] as! UINavigationController
            let tvc = tnvc.topViewController as! TweetsViewController
            tvc.tweets = tweets
        }) { (error: Error?) in
            print("\(String(describing: error))")
        }
        if User.currentUser == nil {
            self.contentViewController = self.viewControllers[0] as! UINavigationController
            return
        }
        TwitterClient.sharedInstance.userTimeline(userID: User.currentUser!.userID!,
                                                  success: { (tweets: [Tweet]) in
            let tnvc = self.viewControllers[0] as! UINavigationController
            let tvc = tnvc.topViewController as! TweetsViewController
            tvc.user = User.currentUser
            tvc.tweets = tweets
            self.contentViewController = self.viewControllers[0] as! UINavigationController
                                                    
        }) { (error: Error?) in
            print("\(String(describing: error))")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func snapHamburgerMenu(open: Bool) {
        var kFinalHamburgurMenuLeftConstraint: CGFloat
        if  open {
            kFinalHamburgurMenuLeftConstraint = view.frame.size.width - 200
        } else {
            kFinalHamburgurMenuLeftConstraint = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.hamburgurMenuLeftConstraint.constant = kFinalHamburgurMenuLeftConstraint
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:
            kOriginalHamburgurMenuLeftConstraint = hamburgurMenuLeftConstraint.constant
        case .changed:
            hamburgurMenuLeftConstraint.constant = kOriginalHamburgurMenuLeftConstraint + translation.x
        case .ended:
            snapHamburgerMenu(open: sender.velocity(in: view).x > 0)
        default:
            print ("ignore pan state")
        }
    }

}
