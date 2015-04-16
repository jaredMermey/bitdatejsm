//
//  LoginViewController.swift
//  BitDateJSM
//
//  Created by Jared Mermey on 4/13/15.
//  Copyright (c) 2015 Jared Mermey. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressedFBLogin(sender: UIButton) {
        //Facebook log-in. Grabs information about user
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            //user stops FB login
            if user == nil {
                println("Uh oh. The user cancelled the Facebook Login.")
                return
            }
            //user logging in for first time therefore creating new user
            else if user.isNew {
                println("User signed up and logged in through Facebook!")
                //call to FB Graph to get user details, returns a dictionary, then parse fields for data, set it to fields
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection, result, error in
                        var r = result as NSDictionary
                        //fields from FB Request "r" saved to user's fields
                        user["firstName"] = r["first_name"]
                        user["gender"] = r["gender"]
    
                        //date formatting
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        //get birthday from FB then format it using date formatter
                        user["birthday"] = dateFormatter.dateFromString(r["birthday"] as String)
                    
                        //get user's picture from Facebook...first gets URL from FB then turns into a request to download the image
                        let pictureUrl = ((r["picture"] as NSDictionary)["data"] as NSDictionary)["url"] as String
                        let url = NSURL(string: pictureUrl)
                        let request = NSURLRequest(URL: url!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        response, data, error in
                            //once we get image, we turn it into an image and save it
                            let imageFile = PFFile(name: "avatar.jpg", data: data)
                            user["picture"] = imageFile
                            user.saveInBackgroundWithBlock(nil)
                        })
                    }
                )
            }
            //user has logged in in the past and therefore just logging in with existing user
            else {
                println("User logged in through Facebook!")
            }
            
            //below will not run if user == nil because the "return" ends the code within the larger function. This moves user to CardsViewController
            
            //move from LoginViewController to CardsNavController
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as? UIViewController
            self.presentViewController(vc!, animated: true, completion: nil)
        })
    }
    
}
