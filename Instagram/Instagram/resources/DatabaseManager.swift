//
//  DatabaseManager.swift
//  Instagram
//
//  Created by dreaMTank on 2024/06/07.
//
//在数据库中新建用户信息
import FirebaseDatabase


public class DatabaseManager{
    
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //usernameと email　利用可能かどうかを確認
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        
        completion(true)
    }
    
    
    // 新規ユーザーをデーターベースに
    public func insertNewUser(with email: String,username: String, completion: @escaping (Bool) -> Void){
        database.child(email.safeDatabaseKey()).setValue(["username":username]) { error, _ in
            if error == nil {
                //succeeded
                completion(true)
                return
                
            }
            
            else {
                //failed
                completion(false)
                return
            }
            
        }
    }
   
}
    
    

