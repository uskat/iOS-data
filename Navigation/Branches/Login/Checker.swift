
import UIKit

final class Checker {
    static let shared = Checker()
    
    private init() {}
    
    func check(login: String, pass: String, user: User?) -> Bool {
        if let user = user {
            return login == user.login && pass == user.password ? true : false
        } else {
            return false
        }
    }
}
