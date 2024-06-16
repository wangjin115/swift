//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/14.
//

import UIKit
protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

final class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
     static let identifier = "profileInfoHeaderCollectionReusableView"
      
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("投稿", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor  = .secondarySystemBackground
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("フォロワー", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor  = .secondarySystemBackground
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("フォロー中", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor  = .secondarySystemBackground
        return button
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("プロフィールを編集", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor  = .secondarySystemBackground
        return button
    }()
    
    private let nameLable: UILabel = {
        let lable  = UILabel()
        lable.text = "岸田文雄"
        lable.textColor = .label
        lable.numberOfLines = 1
        return lable
    }()
    
    private let bioLable: UILabel = {
        let lable  = UILabel()
        lable.text = "第101代内閣総理大臣/第27代自民党総裁"
        lable.textColor = .label
        lable.numberOfLines = 0        // 自動改行
        return lable
    }()
    
    
     //MARK: - イニシャライザ
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtonActions()
        addSubviews()
        backgroundColor = .systemBackground
        clipsToBounds = true
    }
    
    private func  addSubviews(){
        addSubview(profilePhotoImageView)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(postButton)
        addSubview(bioLable)
        addSubview(nameLable)
        addSubview(editProfileButton)
    }
    private func addButtonActions(){
        followersButton.addTarget(self, action: #selector(didTapFollowerButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = width/4
        
        profilePhotoImageView.frame = CGRect(
            x: 5, y: 5, width: profilePhotoSize, height: profilePhotoSize
        ).integral
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        let buttonHeight = profilePhotoSize/2
        let countButtonWidth = (width - 10 - profilePhotoSize)/3
        
        postButton.frame = CGRect(
            x: profilePhotoImageView.right, y: 5, width: countButtonWidth, height: buttonHeight
        ).integral
        
        followersButton.frame = CGRect(
            x: postButton.right, y: 5, width: countButtonWidth, height: buttonHeight
        ).integral
        
        followingButton.frame = CGRect(
            x: followersButton.right, y: 5, width: countButtonWidth, height: buttonHeight
        ).integral
        
        editProfileButton.frame = CGRect(
            x: profilePhotoImageView.right, y: 5 + buttonHeight, width: countButtonWidth * 3, height: buttonHeight
        ).integral
        
        nameLable.frame = CGRect(
            x: 5, y: 5 + profilePhotoImageView.bottom, width: width - 10, height: 50
        ).integral
        
        let bioLableSize = bioLable.sizeThatFits(frame.size)
        bioLable.frame = CGRect(
            x: 5, y: 5 + nameLable.bottom, width: width - 10, height: bioLableSize.height
        ).integral
        
    }
    
    //MARK: - アクション
    
    @objc private func didTapFollowerButton(){
        delegate?.profileHeaderDidTapFollowersButton(self)
    }
    
    @objc private func didTapFollowingButton(){
        delegate?.profileHeaderDidTapFollowingButton(self)
    }
    
    @objc private func didTapPostsButton(){
        delegate?.profileHeaderDidTapPostsButton(self)
    }
    
    @objc private func didTapEditProfileButton(){
        delegate?.profileHeaderDidTapEditProfileButton(self)
    }
}
