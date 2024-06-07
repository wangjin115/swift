//
//  listController.swift
//  hello
//
//  Created by dreaMTank on 2024/06/04.
//

import UIKit

class listController: UIViewController{
    
    var dataArray:[String] = []


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0...99{
            dataArray.append("hello:\(index)")
        }
        tableView.delegate=self
        tableView.dataSource=self
        
        tableView.reloadData()
        
        
    }
    


}

extension listController:UITableViewDataSource,UITableViewDelegate{
    
//    有多少个
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
        
    }
//    返回当前位置cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
        cell.textLabel?.text=dataArray[indexPath.row]
        
        return cell
    }
    
    
}
