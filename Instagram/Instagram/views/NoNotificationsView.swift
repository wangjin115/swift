//
//  NoNotificationsView.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/15.
//

import UIKit

class NoNotificationsView: UIView {
     
    private let lable: UILabel = {
        let lable = UILabel()
        lable.text = "過去の通知はありません"
        lable.textColor = .secondaryLabel
        lable.textAlignment = .center
        lable.numberOfLines = 1
        return lable
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "bell")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lable)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: (width - 50)/2, y: 0, width: 50, height: 50).integral
        lable.frame = CGRect(x: 0, y: imageView.bottom, width: width, height: height - 50).integral
    }

}
