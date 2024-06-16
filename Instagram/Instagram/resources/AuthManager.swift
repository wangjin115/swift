//
//  AuthManager.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/10.
//
//认证功能
import Foundation
import FirebaseAuth

public class  AuthManager {
    
    static let shared = AuthManager()
    
    //MARK: - public
    
    public func registerNewUser(username: String, email: String , password: String, completion: @escaping (Bool) -> Void) {
        //username アベイラブルか
        //email　アベイラブルか
       
        
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) {canCreate in
            if canCreate{
                //account　を　作成する
                
                Auth.auth().createUser(withEmail: email, password: password) { result , error in
                    
                    guard error == nil, result != nil else {
                        completion(false)
                        return
                    }
                    
                    //database　にインサート
               DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        }
                        
                        else {
                            //インサート失敗
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                
                //どちらかのユーザーか存在してないユーザー
                completion(false)
            }
        }
            
    }
    
    
    public func loginUser(username: String?, email: String? , password: String,completion: @escaping (Bool) -> Void) {
        if let email = email {
            
            //イーメールでログイン
            Auth.auth().signIn(withEmail: email, password: password) { authResult,error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
                
            }
        }
        else if let username = username {
            //username でログイン
            print(username)
        }
        
    }
    
    //ログアウト
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print(error)
            completion(false)
            return
        }
    }
    
    
}
