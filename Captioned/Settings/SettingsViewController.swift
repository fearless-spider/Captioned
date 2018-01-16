//
// Created by Przemysław Pająk on 13.01.2018.
// Copyright (c) 2018 FEARLESS SPIDER. All rights reserved.
//

import UIKit
import Bolts

let DefaultLoadingScreen = "Defaults.InitialLoadingScreen";

class SettingsViewController: UITableViewController {

    @IBOutlet weak var loginLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLoginButton()
    }

    func updateLoginButton() {
        let whenApp = AppEnvironment.application().rawValue
        if Captioned.currentUserLoggedIn() {
            // Logged In both
            loginLabel.text = "Logout \(whenApp)"
        }
    }

    // MARK: - IBActions

    @IBAction func dismissPressed(sender: AnyObject) {

        dismiss(animated: true, completion: nil)
    }

    // MARK: - TableView functions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath as IndexPath) else {
            return
        }

        switch (indexPath.section, indexPath.row) {
        case (0,0):
            // Login / Logout
            if Captioned.currentUserLoggedIn() {
                // Logged In both, logout
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                alert.popoverPresentationController?.sourceView = cell.superview
                alert.popoverPresentationController?.sourceRect = cell.frame
                let whenApp = AppEnvironment.application().rawValue
                alert.addAction(UIAlertAction(title: "Logout \(whenApp)", style: UIAlertActionStyle.destructive, handler: { (action) -> Void in

                    WorkflowController.logoutUser().continueOnSuccessWith( executor: BFExecutor.mainThread(), block: { (task: BFTask!) -> AnyObject! in

                        if let error = task.error {
                            print("failed loggin out: \(error)")
                        } else {
                            print("logout succeeded")
                        }
                        WorkflowController.presentOnboardingController(asRoot: true)
                        return nil
                    })
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                }))

                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }


    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 0:
            return nil
        case 1:
            return "If you're looking for support drop us a message on Facebook or Twitter"
        case 2:
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
            let whenApp = AppEnvironment.application().rawValue
            return "Created by FEARLESS SPIDER, enjoy!\n\(whenApp) \(version) (\(build))"
        default:
            return nil
        }
    }
}

extension SettingsViewController: ModalTransitionScrollable {
    var transitionScrollView: UIScrollView? {
        return tableView
    }
}
