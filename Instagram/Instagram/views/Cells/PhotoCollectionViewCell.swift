//
//  PhotoCollectionViewCell.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/13.
//

import UIKit
import SDWebImage
class PhotoCollectionViewCell: UICollectionViewCell {
    //重用标识符
    static let identifier = "PhotoCollectionViewCell"
    
    
    private let photoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        
        //アクセシビリティ対策
        accessibilityLabel = "User post image"
        accessibilityHint = "Double-tap to open post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func  configure(with model: UserPost) {
        let url = model.thumbnailImage
        photoImageView.sd_setImage(with: url, completed: nil)
    }
    
    public func configure(debug  imageName: String) {
        photoImageView.image = UIImage(named: imageName)
    }
    
    
    
}
