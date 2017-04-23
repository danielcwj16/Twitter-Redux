//
//  HanburgerViewController.swift
//  Twitter
//
//  Created by Weijie Chen on 4/22/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin : CGFloat!
    var viewTag : Int = 0
    var menuViewController : UIViewController!{
        didSet{
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController : UIViewController!{
        didSet(oldContentViewController){
            view.layoutIfNeeded()
//            if contentView.viewWithTag(viewTag) == nil{
//                contentViewController.view.tag = viewTag
//                contentView.addSubview(contentViewController.view)
//                
//            }else{
//                contentView.bringSubview(toFront: contentView.viewWithTag(viewTag)!)
//            }
            if oldContentViewController != nil{
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentViewController.view.tag = viewTag
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.4) { 
                 self.leftMarginConstraint.constant = 0
                 self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGuestureContentView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began{
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed{
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.ended{
            
            UIView.animate(withDuration: 0.4, animations: { 
                if velocity.x > 0{
                    self.leftMarginConstraint.constant = self.view.frame.width - 50
                }else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })

        }
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
