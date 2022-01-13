//
//  LabelTextClickedViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2022/1/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class LabelTextClickedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let label = UILabel.init()
        label.frame = .init(x: 10, y: 100, width: 400, height: 150)
        label.numberOfLines = 0 
        label.rz.colorfulConfer { confer in
            confer.text("哈哈哈哈\n")?.font(.systemFont(ofSize: 18)).textColor(.black)
            confer.text("可点击文本1")?.font(.systemFont(ofSize: 18)).textColor(.red).tapActionByLable("1111").paragraphStyle?.alignment(.left)
            confer.text("可点击文本2")?.font(.systemFont(ofSize: 18)).textColor(.red).tapActionByLable("22222").paragraphStyle?.alignment(.center)
        }
        label.rz.tapAction { label, tapActionId, range in
            print("tapActionId:\(tapActionId) range:\(range)")
        }
        self.view.addSubview(label)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
