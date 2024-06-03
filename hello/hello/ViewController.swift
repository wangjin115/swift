//
//  ViewController.swift
//  hello
//
//  Created by dreaMTank on 2024/06/03.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var titleView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(titleView.text)
        titleView.text="代码设置"
        // Do any additional setup after loading the view.
    }

     
    @IBAction func buttonClick(_ sender: UIButton) {
        
        print("点击一下")
    }
}

