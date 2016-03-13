//
//  LoginViewController.swift
//  On The Map
//
//  Created by Joseph Vallillo on 2/28/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit

//MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    //MARK: LoginState
    private enum LoginState { case Init, Idle, LoginWithUserPass, LoginWithFacebook }
    
    //MARK: Properties
    private let udacityClient = UdacityClient.sharedClient()
    private let otmDataSouce = OnTheMapDataSource.sharedDataSource()
    
    //MARK: Outlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginStackView: UIStackView!
    
    
    //MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIForState(.Init)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureUIForState(.Idle)
    }
    
    //MARK: Actions
    @IBAction func loginTapped(sender: UIButton) {
        configureUIForState(.LoginWithUserPass)
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty {
            rejectWithError(AppConstants.Errors.UserPassEmpty)
        } else {
            udacityClient.loginWithUsername(emailTextfield.text!, password: passwordTextfield.text!, completionHandler: { (userKey, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let userKey = userKey {
                        self.getStudentWithUserKey(userKey)
                    } else {
                        self.alertWithError(error!.localizedDescription)
                    }
                })
            })
        }
    }
    
    @IBAction func signUpTapped(sender: UIButton) {
        if let signUpURL = NSURL(string: UdacityClient.Common.SignUpURL) where UIApplication.sharedApplication().canOpenURL(signUpURL) {
            UIApplication.sharedApplication().openURL(signUpURL)
        }
    }
    
    //MARK: GET Student Data
    private func getStudentWithUserKey(userKey: String) {
        udacityClient.studentWithUserKey(userKey) { (student, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if let student = student {
                    self.otmDataSouce.currentStudent = student
                    self.login()
                } else {
                    self.rejectWithError(error!.localizedDescription)
                }
            }
        }
    }
    
    //MARK: Login
    private func login() {
        performSegueWithIdentifier("login", sender: self)
    }
    
    //MARK: Configure UI
    private func configureUIForState(state: LoginState) {
        func startActivityIdicatorAndFade() {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            loginButton.enabled = false
            loginStackView.alpha = 0.5
            debugTextLabel.text = ""
        }
        
        switch(state) {
        case .Init:
            let backgroundGradient = CAGradientLayer()
            backgroundGradient.colors = [AppConstants.UI.LoginColorTop, AppConstants.UI.LoginColorBottom]
            backgroundGradient.locations = [0.0, 1.0]
            backgroundGradient.frame = view.frame
            view.layer.insertSublayer(backgroundGradient, atIndex:0)
        case .Idle:
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
            loginButton.enabled = true
            loginStackView.alpha = 1.0
        case .LoginWithUserPass:
            startActivityIdicatorAndFade()
        case .LoginWithFacebook:
            startActivityIdicatorAndFade()
            emailTextfield.text = ""
            passwordTextfield.text = ""
        }
    }
    
    //MARK: Display Error
    private func alertWithError(error: String) {
        configureUIForState(.Idle)
        let alertView = UIAlertController(title: AppConstants.Alerts.LoginTitle, message: error, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: AppConstants.AlertActions.Dismiss, style: .Cancel, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func rejectWithError(error: String) {
        configureUIForState(.Idle)
        shakeUI()
        debugTextLabel.text = error
    }
    
    private func shakeUI() {
        UIView.animateWithDuration(1.0) { () -> Void in
            let loginCenter = self.loginStackView.center
            let shake = CABasicAnimation(keyPath: "position")
            shake.duration = 0.1
            shake.repeatCount = 2
            shake.autoreverses = true
            shake.fromValue = NSValue(CGPoint: CGPointMake(loginCenter.x - 5, loginCenter.y))
            shake.toValue = NSValue(CGPoint: CGPointMake(loginCenter.x + 5, loginCenter.y))
            self.loginStackView.layer.addAnimation(shake, forKey: "position")
        }
    }
    
}