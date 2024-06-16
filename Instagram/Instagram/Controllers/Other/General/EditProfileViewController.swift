//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/07.
//

import UIKit

struct EditProfileFormModel {
    let lable: String
    let placeholder: String
    var value: String?
}

final class EditProfileViewController: UIViewController ,UITableViewDataSource {
    
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier )
        return tableView
    }()
    
    private var models = [[EditProfileFormModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        view.addSubview(tableView)
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(didTapSave))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(didTapCancel))
        
    }
    private func configureModels(){
        //名前、ユーザーネーム 、ウェブサイト　、自己紹介
        let section1Labels = ["名前" , "ユーザー名" , "自己紹介"]
        var section1 = [EditProfileFormModel]()
        for  lable in section1Labels {
            let model = EditProfileFormModel(lable: lable, placeholder: "\(lable)を入力してください", value: nil)
            section1.append(model)
        }
        models.append(section1)
        //イーメール　、フォーン　、ジェンダー
        let section2Labels = ["イーメール" , "フォーン" , "ジェンダー"]
        var section2 = [EditProfileFormModel]()
        for  lable in section2Labels {
            let model = EditProfileFormModel(lable: lable, placeholder: "\(lable)を入力してください", value: nil)
            section2.append(model)
        }
        models.append(section2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: TableView
    private func createTableHeaderView()  -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/4).integral)
        let size = header.height/1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width - size)/2, y: (header.height - size)/2, width: size, height: size))
      
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2.0
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        
        profilePhotoButton.setBackgroundImage(UIImage(systemName:  "person.circle"), for: .normal)
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return header
    }
    
    
    @objc private func didTapProfilePhotoButton(){
        print("クリックした")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for:  indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "個人情報"
    }
   
    //MARK:　アクション
   @objc private func didTapSave(){
       //データーベースに保存する
       dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapChangePropilePicture(){
        let actionSheet = UIAlertController(title: "プロフィール　写真", message: "Change", preferredStyle: .actionSheet)
       
        actionSheet.addAction(UIAlertAction(title: "写真を撮る", style: .default , handler: {_ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "ライブラリから選択", style: .default , handler: {_ in
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel , handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView =  view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        
        present(actionSheet,animated: true)
        
    }
    
}

extension EditProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel?) {
        // update the model
        print(updatedModel?.value ?? "nil")
       
    }
}
