
import StorageService
import UIKit

//MARK: ===================================  HEADER ===================================
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
public let sizeProfileImage: CGFloat = absoluteWidth / 3

//MARK: ===================================  LOGIN  ===================================
public var dictionaryOfUsers: [String: Int] = [ ///словарь емейлов пользователей
    "11@ru.ru": 0,
    "22@ru.ru": 1,
    "33@ru.ru": 2,
    "44@ru.ru": 3,
    "55@ru.ru": 4
]

public struct Users {
    var userName: String
    var password: String
    var fullName: String
    var userImage: UIImage
    var status: String
}

public var users: [Users] = [   ///профили пользователей
    Users(userName: "11@ru.ru", password: "111111", fullName: "Obi Wan Kenobi",
          userImage: UIImage(named: "obiwan")!,
          status: "Hello, my padavan"),
    Users(userName: "22@ru.ru", password: "222222", fullName: "Darth Vader",
          userImage: UIImage(named: "darthvader")!,
          status: "Come with me, son!"),
    Users(userName: "33@ru.ru", password: "333333", fullName: "Master Yoda",
          userImage: UIImage(named: "yoda")!,
          status: "Fear is the path to the Dark side!"),
    Users(userName: "44@ru.ru", password: "444444", fullName: "Imperial trooper",
          userImage: UIImage(named: "trooper")!,
          status: "These aren't the droids we're looking for!"),
    Users(userName: "55@ru.ru", password: "", fullName: "Imperial trooper",
          userImage: UIImage(named: "trooper")!,
          status: "These aren't the droids we're looking for!"),
]

//MARK: ================================== ProfileVC ==================================
public var posts: [Post] = Post.addPosts()

//MARK: ================================== MainTabBar =================================
public var topBarHeight: CGFloat = 0

public var absoluteWidth: CGFloat {
    return  UIScreen.main.bounds.height < UIScreen.main.bounds.width ?
            UIScreen.main.bounds.height : UIScreen.main.bounds.width
}
