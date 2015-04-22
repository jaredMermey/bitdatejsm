//
//  User.swift
//  BitDateJSM
//
//  Created by Jared Mermey on 4/14/15.
//  Copyright (c) 2015 Jared Mermey. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    //this last field is private because only backend facing class (this class) should know about it
    private let pfUser: PFUser
   
    //Nest Function: Callback is nested in getphoto. Function to get phot for user. Done asynchrinously. Wait until we get data from Parse, assign it to data, and if data exists create a UIImage

    func getPhoto(callback:(UIImage) -> ()){
        let imageFile = pfUser.objectForKey("picture") as PFFile
        imageFile.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
    }
}

//function to turn a pfUser into a user (i.e., a backend user into a frontend user). I.e. creates a User instance by unpacking the pfUser

private func pfUsertoUser (user: PFUser) -> User {
    return User(id: user.objectId, name: user.objectForKey("firstName") as String, pfUser: user)
}


func currentUser() -> User? {
    //if the current user is a user in FB/Parse then unpack data from backend and create a front-end instance of the user struc otherwise return nothing
    if let user = PFUser.currentUser() {
        return pfUsertoUser(user)
    }
    return nil
}

//public function to call 

func fetchUnviewedUser(callback:([User])->()){
    //defaults to querying Users, therefore we need to add classname bc we are querying Actions
    PFQuery(className: "Action")
    .whereKey("byUser", equalTo: PFUser.currentUser().objectId).findObjectsInBackgroundWithBlock({
        objects, error in
        //generate array called seendIDs just toUser Ids (leaving out everything else in the dB)
        let seenIDS = map(objects, {$0.objectForKey("toUser")!})
        
        PFUser.query()
            .whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
            //we do not want to see anyone with an objectId in the seenID array...i.e, exclude them
            .whereKey("objectId", notContainedIn: seenIDS)
            .findObjectsInBackgroundWithBlock({
                objects, error in
                if let pfUsers = objects as? [PFUser] {
                    let users = map(pfUsers, {pfUsertoUser($0)})
                    callback(users)
            }
        })
    })
}

//save when a person is skipped

func saveSkip(user: User){
    //creates a new object (i.e., table) with specific attributes (i.e columns)
    let skip = PFObject(className: "Action")
    //who is the user doing the skipping
    skip.setObject(PFUser.currentUser().objectId, forKey: "byUser")
    //who is the person that is getting skipped
    skip.setObject(user.id, forKey: "toUser")
    //action type is call skipped...bc same table will keep likes
    skip.setObject("skipped", forKey: "type")
    //save
    skip.saveInBackgroundWithBlock(nil)    
}

//save when a person is liked
func saveLike(user: User){
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: user.id)
        .whereKey("toUser", equalTo: PFUser.currentUser().objectId)
        .whereKey("type", equalTo: "liked")
    //gets first object that matches above and assigns it to object
    .getFirstObjectInBackgroundWithBlock({
        object, error in
        
        var matched = false
        
        if object != nil{
            matched = true
            object.setObject("matched", forKey: "type")
            object.saveInBackgroundWithBlock(nil)
        }
        
        let match = PFObject(className: "Action")
        match.setObject(PFUser.currentUser().objectId, forKey: "byUser")
        match.setObject(user.id, forKey: "toUser")
        match.setObject(matched ? "matched" : "liked", forKey: "type")
        match.saveInBackgroundWithBlock(nil)
    })
}