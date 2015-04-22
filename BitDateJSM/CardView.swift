//
//  CardView.swift
//  BitDateJSM
//
//  Created by Jared Mermey on 3/30/15.
//  Copyright (c) 2015 Jared Mermey. All rights reserved.
//

import Foundation
import UIKit

//this class builds the Card, specifically building and positioning the person's image and their name label within the Card
class CardView: UIView{

    private let imageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel()
    
    //didSet functionality allows us to immediately update the UI when we chage the value of a property 
    var name: String? {
        didSet {
            //if name exists the update name label with new name
            if let name = name {
                nameLabel.text = name
            }
        }
    }
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
        }
    }

    //initialize CardView class by taking characteristics of superclass's (UIView's) initializer then run private initializer
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    //override initializer characteristics of superclass then ride private initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    //override initializer characteristics of superclass then ride private initializer
    override init() {
        super.init()
        initialize()
    }
    
    //private intializer that we deifine here and call above so it is run no matter how user initializes this class. This code draws the view and subviews like we normally do in Storyboard.
    private func initialize(){
        
        //kills all predefined constraints from, for example, storyboard
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //set background to red
        imageView.backgroundColor = UIColor.redColor()
        //immediately adds imageView on top of CardView class
        addSubview(imageView)
        
        //logic follows image view
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(nameLabel)
        
        //CardView background to white
        backgroundColor = UIColor.whiteColor()
        //borders for our view
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        //calls the setContraints() function which defines the size/position of the imageView and nameLabel within the CardView
        setContraints()
        
    }
    
    private func setContraints(){
        //how ImageView is layed out relative to "Self" which is the CardView
        //position from top of CardView
        addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))

        //position from left of CardView
        addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
        
        //width of imageView
        addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        
        //height of imageView
        addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        //contrainst for labelView
        //top of label relative to bottom of imageview
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        //X-axis position from left of cardview for the left edge of the nameLabel
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 10))
        
        //X-axis position of right edge of nameLabel. This plus contrainst above sets width
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -10))
        
        //how far from the bottom of the CardView the bottom of the nameLabel is
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
    }
    
    
}
