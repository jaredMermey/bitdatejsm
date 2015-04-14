//
//  CardsViewController.swift
//  BitDateJSM
//
//  Created by Jared Mermey on 3/30/15.
//  Copyright (c) 2015 Jared Mermey. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, SwipeViewDelegate {
    
    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
    }
    
    let frontCardTopMargin: CGFloat = 0.0
    let backCardTopMargin: CGFloat = 10.0
    
    @IBOutlet weak var cardStackView: UIView!
    
    //back card and front card which can be a Card struct or null. The Card struct is a struct that controlls an instance of SwipeView and CardView
    var backCard: Card?
    var frontCard: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardStackView.backgroundColor = UIColor.clearColor()
        
        //frontCard and backCard provide optical illusion of a stack of cards by having two slightly offset rectangles
        //backCard is an instance of the Card Struct
        backCard = createCard(backCardTopMargin)
        
        //add backCard's SwipeView to the CardStackView (pile of cards)
        cardStackView.addSubview(backCard!.swipeView)
        
        //frontCard is an instance of a Card Struct
        frontCard = createCard(frontCardTopMargin)
       
        //frontCard's swipe view becomes a subview of CardStackView
        cardStackView.addSubview(frontCard!.swipeView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this function creates the size and position of a rectangle. The two rectangles are used to create backCard and frontCard (i.e., the illusion of a stack of cards)
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    //helper function to create an instance of the Card Struct. This manages interplay between CardView and SwipeView by putting them in one struc called Card. This is a more dynamic way of managing these two views than what we had before refactoring which was putting an instance of CardView in SwipeView
    private func createCard(topMargin: CGFloat) -> Card {
        let cardView = CardView()
        let swipeView = SwipeView(frame: createCardFrame(topMargin))
        //sets delegate for swipeView so it can send messages to CardsViewController
        swipeView.delegate = self
        //makes cardView an innerView of swipeView
        swipeView.innerView = cardView
        //returns a card struc
        return Card(cardView: cardView, swipeView: swipeView)
    }
    
    
    //Mark: SwipeView Delegate functions
    
    func swipedLeft() {
        println("Left")
        //making sure frontCard has a value. If so, it assings instance to frontCard (one before equal sign)
        if let frontCard = frontCard {
            //front card is not a view. swipeView is a view that is a property of the frontCard instance of the Struct
            frontCard.swipeView.removeFromSuperview()
        }
    }
    
    func swipedRight() {
        println("Right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }
}
