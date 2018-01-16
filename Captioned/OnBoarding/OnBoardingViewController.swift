//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class OnboardingViewController: UIViewController {

    @IBOutlet weak var appNameLabel: UILabel!

    var isInWindowRoot = true
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        if AppEnvironment.application() == .Captioned {
            appNameLabel.text = "CAPTIONED"
        } else {
            appNameLabel.text = "FEARLESS SPIDER"
        }

        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            self.presentRootTabBar()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showSignIn" {
            let sign = segue.destination as! SignInViewController
            sign.delegate = self
            sign.isInWindowRoot = isInWindowRoot
        } else if segue.identifier == "showSignUp" {
            let sign = segue.destination as! SignUpViewController
            sign.delegate = self
            sign.user = sender as? User
            sign.isInWindowRoot = isInWindowRoot
        }
    }

    func presentRootTabBar() {

        //fillInitialUserDataIfNeeded()

        if isInWindowRoot {
            WorkflowController.presentRootTabBar(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - IBActions
    @IBAction func signUpWithFacebookPressed(sender: AnyObject) {
        if FBSDKAccessToken.current() != nil {
            //For debugging, when we want to ensure that facebook login always happens
            //FBSDKLoginManager().logOut()
            //Otherwise do:
            Alamofire.request(Captioned.Router.facebookConnect(token: FBSDKAccessToken.current().tokenString))
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .success(let JSON):
                            print("Success with JSON: \(JSON)")

                            let response = JSON as! NSDictionary

                            //example if there is an id
                            Captioned.OAuthBearerToken = response.object(forKey:"access_token") as? String
                            self.view.endEditing(true)
                            self.presentRootTabBar()
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                            self.presentBasicAlertWithTitle(title: "Username or password field is not valid")
                        }
                    }
            return
        }

        FBSDKLoginManager().logIn(withReadPermissions: self.facebookReadPermissions, from: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:Error!) -> Void in
            if error != nil {
                //According to Facebook:
                //Errors will rarely occur in the typical login flow because the login dialog
                //presented by Facebook via single sign on will guide the users to resolve any errors.
                
                // Process error
                FBSDKLoginManager().logOut()
            } else if result.isCancelled {
                // Handle cancellations
                FBSDKLoginManager().logOut()
            } else {
                print("login")
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                var allPermsGranted = true
                
                //result.grantedPermissions returns an array of _NSCFString pointers
                let grantedPermissions = result.grantedPermissions
                for permission in self.facebookReadPermissions {
                    if !(grantedPermissions?.contains(permission))! {
                        allPermsGranted = false
                        break
                    }
                }
                if allPermsGranted {
                    // Do work
                    let fbToken = result.token.tokenString
                    //                    let fbUserID = result.token.userID
                    
                    //Send fbToken and fbUserID to your web API for processing, or just hang on to that locally if needed
                    Alamofire.request(Captioned.Router.facebookConnect(token: fbToken!))
                        .validate()
                        .responseJSON { response in
                            switch response.result {
                            case .success(let JSON):
                                print("Success with JSON: \(JSON)")
                                
                                let response = JSON as! NSDictionary
                                
                                //example if there is an id
                                Captioned.OAuthBearerToken = response.object(forKey:"token") as? String
                                self.view.endEditing(true)
                                self.presentRootTabBar()
                            case .failure(let error):
                                print("Request failed with error: \(error)")
                                self.presentBasicAlertWithTitle(title: "Username or password field is not valid")
                            }
                    }
                    
                } else {
                    //The user did not grant all permissions requested
                    //Discover which permissions are granted
                    //and if you can live without the declined ones
                    
                }
            }
            })
    }

    @IBAction func signUpWithEmailPressed(sender: AnyObject) {

        performSegue(withIdentifier: "showSignUp", sender: nil)
    }

    @IBAction func signInPressed(sender: AnyObject) {

        performSegue(withIdentifier: "showSignIn", sender: nil)
    }

    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in

            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                ///
            }
        })
    }
}

extension OnboardingViewController: SignInViewControllerDelegate {
    func signInViewControllerLoggedIn() {
        presentRootTabBar()
    }
}

extension OnboardingViewController: SignUpViewControllerDelegate {
    func signUpViewControllerCreatedAccount() {
        presentRootTabBar()
    }
}
