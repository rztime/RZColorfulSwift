//
//  ViewController.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton.init(type: .custom)
        button.frame = self.view.bounds;
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(tovc), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func tovc() {
        let vc = TestViewController.init();
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

