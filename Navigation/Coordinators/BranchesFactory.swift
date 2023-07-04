
import UIKit

final class BranchesFactory {
    
    static let shared = BranchesFactory()
    private init () {}
//    private let networkService: NetworkServiceProtocol

//    init(networkService: NetworkServiceProtocol) {
//        self.networkService = networkService
//    }

    func createBranch(name branchName: Branch.BranchName) -> Branch {
        switch branchName {
        case .feed:
            let viewModel = FeedViewModel()
            let vc = FeedViewController(viewModel: viewModel)
            let view = UINavigationController(rootViewController: vc)
            return Branch(branchName: branchName, view: view, viewModel: viewModel)
        case .profile:
            let viewModel = ProfileViewModel()
            let vc = LogInViewController(viewModel: viewModel)
            
            lazy var loginInspector = MyLoginFactory.shared.makeLoginInspector() ///LogInDelegate
            vc.loginDelegate = loginInspector ///LogInDelegate

            let view = UINavigationController(rootViewController: vc)
            return Branch(branchName: branchName, view: view, viewModel: viewModel)
        }
    }
}
