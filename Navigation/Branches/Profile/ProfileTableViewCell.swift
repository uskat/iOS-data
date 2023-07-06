import StorageService
import UIKit

class ProfileTableViewCell: UITableViewCell {

//MARK: - PROPs
    var index: IndexPath?
    var post: Post?
    weak var delegate: AddLikeDelegate?
    
//MARK: - ITEMs
    private let postView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    let postName: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    let postDescription: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .systemGray
        $0.backgroundColor = .clear
        $0.isEditable = false
        $0.isScrollEnabled = false
        return $0
    }(UITextView())

    let postImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    let likes: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.isUserInteractionEnabled = true
        return $0
    }(UILabel())
    
    let views: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return $0
    }(UILabel())
    
//MARK: - INITs
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        show()
        setupLikesGestures()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - METHODs
    func show() {
        [postView, postName, postDescription, postImage, likes, views].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            postView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            postView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            postView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),

            postName.topAnchor.constraint(equalTo: postView.topAnchor, constant: 16),
            postName.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 16),
            postName.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -16),
            postName.heightAnchor.constraint(equalToConstant: 26),

            postImage.topAnchor.constraint(equalTo: postName.bottomAnchor, constant: 12),
            postImage.leadingAnchor.constraint(equalTo: postView.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: postView.trailingAnchor),
            postImage.heightAnchor.constraint(equalToConstant: absoluteWidth),

            postDescription.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 16),
            postDescription.leadingAnchor.constraint(equalTo: postName.leadingAnchor),
            postDescription.trailingAnchor.constraint(equalTo: postName.trailingAnchor),

            likes.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: 16),
            likes.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 16),
            likes.trailingAnchor.constraint(equalTo: postView.centerXAnchor, constant: 0),
            likes.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -16),
            
            views.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: 16),
            views.leadingAnchor.constraint(equalTo: postView.centerXAnchor, constant: 0),
            views.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -16),
            views.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -16)
        ])
    }

    func setupCell(_ post: Post) {
        postImage.image = post.imageName
        postName.text = post.author
        postDescription.text = post.description
        likes.text = "Likes: \(post.likes)"
        views.text = "Views: \(post.views)"
    }

    private func setupLikesGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLike))
        likes.addGestureRecognizer(tapGesture)
    }
    @objc private func tapLike (){
        if let index = index { delegate?.addLike(index, "Profile") }
        if let post = post { likes.text = "Likes: \(post.likes)" }
    }
}
