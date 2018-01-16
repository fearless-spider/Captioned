//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import Material
import Bolts
import Alamofire

protocol SignUpViewControllerDelegate: class {
    func signUpViewControllerCreatedAccount()
}

class SignUpViewController: UIViewController, SignUpView {

    var presenter: SignUpPresenter?
    var configurator = SignUpConfiguratorImplementation()

    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var signButton: FlatButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var selectImageButton: FlatButton!
    @IBOutlet weak var backButton: UIBarButtonItem!

    var isInWindowRoot = true
    var userProfileManager = UserProfileManager()
    var user: User?
    weak var delegate: SignUpViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(signUpViewController: self)

        self.usernameTextField.textColor = Color.white
        self.emailTextField.textColor = Color.white
        self.passwordTextField.textColor = Color.white

        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        userProfileManager.initWith(controller: self, delegate: self)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - IBActions

    @IBAction func selectProfilePicturePressed(sender: AnyObject) {
        userProfileManager.selectAvatar()
    }

    @IBAction func dismissPressed(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signupPressed(sender: AnyObject) {
        var image: UIImage
        if ((self.profilePicture) == nil) {
            image = UIImage(named: "profile")!
        } else {
            image = self.profilePicture.image!
        }
        Alamofire.request(Captioned.Router.create(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, fileContents: UIImageJPEGRepresentation(image, 1.0)! as NSData))
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let JSON):
                        print("Success with JSON: \(JSON)")
                        self.presentBasicAlertWithTitle(title: "Account created successfuly")

                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        self.presentBasicAlertWithTitle(title: "Sent data are incorrect")
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

extension SignUpViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField == passwordTextField {
            signupPressed(sender: textField)
        }
        return true
    }
}

extension SignUpViewController: UserProfileManagerDelegate {

    func selectedAvatar(avatar: UIImage) {
        selectImageButton.setTitle("", for: .normal)
        profilePicture.image = avatar
    }

}
