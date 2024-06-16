//
//  SettingsViewController.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/07.
//

import UIKit
import SafariServices

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}
//ユーザーのセッティング
final class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            return tableView
        
    }()
    
    private var data = [[SettingCellModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func  configureModels() {
        data.append([
            SettingCellModel(title: "プロフィールを編集"){ [weak self] in
                self?.didTapEditProfile()
            },
            SettingCellModel(title: "友達をフォロー・招待する"){ [weak self] in
                self?.didTapInviteFriends()
            },
            SettingCellModel(title: "オリジナルの投稿を保存"){ [weak self] in
                self?.didTabSaveOriginalPosts()
            }
            
        ])
        
        data.append([
            SettingCellModel(title: "利用規約") { [weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellModel(title: "プライバシーポリシー") { [weak self] in
                 self?.openURL(type: .privacy)
            },
            SettingCellModel(title: "ヘルプ") { [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append([
            SettingCellModel(title: "サインアウト"){[weak self] in
                self?.didTabLogOut()
            }
        ])
        
       
    }
    enum SettingsURLType {
        case terms, privacy , help
    }
    
    private func openURL(type: SettingsURLType) {
        let urlString: String
        switch type {
        case .terms:urlString = "https://help.instagram.com/581066165581870"
        case.privacy: urlString = "https://help.instagram.com/155833707900388"
        case.help: urlString = "https://help.instagram.com/"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
        
    }
    
    private func  didTapEditProfile(){
        let vc = EditProfileViewController()
        vc.title = "プロフィールを編集"
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc,animated: true)
    }
    
    private func didTapInviteFriends(){
        //友人を招待するシートを展示する
        
    }
    
    private func didTabSaveOriginalPosts() {
        
    }
    private func didTabLogOut(){
        
        let actionSheet = UIAlertController(title: "ログアウト", message: "ログアウトですか", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "ログアウト", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: { success in
                DispatchQueue.main.async{
                    if success {
                        //ログイン画面へ
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        //error occurred
                        fatalError("Could not log out user")
                    }
                }
                
            })
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
        
   
    }

}


extension SettingsViewController:UITableViewDelegate,  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section] [indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
    
}

