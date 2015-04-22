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
        let user: User
    }
    
    let frontCardTopMargin: CGFloat = 0.0
    let backCardTopMargin: CGFloat = 10.0
    
    @IBOutlet weak var cardStackView: UIView!
    
    @IBOutlet weak var nahButton: UIButton!
    @IBOutlet weak var yeahButton: UIButton!
    
    
    //back card and front card which can be a Card struct or null. The Card struct is a struct that controlls an instance of SwipeView and CardView
    var backCard: Card?
    var frontCard: Card?
    
    //an array of users to eventually populate the cards
    var users: [User]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //centered image for title
        navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
        //bar button item on left
        let leftButtonBarItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToProfile:")
        navigationItem.setLeftBarButtonItem(leftButtonBarItem, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardStackView.backgroundColor = UIColor.clearColor()
        
        //changes image when nahButton is highlighted
        nahButton.setImage(UIImage(named: "nah-button-pressed"), forState: UIControlState.Highlighted)
        
        //changes image when yeahButtong is highlighted
        yeahButton.setImage(UIImage(named: "yeah-button-pressed"), forState: UIControlState.Highlighted)

        
        //changes image when yeahButton is highlighted
        
        //gets all the unviewed users from parse, which we then send to popCard function to take last one in array and pass to CreateCard function to make a card
        fetchUnviewedUser({
            returnedUsers in
            self.users = returnedUsers
            
            //test there is a card coming back from popCard as it returns an optional. if it exists, assign it to "card" then update our property called frontCard to "card"
            if let card = self.popCard(){
                self.frontCard = card
                self.cardStackView.addSubview(self.frontCard!.swipeView)
            }
            
            //test there is a second card then create it, insert it into the cardStaclView and make sure to add it below frontCard
            if let card = self.popCard(){
                self.backCard = card
                self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nahButtonPressed(sender: UIButton) {
        
        if let card = frontCard {
            //simulate swiping left
            card.swipeView.swipe(SwipeView.Direction.Left)
        }
        
    }
    
    @IBAction func yeahButtonPressed(sender: UIButton) {
        
        if let card = frontCard {
            //simulate swiping right
            card.swipeView.swipe(SwipeView.Direction.Right)
        }
    }
    
    
    
    //this function creates the size and position of a rectangle. The two rectangles are used to create backCard and frontCard (i.e., the illusion of a stack of cards)
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    //helper function to create an instance of the Card Struct. This manages interplay between CardView and SwipeView by putting them in one struc called Card. This is a more dynamic way of managing these two views than what we had before refactoring which was putting an instance of CardView in SwipeView
    private func createCard(user: User) -> Card {
        let cardView = CardView()
        cardView.name = user.name
        user.getPhoto({
            image in
            cardView.image = image
        })
        
        let swipeView = SwipeView(frame: createCardFrame(0))
        //sets delegate for swipeView so it can send messages to CardsViewController
        swipeView.delegate = self
        //makes cardView an innerView of swipeView
        swipeView.innerView = cardView
        //returns a card struc
        return Card(cardView: cardView, swipeView: swipeView, user: user)
    }
    
    //function to get new cards
    private func switchCards (){
        if let card = backCard {
            frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
        }
        if let card = self.popCard(){
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        }
    }
    
    //gives last card in users array to create card function, which will in turn create a card
    private func popCard() -> Card? {
        if users != nil && users?.count > 0 {
            return createCard(users!.removeLast())
        }
        return nil
    }
    
    
    //helper function for nav barButtonItem
    func goToProfile(button:UIBarButtonItem){
        pageController.goToPreviousVC()
    }
    
    //Mark: SwipeView Delegate functions
    
    func swipedLeft() {
        println("Left")
        //making sure frontCard has a value. If so, it assings instance to frontCard (one before equal sign)
        if let frontCard = frontCard {
            //front card is not a view. swipeView is a view that is a property of the frontCard instance of the Struct
            frontCard.swipeView.removeFromSuperview()
            saveSkip(frontCard.user)
            switchCards()
        }
    }
    
    func swipedRight() {
        println("Right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveLike(frontCard.user)
            switchCards()
        }
    }
}
