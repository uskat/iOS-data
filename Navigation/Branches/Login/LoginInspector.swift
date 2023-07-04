
import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, pass: String, user: User?) -> Bool
}

class LoginInspector: LoginViewControllerDelegate {

    let checker = Checker.shared

    func check(login: String, pass: String, user: User?) -> Bool {
        checker.check(login: login, pass: pass, user: user)
    }
}
