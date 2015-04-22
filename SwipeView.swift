//
//  SwipeView.swift
//  BitDateJSM
//
//  Created by Jared Mermey on 3/30/15.
//  Copyright (c) 2015 Jared Mermey. All rights reserved.
//

import Foundation
import UIKit

class SwipeView: UIView {
    
    enum Direction{
        case None
        case Left
        case Right
    }
    
    weak var delegate: SwipeViewDelegate?
    
    //an image view that will always get create when we initialize a swipeview instance
    let overlay: UIImageView = UIImageView()

    //variable to store direction of swiping
    var direction: Direction?
    
    var innerView: UIView? {
        didSet {
            //if innerView exists then assign the instance to the constant "C"
            if let v = innerView {
                //adds v as a subView to SwipeView
                insertSubview(v, belowSubview: overlay)
                //defines size of v
                v.frame = CGRect(x:0, y:0, width: frame.width, height: frame.height)
            }
        }
    }
    
    private var originalPoint: CGPoint?
    
    //copies functionality from UIView for Decoder initializer
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    //override the implemenatation of UIView frame initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    
    override init() {
        super.init()
        initialize()
    }
    
    //private function to customly intialize swipeview.
    private func initialize() {
        //set back to clea
        self.backgroundColor = UIColor.clearColor()
        
        //Recognized we are moving the SwipeView and calls the helper function called dragged
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
        
        //overlay should be drawn to the same size of the swipeVie
        overlay.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(overlay)
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer){
        //distance holds how far we swipe the view
        let distance = gestureRecognizer.translationInView(self)
        println("Distance x:\(distance.x) y:\(distance.y)")
        
        //function does something whether we have not yet dragged, are dragging or are done dragging as defined by the state
        switch gestureRecognizer.state{
            
            case UIGestureRecognizerState.Began:
                //figures out center of SwipeView and stores original value as originalPoint
                originalPoint = center
            
            case UIGestureRecognizerState.Changed:
            
                //provides a rotation as the card is swipe. Rotation is empirically calculated by path user drags
                let rotationPercentage = min(distance.x/self.superview!.frame.width/2,1)
                let rotationAngle = (CGFloat(2*M_PI/16)*rotationPercentage)
                transform = CGAffineTransformMakeRotation(rotationAngle)

                //changes the center for SwipeView to move as "distance" changes
                center = CGPointMake(originalPoint!.x + distance.x, originalPoint!.y + distance.y)
           
                updateOverlay(distance.x)
            
            //calls function snap back to center
            case UIGestureRecognizerState.Ended:
                
                //if they go less than a quarter of screen then reset to center becuase no real choice was made...otherwise they have made a choice
                if abs(distance.x) < frame.width/4{
                    resetViewPositionAndTransformations()
                } else {
                    //turnary operator. If x>0 pass right...otherwise pass left
                    swipe(distance.x > 0 ? .Right : .Left)
                }
                
            
        
            default:
                println("Default triggered for UIGestureRecognizer")
                break
        }
    }
    
    
    //determines direction of swipe and changes center of card?
    func swipe(s: Direction){
        
        if s == .None {
            return
        }
        var parentWidth = superview!.frame.size.width
        if s == .Left{
            parentWidth *= -1
        }
        
        
        UIView.animateWithDuration(0.2, animations:{
            self.center.x = self.frame.origin.x + parentWidth
            }, completion: {
            success in
                //if this optional exists, assign its value to "d"
                if let d = self.delegate {
                    //if s, which is the direct of swipe, is equal to right then call swipedRight() otherwise swipedLeft()
                    s == .Right ? d.swipedRight() : d.swipedLeft()
                }
        })
    }
    
    //function to make overlay stamps apper
    private func updateOverlay(distance: CGFloat) {
        
        var newDirection: Direction
        newDirection = distance < 0 ? .Left : .Right
        
        if newDirection != direction {
            direction = newDirection
            overlay.image = direction == .Right ? UIImage(named: "yeah-stamp") : UIImage(named: "nah-stamp")
        }
        overlay.alpha = abs(distance) / (superview!.frame.width/2)
    }
    
    
    //function to snap back card after drag...over 0.2 seconds it changes center back to orginalPoint
    private func resetViewPositionAndTransformations(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            //snaps back to center
            self.center = self.originalPoint!
            //changes angle of card back to 0 so it is flat
            self.transform = CGAffineTransformMakeRotation(0)
            //alpha over ovelay goes to 0 i.e.,invisbile
            self.overlay.alpha = 0
            
        })
    }
}

//protocol delgate that declares two functions
protocol SwipeViewDelegate: class {
    func swipedLeft()
    func swipedRight()
}
