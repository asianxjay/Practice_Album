//
//  MainViewController.swift
//  Animate Facebook
//
//  Created by Jason Demetillo on 9/29/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIScrollViewDelegate {
    
    
    var contentOffset: CGPoint!
    var onScroll: CGPoint!
    var scrollTranslate: CGFloat!
    var originalWidth: Float!
    var originalHeight: Float!
    var imageRatio: Float!
    var clickOn: UIImageView!
    var clickImageString: String!
    var tempImage: UIImageView!
    var backgroundView: UIView!
    var goPresent: Bool = true
    var window = UIApplication.sharedApplication().keyWindow
    
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gramOne: UIImageView!
    @IBOutlet weak var gramTwo: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.frame = CGRect (x: 0, y: 64, width: 320, height: 568 - 64)
        scrollView.contentSize = feedView.image!.size
        
        var tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: "onCustomTap:")
        var tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: "onCustomTap:")
        
        tapGestureRecognizer1.numberOfTapsRequired = 1;
        tapGestureRecognizer2.numberOfTapsRequired = 1;
        
        gramOne.addGestureRecognizer(tapGestureRecognizer1)
        gramTwo.addGestureRecognizer(tapGestureRecognizer2)
        
        

        // Do any additional setup after loading the view.
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        println("begin dragging")
        self.contentOffset = scrollView.contentOffset
        onScroll = contentOffset
        //println(self.oScrollP)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // This method is called as the user scrolls
        self.contentOffset = scrollView.contentOffset
        println("begin scrolling")
        
        self.scrollTranslate = self.contentOffset.y - self.onScroll.y
        
        
        //println(scrollTranslation)
        //println(self.contentOffset)
        //println(self.oScrollP)
    }
    
    
    func onCustomTap (tapGestureRecognizer: UITapGestureRecognizer) {
        var point = tapGestureRecognizer.locationInView(view)
        // User tapped at the point above. Do something with that if you want.
        //println(tapGestureRecognizer)
        
        if (tapGestureRecognizer.view == self.gramOne){
            println("grameOne")
            self.clickOn = self.gramOne
            self.clickImageString = "instagramOne"
            self.originalHeight = 640.0
            self.originalWidth = 640.0
            
        } else if (tapGestureRecognizer.view == self.gramTwo){
            println("gramTwo")
            self.clickOn = self.gramTwo
            self.clickImageString = "instagramTwo"
            println(clickOn.frame)
            
            self.originalHeight = 640.0
            self.originalWidth = 640.0
            
        }
        
        
        //self.performSegueWithIdentifier("viewPhotoSeq", sender: self)
        var window = UIApplication.sharedApplication().keyWindow
        
        //creating a temp img to duplicate the original img
        tempImage = UIImageView(frame: self.clickOn.frame)
        tempImage.image = UIImage (named: self.clickImageString)
        
        //dumping the temp image into the subview
        window.addSubview(tempImage)
        
        //getting the postion of the imgs desired absolute position
        var frame = window.convertRect(self.clickOn.frame, fromView: self.scrollView)
        
        tempImage.frame = frame
        //var ratio = tempImage.frame.size.width / tempImage.frame.size.height
        
        self.imageRatio = originalWidth/originalHeight
        var newHeight = CGFloat(320/self.imageRatio)
        var newWidth = 320
        var newY = CGFloat((568-newHeight)/2)
        
        self.tempImage.contentMode = .ScaleAspectFill
        
        self.performSegueWithIdentifier("viewPhotoSeq", sender: self)
        
        UIView.animateWithDuration(0.3, animations:
            
            { () -> Void in
                self.tempImage.frame = CGRect (x: 0, y: newY, width:320, height: newHeight)
                self.clickOn.alpha = 0
                
            })
            { (finished:Bool) -> Void in
                self.tempImage.alpha = 0
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        var destinationVC = segue.destinationViewController as PhotoViewController
        
        
        destinationVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationVC.transitioningDelegate = self
        
        println(self.clickOn)
        
        //putting the clicked img from this view controller to the next
        destinationVC.imageContain = self.tempImage.image
        destinationVC.ratio = self.imageRatio
        
        
        
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        goPresent = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        goPresent = false
        return self
    }
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.3
    }
    
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        println("animating transition")
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        if (goPresent) {
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
            }
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                fromViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    
                    self.tempImage.alpha = 1
                    self.clickOn.alpha = 1
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        var frame = self.view.convertRect(self.clickOn.frame, fromView: self.scrollView)
                        
                        self.tempImage.frame = frame
                        
                        }, completion: { (finished:Bool) -> Void in
                            self.tempImage.removeFromSuperview()
                            
                            
                            
                    })
            }
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
