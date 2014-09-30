//
//  PhotoViewController.swift
//  Animate Facebook
//
//  Created by Jason Demetillo on 9/29/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    var imageContain: UIImage!
    var contentOffset: CGFloat!
    var ratio: Float!
    var breakPoint: CGFloat!

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneImage: UIButton!
    @IBOutlet weak var imageMenu: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.contentMode = .ScaleAspectFill
        
        imageView.image = imageContain
        
        imageView.frame = CGRect (x: 0, y:  (568 - CGFloat(320/ratio))/2, width: 320, height: CGFloat(320/ratio))
        
        println("image view frame:\(imageView.frame)")
        
        
        scrollView.frame = CGRect (x: 0, y: 0, width: 320, height: 568)
        scrollView.contentSize = CGSize(width: 320, height: 569)

        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 1)
    }

    @IBAction func onDone(sender: AnyObject) {
                dismissViewControllerAnimated(true, completion: nil)
    }
    
    func convertValue(value: Float, r1Min: Float, r1Max: Float, r2Min: Float, r2Max: Float) -> Float {
        var ratio = (r2Max - r2Min) / (r1Max - r1Min)
        return value * ratio + r2Min - r1Min * ratio
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // This method is called as the user scrolls
        println("begin scrolling")
        
        self.contentOffset = scrollView.contentOffset.y
        
        var ty = convertValue(Float(self.contentOffset), r1Min: 0, r1Max: 568/4, r2Min: 1, r2Max: 0)
        
        //negative y translation
        var Nty = convertValue(Float(self.contentOffset), r1Min: 0, r1Max: -568/4, r2Min: 1, r2Max: 0)
        
        
        println("content offset:\(contentOffset)")
        
        if (contentOffset > 0){
            self.view.backgroundColor = UIColor(white: 0, alpha: CGFloat(ty))
            
        } else if (contentOffset < 0){
            self.view.backgroundColor = UIColor(white: 0, alpha: CGFloat(Nty))
        }
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        println("begin dragging")
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.imageMenu.alpha = 0
            self.doneImage.alpha = 0
        })
        
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
        willDecelerate decelerate: Bool) {
            
            // This method is called right as the user lifts their finger
            
            self.breakPoint = 50.0
            
            // if scrolled up pass 50px
            if (contentOffset > breakPoint){
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                
            } else if (contentOffset < breakPoint && contentOffset > -breakPoint ){
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.imageMenu.alpha = 1
                    self.doneImage.alpha = 1
                })
                
            } else if (-breakPoint > contentOffset) {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                
                
            }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        // This method is called when the scrollview finally stops scrolling.
        
        self.breakPoint = 50.0
        
        // if scrolled up pass 50px
        if (contentOffset > breakPoint){
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        } else if (contentOffset < breakPoint && contentOffset > -breakPoint){
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.imageMenu.alpha = 1
                self.doneImage.alpha = 1
            })
            
        } else if (-breakPoint > contentOffset) {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            
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
