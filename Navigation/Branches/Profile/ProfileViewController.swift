
import UIKit
import AVFoundation

protocol AddLikeDelegate: AnyObject {
    func addLike(_ index: IndexPath, _ from: String)
}

class ProfileViewController: UIViewController, AddLikeDelegate {

    let viewModel: ProfileViewModel
//    let coordinator: ProfileCoordinator
    private let profileHeaderView = ProfileHeaderView()
    private let profileTVCell = ProfileTableViewCell()
    private let detailedPostVC = DetailedPostViewController()
//    private let loginVC = LogInViewController()
    
//MARK: - ITEMs
   
    //MARK: bottom part of ProfileView

    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        $0.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
//MARK: - INITs
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
//        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProfileTable()
        if let user = viewModel.user {   ///после успешного входа в профиль передаем данные о пользователе из "базы данных пользователей"
            profileHeaderView.profileImage.image = user.avatar
            profileHeaderView.profileLabel.text = user.fullName
            profileHeaderView.profileStatus.text = user.status
        } else {
            profileHeaderView.profileImage.image = UIImage(named: "noname")!
            profileHeaderView.profileLabel.text = "Noname"
            profileHeaderView.profileStatus.text = "Nothing happens"
        }
        #if DEBUG
            view.backgroundColor = .systemYellow
        #else
            view.backgroundColor = .white
        #endif
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
//MARK: - METHODs
    private func showProfileTable() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func addLike(_ index: IndexPath, _ from: String) { ///vars: "Profile", "Detail"
        posts[index.row - 1].likes += 1
        switch from {
        case "Detail":  detailedPostVC.delegate = self
                        detailedPostVC.post = posts[index.row - 1]
        case "Profile": profileTVCell.delegate = self
                        profileTVCell.post = posts[index.row - 1]
        default:        print("")
        }
        tableView.reloadRows(at: [index], with: .none)
    }
}

//MARK: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as! PhotosTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
            cell.setupCell(posts[indexPath.row - 1])
            cell.index = indexPath
            cell.delegate = self
            return cell
        }
    }
}

//MARK: высота ячейки в таблице.
//Либо фиксированное значение, либо авто - UITableView.automaticDimension
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
//MARK: HEADER для таблицы !
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return profileHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //navigationController?.pushViewController(post, animated: true)

            //анимированный push-переход с эффектом fade из Photos в Photo Galery
            let photosVC = PhotosViewController(viewModel: viewModel)
            let transition = CATransition()
            transition.duration = 1.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromTop
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(photosVC, animated: false)
        } else {
            detailedPostVC.index = indexPath
            profileTVCell.index = indexPath
            detailedPostVC.delegate = self
            posts[indexPath.row - 1].views += 1
            present(detailedPostVC, animated: true)
            detailedPostVC.setupCell(posts[indexPath.row - 1])
            tableView.reloadData()
        }
    }
}
