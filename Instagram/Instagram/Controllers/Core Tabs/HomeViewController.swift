//
//  ViewController.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/07.
//

import FirebaseAuth
import UIKit


struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel   //ポストの上の部分、ユーザー情報が表示されます
    let post: PostRenderViewModel     //本文、画像とか動画
    let actions: PostRenderViewModel   //「いいね」「コメント」「シェア」っていうボタン
    let comments: PostRenderViewModel   //いいね数とかコメント分
}
class HomeViewController: UIViewController {
    
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModels()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    private func createMockModels(){
        let user = User(username: "@james", bio: "", name: ("", ""), profilePhoto: URL(string: "https://www.google.com")!, birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://www.google.com/")!,
                            postURL: URL(string: "https://www.google.com/")!,
                            caption: nil, likeCount: [], comments: [], createdDate: Date(), taggedUsers: [], owner: user)
      var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(PostComment(identifier: "\(x)", username: "@jenny", text: "This is the best post I've seen", createdDate: Date(), likes:  []))
        }
        
        for x in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)), post: PostRenderViewModel(renderType: .primaryContent(provider: post)), actions: PostRenderViewModel(renderType: .actions(provider: "")), comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            
            feedRenderModels.append(viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
        //未確認の場合の処理を実行
        handleNotAuthenticated()
       
        
    }
     
    private func handleNotAuthenticated(){
        //確認のステータスを確認
        if Auth.auth().currentUser == nil {
            //ログイン画面を表示
            let loginVc = LoginViewController()
            loginVc.modalPresentationStyle = .fullScreen
            present(loginVc, animated: false)
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
     
    //ポストごとに四つのセッションが含まれています。
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    //セッションべつに行数を決めます
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        // １番目のポスト
        if x == 0 {
             model = feedRenderModels[0]
        }
        //他のセッションはどのポストにあるか推定する
        else{
            let position = x % 4 == 0 ? x / 4 : ((x - (x % 4)) / 4)
             model = feedRenderModels[position]
        }
        //ポストの中のどの部分を確認する
        let subSection = x % 4
        
        //部分べつに行数をリターンする
        if subSection == 0 {
            //header
            return 1
        }
        
        if subSection == 1 {
            //post
            return 1
        }
        
        if subSection == 2 {
            //actions
            return 1
        }
        
        if subSection == 3 {
            //comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return  comments.count > 2 ? 2 : comments.count
            case .header, .actions , .primaryContent: return 0
            }
        }
        return 0
    }
    
    
    //サブセッションべつにセルを作る
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x = indexPath.section   //cellはどのセッションにあるか計算する
        let model: HomeFeedRenderViewModel
        if x == 0 {
             model = feedRenderModels[0]
        }
        else{
            let position = x % 4 == 0 ? x / 4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        let subSection = x % 4
        
        if subSection == 0 {
            //header
           
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier,for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return  cell
            case .comments, .actions , .primaryContent: return UITableViewCell()
            }
        }
        
        if subSection == 1 {
            //post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,for: indexPath) as! IGFeedPostTableViewCell
              
                cell.configure(with: post)
                return  cell
            case .comments, .actions , .header: return UITableViewCell()
            }
        }
        
        if subSection == 2 {
            //actions
            
            switch  model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier,for: indexPath) as! IGFeedPostActionsTableViewCell
                cell.delegate = self
                return  cell
            case .comments, .header , .primaryContent: return UITableViewCell()  // 空のセルをリターン
            }
        }
        
        if subSection == 3 {
           
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier,for: indexPath) as! IGFeedPostGeneralTableViewCell
                return  cell
            case .header, .actions , .primaryContent: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    //　かくサブセッションの高さを決める
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let subSection = indexPath.section % 4
        if subSection == 0{
            //Header
            return 70
        }
        else if subSection == 1 {
            //Post
            return tableView.width
        }
        
        else if subSection == 2 {
            //Action(like/comment)
            return 60
        }
        else if subSection == 3{
            //Commontt row
            return 50
        }
        
            return 0
      
        }
    
    // ポストごとに区切り線をつける
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //まず、サブセッションは３即ちコメントの部分かを判断し、viewForFooterInSection方法によって、各ポストの間の間隔を作る
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
    }

extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
          //
        let actionSheet = UIAlertController(title: "ポスト　オプション", message: nil, preferredStyle: .actionSheet)
        
        //style: .destructive 警告式
        actionSheet.addAction(UIAlertAction(title: "報告する", style: .destructive, handler: {[weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(actionSheet,animated: true)
    }
    
    func reportPost() {
        
    }
    
}

extension HomeViewController: IGFeedPostActionsTableViewCellDelegate{
    func didTapLikeButton() {
        print("like")
    }
    
    func didTapCommentButton() {
        print("comment")
    }
    
    func didTapSendButton() {
        print("send")
    }
    
    
}
