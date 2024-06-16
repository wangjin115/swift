//
//  ExploreViewController.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/07.
//

import UIKit

class ExploreViewController: UIViewController {

    //　　サーチバーを定義する
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "検索"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var models = [UserPost]()
    
    
    private var collectionView: UICollectionView?
    
    private var  tabbedSearchCollectionView: UICollectionView?
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchbar()
        
        configureExploreCollection()
        configureDimmedView()
    }
    private func configureTabbedSearch(){
         let layout = UICollectionViewFlowLayout()
         layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
         tabbedSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabbedSearchCollectionView?.backgroundColor = .yellow
         tabbedSearchCollectionView?.isHidden = false
        
        //もし　tabbedSearchCollectionView　がnilでない場合、以下の処理を実行します
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        //このCollectionViewをビューに管理される
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        view.addSubview(tabbedSearchCollectionView)
    }
    
    
    //サーチバー現れた時　下はグレーになる
    private func configureDimmedView(){
        view.addSubview(dimmedView)  //主要なビューに入れる
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))   // ジェスチャーの設定
        gesture.numberOfTapsRequired = 1     //クリックの回数
        gesture.numberOfTouchesRequired = 1   //タッチの本数
        dimmedView.addGestureRecognizer(gesture)  //dimmedViewにジェスチャーを追加
    }
    
    //サーチバーを設定する
    private func configureSearchbar(){
        navigationController?.navigationBar.topItem?.titleView = searchBar  // ナビゲーションのタイトルビューを中央に設置します
        searchBar.delegate = self
    }
    
    private func configureExploreCollection(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)   //各セクションnの内部余白を設定します。
        layout.itemSize = CGSize(width: (view.width - 4)/3, height: (view.width - 4) / 3 )   //各アイテムのサイズを設定する
        layout.minimumLineSpacing = 1    // 各行の最小の間隔
        layout.minimumInteritemSpacing = 1  //各列の最小間隔
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
         
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView  = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame  = view.bounds
        dimmedView.frame = view.bounds
        tabbedSearchCollectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 72)
    }

}

//サーチボタン押したら、メソッドが呼び出されます
extension ExploreViewController: UISearchBarDelegate {
    
    //サーチボタン押したら
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //前のサーチ状態を非表示にする
        didCancelSearch()
        //テキストを確認する
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        //バックエンドでサーチ
        query(text)
    }
    
    //入力中の際
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //キャンセルボタンを表示する
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(didCancelSearch))
       //バックカラーをグレイにする
        dimmedView.isHidden = false
        //入力済み
        //アニメーション：DimmedViewをゆっくり非表示にする
        UIView.animate(withDuration: 0.2 , animations: {
            self.dimmedView.alpha = 0.4
        }){done in
            if done {
                self.tabbedSearchCollectionView?.isHidden = false
            }
            }
    }
    
    
    @objc private func didCancelSearch(){
        //キーボードを非表示にする
        searchBar.resignFirstResponder()
        //キャンセルボタンを削除する
        navigationItem.rightBarButtonItem = nil
        //tabbedSearchCollectionViewを非表示にする
        self.tabbedSearchCollectionView?.isHidden = true
        //アニメーション：DimmedViewをゆっくり非表示にする
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }) {done in
            if done {
                // アニメーションが成功した場合、DimmedViewを非表示にする
                self.dimmedView.isHidden = true
            }
            
        }
    }
    
    private func query(_ text: String) {
        //バックエンドでサーチする
        
    }
}



extension ExploreViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView{
            return 0
        }
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        cell.configure(debug: <#T##String#>)
        cell.configure(debug: "test")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == tabbedSearchCollectionView {
            // change search context
            return
        }
//        let model = models[indexPath.row]
        let user = User(username: "joe", bio: "", name: ("", ""), profilePhoto: URL(string: "https://www.google.com")!, birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://www.google.com/")!,
                            postURL: URL(string: "https://www.google.com/")!,
                            caption: nil, likeCount: [], comments: [], createdDate: Date(), taggedUsers: [], owner: user)
        
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
