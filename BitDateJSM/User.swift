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
    PFUser.query()
        .whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
        .findObjectsInBackgroundWithBlock({
            objects, error in
            if let pfUsers = objects as? [PFUser] {
                let users = map(pfUsers, {pfUsertoUser($0)})
                callback(users)
            }
            }
    )
}
