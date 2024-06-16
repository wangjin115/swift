//
//  FormTableViewCell.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/13.
//

import UIKit

protocol FormTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel?)
}


class FormTableViewCell: UITableViewCell , UITextFieldDelegate{
    
    
   public weak var delegate: FormTableViewCellDelegate?
    
    static let identifier = "FormTableViewCell"
    
    private var model: EditProfileFormModel?
    
    private let formLable: UILabel = {
        let lable = UILabel()
        lable.textColor = .label
        lable.numberOfLines = 1
        return lable
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLable)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
    }
       
    public func configure(with model: EditProfileFormModel ) {
        self.model = model
        formLable.text = model.lable
        field.placeholder = model.placeholder
        field.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formLable.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //フレームを定義する
        formLable.frame = CGRect(x: 5, y: 0, width: contentView.width/3, height: contentView.height)
        
        field.frame = CGRect(x: formLable.right + 5, y: 0, width: contentView.width - 10 - formLable.width , height: contentView.height)
    }
    
    
    //MARK: - Filed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true 
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
