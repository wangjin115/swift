//
//  ViewController.swift
//  hello
//
//  Created by dreaMTank on 2024/06/03.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var buttonView: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(titleView.text)
        titleView.text="代码设置"
        
        buttonView.addTarget(self, action: #selector(buttonClick2(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        print("点击一下")
        
        sender.setTitle("点过了", for: .normal)
    }
    
    @objc func buttonClick2(_ sender: UIButton) {
        
        print("点击一下22")
    }
    
}
