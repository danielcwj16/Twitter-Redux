//
//  MenuViewController.swift
//  Twitter
//
//  Created by Weijie Chen on 4/22/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menuView: UITableView!
    
    private var profileNavigationController : UIViewController!
    private var timelineNavigationController : UIViewController!
    private var mentionsNavigationController : UIViewController!
    
    var viewControllers : [UIViewController] = []
    var hamburgerViewController : HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.delegate = self
        menuView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "profileNavigationController")
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "timelineNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "mentionsNavigationController")
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        hamburgerViewController.contentViewController = profileNavigationController

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let titles = ["Profile","Timeline","Mentions"]
        
        cell.manuItemText = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.hamburgerViewController.viewTag = indexPath.row+1
        self.hamburgerViewController.contentViewController  = viewControllers[indexPath.row]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
