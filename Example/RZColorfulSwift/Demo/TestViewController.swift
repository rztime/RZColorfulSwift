//
//  TestViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2026/7/8.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        var index = 0
        self.view.qbody([
            UIScrollView().qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
            .qbody([
                UILabel().qnumberOfLines(0)
                    .qmakeConstraints({ make in
                        make.edges.equalToSuperview().inset(20)
                        make.width.equalTo(qscreenwidth - 40)
                    })
                    .qthen {
                        $0.activeColorful()
                        $0.rz.colorfulConfer { confer in
                            while index < 1000 {
                                let i = index
                                confer.text("多文本测试")?.font(.systemFont(ofSize: 16)).textColor(.black)
                                confer.text("点击文本")?.font(.systemFont(ofSize: 16)).textColor(.red).clicked { sender, range in
                                    print("----\(i)")
                                }
                                index += 1
                            }
                        }
                    }
            ])
        ])
    }
}
