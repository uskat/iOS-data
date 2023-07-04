
import UIKit

class ProfileViewModel: ViewModelProtocol {
//    
//    enum State {
//        case initial
//        case enumerateChars
//    }
    //MARK: LoginViewModel
    var statusEntry = true
//    var isLogin: Bool = false
    
    var user: User?
    var photos = Photo.addPhotos()
    weak var coordinator: ProfileCoordinator?
    
#if DEBUG
    let userService = TestUserService.shared
#else
    let userService = CurrentUserService.shared
#endif
    
    func load(to page: Branch.BranchName.ProfileBranch) {
        coordinator?.push(to: page)
    }
}
