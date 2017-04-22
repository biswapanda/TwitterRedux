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
    
    var menuViewController: MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            hamburgerMenuView.addSubview(menuViewController.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:
            kOriginalHamburgurMenuLeftConstraint = hamburgurMenuLeftConstraint.constant
        case .changed:
            hamburgurMenuLeftConstraint.constant = kOriginalHamburgurMenuLeftConstraint + translation.x
        case .ended:
            var kFinalHamburgurMenuLeftConstraint: CGFloat
            if sender.velocity(in: view).x > 0 {
                kFinalHamburgurMenuLeftConstraint = view.frame.size.width - 100
            } else {
                kFinalHamburgurMenuLeftConstraint = 0
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.hamburgurMenuLeftConstraint.constant = kFinalHamburgurMenuLeftConstraint
                self.view.layoutIfNeeded()
            })
        default:
            print ("ignore pan state")
        }
    }

}
