//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Material
import Alamofire

protocol SignInViewControllerDelegate: class {
    func signInViewControllerLoggedIn()
}

class SignInViewController: UIViewController, SignInView {

    var presenter: SignInPresenter?
    var configurator = SignInConfiguratorImplementation()


    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var signButton: FlatButton!
    @IBOutlet weak var forgotPasswordButton: FlatButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!

    var isInWindowRoot = true
    weak var delegate: SignInViewControllerDelegate?
    var userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(signInViewController: self)

        self.usernameTextField.textColor = Color.white
        self.passwordTextField.textColor = Color.white

        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        if ((self.userDefaults.object(forKey: "password")) != nil && (self.userDefaults.object(forKey: "username")) != nil) {
            self.passwordTextField.text = self.userDefaults.object(forKey: "password") as? String
            self.usernameTextField.text = self.userDefaults.object(forKey: "username") as? String
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);

    }

    // MARK: - IBActions

    @IBAction func dismissPressed(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signInPressed(sender: AnyObject) {
        usernameTextField.trimSpaces()

        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            presentBasicAlertWithTitle(title: "Username or password field is empty")
            return
        }
        self.userDefaults.setValue(password, forKey: "password")
        self.userDefaults.setValue(username, forKey: "username")
        self.userDefaults.synchronize()
        Alamofire.request(Captioned.Router.token(username: username, password: password))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")

                        let response = JSON as! NSDictionary

                        //example if there is an id
                        Captioned.OAuthToken = response.object(forKey: "token") as? String
                        self.view.endEditing(true)
                        self.dismiss(animated: true, completion: { () -> Void in
                            self.delegate?.signInViewControllerLoggedIn()
                        })
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        self.presentBasicAlertWithTitle(title: "Username or password field is not valid")
                    }
                }
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }

    deinit {
        NotificationCenter.default.removeObserver(self);
    }
}

extension SignInViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField == passwordTextField {
            signInPressed(sender: textField)
        }
        return true
    }
}

