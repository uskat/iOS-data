
import UIKit

protocol UserService {
    func checkUser(_ login: String) -> User?
}

class User {
    var login: String
    var password: String
    var fullName: String
    var avatar: UIImage
    var status: String
    
    init(login: String = "", password: String = "", fullName: String = "", avatar: UIImage = UIImage(), status: String = "") {
        self.login = login
        self.password = password
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

public class CurrentUserService: UserService {
    var user: User?
    static let shared = CurrentUserService()
    private init () {}

    func checkUser(_ login: String) -> User? {
        if let indexOfUser = dictionaryOfUsers[login] {
            user = User(login: users[indexOfUser].userName,
                        password: users[indexOfUser].password,
                        fullName: users[indexOfUser].fullName,
                        avatar: users[indexOfUser].userImage,
                        status: users[indexOfUser].status)
            return user
        } else {
            return nil
        }
    }
}

class TestUserService: UserService {
    var user: User?
    static let shared = TestUserService()
    private init () {}

    func checkUser(_ login: String) -> User? {
        let user = User(login: users[1].userName,
                      password: users[1].password,
                      fullName: users[1].fullName,
                      avatar: users[1].userImage,
                      status: users[1].status)
        return login == users[1].userName ? user : nil
    }
}
