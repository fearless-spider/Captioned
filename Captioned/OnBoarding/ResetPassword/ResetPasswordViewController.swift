//
// Created by Przemysław Pająk on 14.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import Material
import Alamofire

class ResetPasswordViewController: UIViewController, ResetPasswordView {

    var presenter: ResetPasswordPresenter?
    var configurator = ResetPasswordConfiguratorImplementation()

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(resetPasswordViewController: self)

        self.emailTextField.textColor = Color.white

        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }

    @IBAction func resetPressed(sender: AnyObject) {

        emailTextField.trimSpaces()
        if emailTextField.validEmail() {
            Alamofire.request(Captioned.Router.resetPassword(email: emailTextField.text!))
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .success( _):
                            self.view.endEditing(true)
                            self.presentBasicAlertWithTitle(title: "Email with password has been sent.")
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                            self.presentBasicAlertWithTitle(title: "Sent data are incorrect")
                        }
                    }
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }

    @IBAction func dismissPressed(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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

extension ResetPasswordViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

