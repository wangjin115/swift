//
//  UserFollowTableViewCell.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/15.
//

import UIKit
protocol UserFollowTableViewCellDelegate : AnyObject {
    func didTapFollowUnfollowButton(model: UserRelationship)
}

enum FollowState {
    case following   // 　現在のユーザーが他のユーザーをフォローしてることを示します
    case not_following  // 現在のユーザーが他のユーザーをフォローしてないことを示します
}

struct UserRelationship {
    let username: String
    let name: String
    let type: FollowState
}


class UserFollowTableViewCell: UITableViewCell {

   static let indetifier = "UserFollowTableViewCell"
    
    private var model:  UserRelationship?
    
    weak  var  delegate: UserFollowTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true   //超えた部分が切り取られる
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill   //アスペクト比を保ちつつフィルする
        return imageView
    }()
    
    private let nameLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        lable.font = .systemFont(ofSize: 17, weight: .semibold)   //サイズが１７で、太字のファント
        lable.text = "joe"
        return lable
    }()
    
    
    private let usernameLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        lable.font = .systemFont(ofSize: 16, weight: .regular)      //レギュラーサイズ
        lable.text = "@joe"
        lable.textColor = .secondaryLabel
        return lable
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link     // ボタンに視覚的な強調を加える
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true    // 領域内に限定されます
        contentView.addSubview(nameLable)
        contentView.addSubview(usernameLable)
        contentView.addSubview(profileImageView)
        contentView.addSubview(followButton)
        selectionStyle =  .none
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    @objc private func didTapFollowButton() {
        guard let model = model else {
            return
        }
        delegate?.didTapFollowUnfollowButton(model: model)
    }
    
    
    public func configure(with model: UserRelationship) {
        self.model = model
        nameLable.text = model.name
        usernameLable.text = model.username
        switch model.type {
        case .following:
            //unfollow button を展示
            followButton.setTitle("フォロー中", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        case .not_following:
           // follow button を展示
            followButton.setTitle("フォロー", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
         
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLable.text = nil
        usernameLable.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = nil
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6 , height: contentView.height - 6 )
        profileImageView.layer.cornerRadius =  profileImageView.height/2.0      //  丸くする
        
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width/3
        
        followButton.frame = CGRect(x: contentView.width - 5 - buttonWidth, y: (contentView.height - 40)/2, width: buttonWidth, height: 40)
        
        let lableHeight = contentView.height/2
        
        nameLable.frame = CGRect(x: profileImageView.right + 5, y: 0, width: contentView.width - 8 - profileImageView.width - buttonWidth, height: lableHeight)
        
        usernameLable.frame = CGRect(x: profileImageView.right + 5, y: nameLable.bottom, width: contentView.width - 8 - profileImageView.width - buttonWidth, height: lableHeight)
    }
    
}
