//
//  MenuViewController.swift
//  TwitterRedux
//
//  Created by bis on 4/21/17.
//  Copyright © 2017 biswa. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTableView: UITableView!
    var hamburgerMenuViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.dataSource = self
        menuTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell",
                                                     for: indexPath) as! MenuTableViewCell
        cell.menuLabel.text = hamburgerMenuViewController.viewControllersConfig[indexPath.row]["menuText"]
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hamburgerMenuViewController.contentViewController = hamburgerMenuViewController.viewControllers[indexPath.row]
    }
}
